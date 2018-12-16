package com.kn4rfy.rn.geofence

import com.google.android.gms.location.GeofenceStatusCodes

object GeofenceErrorMessages {

    /**
     * Returns the error string for a geofencing error code.
     */
    fun getErrorString(errorCode: Int): String {
        return when (errorCode) {
            GeofenceStatusCodes.GEOFENCE_NOT_AVAILABLE -> "Geofence is not available"
            GeofenceStatusCodes.GEOFENCE_TOO_MANY_GEOFENCES -> "Too many geofences"
            GeofenceStatusCodes.GEOFENCE_TOO_MANY_PENDING_INTENTS -> "Too many pending intents"
            else -> "Unknown error: " + Integer.toString(errorCode)
        }
    }
}