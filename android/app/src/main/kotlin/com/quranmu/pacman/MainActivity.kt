package com.quranmu.pacman

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val WIDGET_CHANNEL = "com.quranmu.pacman/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidgetTheme") {
                try {
                    val appWidgetManager = AppWidgetManager.getInstance(this)
                    val component = ComponentName(this, AyatWidgetProvider::class.java)
                    val appWidgetIds = appWidgetManager.getAppWidgetIds(component)
                    if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                        AyatWidgetProvider().onUpdate(this, appWidgetManager, appWidgetIds)
                    }
                    result.success(true)
                } catch (e: Exception) {
                    result.error("WIDGET_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
