// functions/index.js
//
// Firebase Cloud Function: getPackageDownloadUrl
//
// Called by the Flutter app after a purchase is confirmed by RevenueCat.
// Verifies the entitlement via the RevenueCat REST API, then returns a
// short-lived signed download URL for the ZIP in Firebase Storage.
//
// Setup:
//  1. Set the RevenueCat secret key:
//       firebase functions:secrets:set REVENUECAT_SECRET_KEY
//  2. Deploy:
//       firebase deploy --only functions

const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');

admin.initializeApp();

const revenueCatSecretKey = defineSecret('REVENUECAT_SECRET_KEY');

/**
 * Callable function: getPackageDownloadUrl
 *
 * Request payload:
 *   { productId: string, revenueCatUserId: string }
 *
 * Response:
 *   { downloadUrl: string }   — signed URL valid for 60 minutes
 */
exports.getPackageDownloadUrl = onCall(
  { secrets: [revenueCatSecretKey] },
  async (request) => {
    // ── Auth check ──────────────────────────────────────────────────────────
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be signed in.');
    }

    const { productId, revenueCatUserId } = request.data;
    if (!productId || !revenueCatUserId) {
      throw new HttpsError('invalid-argument', 'productId and revenueCatUserId required.');
    }

    // ── 1. Verify entitlement via RevenueCat REST API ───────────────────────
    const fetch = (await import('node-fetch')).default;
    const rcResponse = await fetch(
      `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(revenueCatUserId)}`,
      {
        headers: {
          Authorization: `Bearer ${revenueCatSecretKey.value()}`,
          'Content-Type': 'application/json',
        },
      }
    );

    if (!rcResponse.ok) {
      console.error('RevenueCat API error:', rcResponse.status, await rcResponse.text());
      throw new HttpsError('internal', 'Could not verify purchase with RevenueCat.');
    }

    const rcData = await rcResponse.json();
    const entitlements = rcData?.subscriber?.entitlements ?? {};
    const entitlement = entitlements[productId];

    if (!entitlement || entitlement.expires_date) {
      // expires_date is null for non-consumables (active forever).
      // If it's set and in the past, the entitlement has expired.
      const expired = entitlement?.expires_date
        ? new Date(entitlement.expires_date) < new Date()
        : false;

      if (!entitlement || expired) {
        throw new HttpsError('permission-denied', 'Purchase not found or expired.');
      }
    }

    // ── 2. Look up storagePath from Firestore ───────────────────────────────
    const doc = await admin
      .firestore()
      .collection('store_products')
      .where('productId', '==', productId)
      .limit(1)
      .get();

    if (doc.empty) {
      throw new HttpsError('not-found', `Product ${productId} not found in catalog.`);
    }

    const storagePath = doc.docs[0].data().storagePath;
    if (!storagePath) {
      throw new HttpsError('internal', 'Storage path not configured for this product.');
    }

    // ── 3. Generate a signed download URL (valid 60 minutes) ────────────────
    const bucket = admin.storage().bucket();
    const file = bucket.file(storagePath);

    const [exists] = await file.exists();
    if (!exists) {
      throw new HttpsError('not-found', `Package file not found: ${storagePath}`);
    }

    const [signedUrl] = await file.getSignedUrl({
      action: 'read',
      expires: Date.now() + 60 * 60 * 1000, // 60 minutes
    });

    console.log(`Signed URL generated for user ${revenueCatUserId}, product ${productId}`);
    return { downloadUrl: signedUrl };
  }
);

