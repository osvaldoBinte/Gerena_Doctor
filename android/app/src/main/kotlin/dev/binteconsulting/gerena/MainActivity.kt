package dev.binteconsulting.gerena

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Fuerza el tema antes de llamar a super
        setTheme(R.style.NormalTheme)
        super.onCreate(savedInstanceState)
    }
}