package com.kn4rfy.rn.geofence

import android.app.IntentService
import android.content.Intent
import android.support.v4.content.LocalBroadcastManager
import com.kn4rfy.rn.geofence.RNGeofenceModule.Companion.MODULE_NAME
import java.util.logging.Logger

class GeofenceTransitionsIntentService : IntentService("BoundaryEventIntentService") {
    override fun onHandleIntent(intent: Intent?) {
        if (intent != null) {
            logger.info("Broadcasting event")
            intent.action = ACTION
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
        }
    }

    companion object {
        private val logger = Logger.getLogger(MODULE_NAME)

        const val ACTION = "RNGeofence.Event"
    }
}