package com.example.lechacals_authenticator

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

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
        val name = widgetData.getString("name", null)
        setTextViewText(R.id.account_name, name ?: "No name")

        val code = widgetData.getString("code", null)
        setTextViewText(R.id.account_code, code ?: "No code")
    }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}