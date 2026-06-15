package com.languagerally.app

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Match Android 15 edge-to-edge behavior on older Android versions too.
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

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
