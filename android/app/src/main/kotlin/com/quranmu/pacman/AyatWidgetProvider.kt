package com.quranmu.pacman

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import com.quranmu.pacman.MainActivity
import java.util.Calendar
import java.io.BufferedReader
import java.io.InputStreamReader
import org.json.JSONArray

data class WidgetVerse(
    val surahNama: String,
    val surahNomor: Int,
    val ayatNomor: Int,
    val teksArab: String,
    val terjemahan: String,
    val tema: String = ""
)

class AyatWidgetProvider : AppWidgetProvider() {
    companion object {
        private const val TAG = "AyatWidget"

        // Load verses from JSON resource (res/raw/daily_verses.json)
        private fun loadDailyVerses(context: Context): List<WidgetVerse> {
            val verses = mutableListOf<WidgetVerse>()
            try {
                val resId = context.resources.getIdentifier("daily_verses", "raw", context.packageName)
                val inputStream = if (resId != 0) {
                    context.resources.openRawResource(resId)
                } else {
                    context.resources.openRawResource(R.raw.daily_verses)
                }
                BufferedReader(InputStreamReader(inputStream)).use { reader ->
                    val json = reader.readText()
                    val jsonArray = JSONArray(json)
                    for (i in 0 until jsonArray.length()) {
                        val obj = jsonArray.getJSONObject(i)
                        verses.add(
                            WidgetVerse(
                                surahNama = obj.getString("surahNama"),
                                surahNomor = obj.getInt("surahNomor"),
                                ayatNomor = obj.getInt("ayatNomor"),
                                teksArab = obj.getString("teksArab"),
                                terjemahan = obj.getString("terjemahan"),
                                tema = if (obj.has("tema")) obj.getString("tema") else ""
                            )
                        )
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed to load daily verses: ${e.message}", e)
            }
            return verses
        }

        fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            try {
                val calendar = Calendar.getInstance()
                val year = calendar.get(Calendar.YEAR)
                val month = calendar.get(Calendar.MONTH) + 1
                val day = calendar.get(Calendar.DAY_OF_MONTH)
                val hour = calendar.get(Calendar.HOUR_OF_DAY)

                // Berganti setiap 8 jam: (00:00-08:00, 08:00-16:00, 16:00-24:00)
                val dayNumber = year * 366 + month * 31 + day
                val period = hour / 8 // 0, 1, 2
                val verses = loadDailyVerses(context)
                if (verses.isEmpty()) return
                val index = ((dayNumber * 3 + period) % verses.size).let { if (it < 0) it + verses.size else it }
                val verse = verses[index]

                val periodLabel = when (period) {
                    0 -> "Pagi Dini (00:00 - 08:00)"
                    1 -> "Siang Hari (08:00 - 16:00)"
                    else -> "Malam Hari (16:00 - 24:00)"
                }

                val views = RemoteViews(context.packageName, R.layout.ayat_widget_layout)

                views.setTextViewText(R.id.widget_surah_ref, "QS. ${verse.surahNama}: ${verse.ayatNomor}")
                views.setTextViewText(R.id.widget_ayat_arabic, verse.teksArab)
                views.setTextViewText(R.id.widget_ayat_translation, "\"${verse.terjemahan}\"")
                views.setTextViewText(R.id.widget_ayat_period, if (verse.tema.isNotEmpty()) "$periodLabel • ${verse.tema}" else periodLabel)

                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to update widget $appWidgetId: ${e.message}", e)
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        try {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, AyatWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(component)
            if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onReceive: ${e.message}", e)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        try {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, AyatWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(component)
            if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onEnabled: ${e.message}", e)
        }
    }
}
