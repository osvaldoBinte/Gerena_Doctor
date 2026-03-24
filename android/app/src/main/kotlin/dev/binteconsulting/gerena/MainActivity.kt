package dev.binteconsulting.gerena

import android.os.Bundle
import android.os.Build
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // 👇 Fuerza modo claro sin necesitar AppCompatDelegate
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.decorView.isForceDarkAllowed = false
        }
        setTheme(R.style.NormalTheme)
        super.onCreate(savedInstanceState)
    }
}