package com.example.chargeguardian

import android.Manifest
import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.widget.LinearLayout
import android.widget.TextView
import android.view.Gravity

class MainActivity : Activity() {
    private var receiver: BatteryReceiver? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val layout = LinearLayout(this)
        layout.orientation = LinearLayout.VERTICAL
        layout.gravity = Gravity.CENTER
        layout.setPadding(32, 32, 32, 32)
        val title = TextView(this)
        title.text = "100% Charge Guardian"
        title.textSize = 26f
        title.gravity = Gravity.CENTER
        val info = TextView(this)
        info.text = "\nBattery alerts are enabled while Android delivers battery updates.\n\nAt 100%: full-charge reminder.\nBelow 15%: connect-charger notification.\n\nThis app cannot block other apps or lock the phone."
        info.textSize = 17f
        info.gravity = Gravity.CENTER
        layout.addView(title)
        layout.addView(info)
        setContentView(layout)

        if (Build.VERSION.SDK_INT >= 33 &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 100)
        }
        receiver = BatteryReceiver()
        registerReceiver(receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    override fun onDestroy() {
        receiver?.let {
            try { unregisterReceiver(it) } catch (_: Exception) {}
        }
        receiver = null
        super.onDestroy()
    }
}
