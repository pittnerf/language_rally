package com.example.language_rally

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        // Workaround for blank screen after Samsung Freezess (or any OS-level
        // process suspension). When the process is unfrozen and the Flutter
        // surface is recreated, the rendering pipeline can stall in DRAW_PENDING
        // indefinitely. Posting an invalidate to the decor view forces Android's
        // Choreographer to fire a new vsync signal, which wakes up the raster
        // thread and allows Flutter to draw the first frame.
        window.decorView.post {
            window.decorView.invalidate()
        }
    }
}
