package com.example.lechacals_authenticator

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.BitmapFactory
import android.widget.RemoteViews

class LeChacalsAuthenticatorWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val screenshotPath = sharedPref.getString("screenshot", null)

            val views = RemoteViews(context.packageName, R.layout.le_chacals_authenticator_widget)

            if (screenshotPath != null) {
                val bitmap = BitmapFactory.decodeFile(screenshotPath)
                views.setImageViewBitmap(R.id.image, bitmap)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}