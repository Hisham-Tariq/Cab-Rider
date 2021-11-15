package com.logixseeker.cab_rider

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.NotificationManager;
import android.content.Context;
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "notifications"

    override fun onResume() {
        super.onResume()
        this.clearAppNotifications();
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "clearAppNotifications"){
                val response = this.clearAppNotifications()
                if (response) {
                    result.success(response)
                } else {
                    result.error("Failed", "Unable to clear notficatins.", null)
                }
            } else {
                result.notImplemented()
            }

        }
    }

    private fun clearAppNotifications() : Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager;
        notificationManager.cancelAll()
        return true;
    }
}
