package com.example.lechacals_authenticator

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * Implementation of App Widget functionality.
 */
class LeChacalsAuthenticatorWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData = HomeWidgetPlugin.getData(context)
    val views = RemoteViews(context.packageName, R.layout.le_chacals_authenticator_widget).apply {
        val imageName = widgetData.getString("screenshot", null)

        if (imageName != null) {
            val imageFile = File(imageName)

            if (imageFile.exists()) {
                val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                setImageViewBitmap(R.id.image, myBitmap)
            } else {
                println("[log] Image not found!, looked @: $imageName")
                setImageViewResource(R.id.image, android.R.drawable.ic_dialog_info)
            }
        } else {
            println("[log] No screenshot saved yet")
            setImageViewResource(R.id.image, android.R.drawable.ic_dialog_info)
        }
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}