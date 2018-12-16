package com.kn4rfy.rn.geofence

import android.Manifest
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.support.v4.app.ActivityCompat
import android.support.v4.app.ActivityCompat.requestPermissions
import android.support.v4.content.PermissionChecker.checkSelfPermission
import android.util.Log
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.google.android.gms.location.*
import java.util.*

class RNGeofenceModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), LifecycleEventListener {

    private lateinit var geofencingClient: GeofencingClient

    init {
        reactApplicationContext.addLifecycleEventListener(this)
        initialize()
    }

    override fun getName(): String {
        return "Geofence"
    }

    override fun initialize() {
        geofencingClient = LocationServices.getGeofencingClient(reactApplicationContext.baseContext)
    }

    override fun onHostResume() {
        isVisible = true
    }

    override fun onHostPause() {
        isVisible = false
    }

    override fun onHostDestroy() {
        // Activity `onDestroy`
    }

    @ReactMethod
    fun removeAll(promise: Promise) {
        geofencingClient.removeGeofences(geofencePendingIntent)
                .addOnSuccessListener {
                    Log.i(MODULE_NAME, "Successfully removed all geofences")
                    promise.resolve(null)
                }
                .addOnFailureListener { e ->
                    Log.i(MODULE_NAME, "Failed to remove all geofences")
                    promise.reject(e)
                }
    }

    @ReactMethod
    fun startMonitoring(readableMap: ReadableMap, promise: Promise) {
        geofenceList.add(Geofence.Builder()
                // Set the request ID of the geofence. This is a string to identify this
                // geofence.
                .setRequestId(readableMap.getString("identifier"))

                // Set the circular region of this geofence.
                .setCircularRegion(readableMap.getDouble("latitude"), readableMap.getDouble("longitude"), readableMap.getDouble("radius").toFloat())

                // Set the expiration duration of the geofence. This geofence gets automatically
                // removed after this period of time.
                .setExpirationDuration(Geofence.NEVER_EXPIRE)

                // Set the transition types of interest. Alerts are only generated for these
                // transition. We track entry and exit transitions in this sample.
                .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT)

                // Create the geofence.
                .build())

        val geofenceRequestIds = Arguments.createArray()
        for (g in geofenceList) {
            geofenceRequestIds.pushString(g.requestId)
        }

        addGeofences(promise, geofenceRequestIds)
    }


    @ReactMethod
    fun stopMonitoring(readableMap: ReadableMap, promise: Promise) {

        val geofenceRequestIds = ArrayList<String>()
        for (g in geofenceList) {
            geofenceRequestIds.add(g.requestId)
        }

        removeGeofences(promise)
    }

    private fun getGeofencingRequest(): GeofencingRequest {
        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            addGeofences(geofenceList)
        }.build()
    }

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(reactApplicationContext.baseContext, GeofenceTransitionsIntentService::class.java)
        // We use FLAG_UPDATE_CURRENT so that we get the same pending intent back when calling
        // addGeofences() and removeGeofences().
        PendingIntent.getService(reactApplicationContext.baseContext, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }

    private fun addGeofences(promise: Promise, geofenceRequestIds: WritableArray) {
        var permission = ActivityCompat.checkSelfPermission(reactApplicationContext, Manifest.permission.ACCESS_FINE_LOCATION)

        if (permission != PackageManager.PERMISSION_GRANTED) {
            permission = requestPermissions()
        }

        if (permission != PackageManager.PERMISSION_GRANTED) {
            promise.reject("PERM", "Access fine location is not permitted")
        } else {
            geofencingClient.addGeofences(getGeofencingRequest(), geofencePendingIntent)?.run {
                addOnSuccessListener {
                    Log.i(MODULE_NAME, "Successfully added geofence.")
                    promise.resolve(geofenceRequestIds)
                }
                addOnFailureListener { e ->
                    Log.i(MODULE_NAME, "Failed to add geofence.")
                    promise.reject(e)
                }
            }
        }
    }

    private fun removeGeofences(promise: Promise) {
        Log.i(MODULE_NAME, "Attempting to remove geofence.")

        geofencingClient.removeGeofences(geofencePendingIntent)?.run {
            addOnSuccessListener {
                Log.i(MODULE_NAME, "Successfully removed geofence.")
                promise.resolve(null)
            }
            addOnFailureListener { e ->
                Log.i(MODULE_NAME, "Failed to remove geofence.")
                promise.reject(e)
            }
        }
    }

    private fun sendEvent(event: String, params: Any) {
        Log.i(MODULE_NAME, "Sending events $event")
        reactApplicationContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(event, params)
        Log.i(MODULE_NAME, "Sent events")
    }

    private fun requestPermissions(): Int {
        requestPermissions(currentActivity!!,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION), 1)

        return checkSelfPermission(reactApplicationContext, Manifest.permission.ACCESS_FINE_LOCATION)
    }

    inner class GeofenceEventBroadcastReceiver : BroadcastReceiver() {

        override fun onReceive(context: Context, intent: Intent) {
            val geofencingEvent = GeofencingEvent.fromIntent(intent)

            Log.e(MODULE_NAME, "GEOFENCING: " + geofencingEvent.geofenceTransition)
            if (geofencingEvent.hasError()) {
                Log.e(MODULE_NAME, "Error in handling geofence " + GeofenceErrorMessages.getErrorString(geofencingEvent.errorCode))
                return
            }
            when (geofencingEvent.geofenceTransition) {
                Geofence.GEOFENCE_TRANSITION_ENTER -> {
                    Log.i(MODULE_NAME, "Enter geofence event detected. Sending event.")
                    val writableArray = Arguments.createArray()
                    for (geofence in geofencingEvent.triggeringGeofences) {
                        writableArray.pushString(geofence.requestId)
                    }
                    sendEvent(DID_ENTER, writableArray)
                }
                Geofence.GEOFENCE_TRANSITION_EXIT -> {
                    Log.i(MODULE_NAME, "Exit geofence event detected. Sending event.")
                    val writableArray = Arguments.createArray()
                    for (geofence in geofencingEvent.triggeringGeofences) {
                        writableArray.pushString(geofence.requestId)
                    }
                    sendEvent(DID_EXIT, writableArray)
                }
            }
        }
    }

    companion object {
        const val DID_ENTER = "didEnterRegion"
        const val DID_EXIT = "didExitRegion"
        const val MODULE_NAME = "RNGeofence"

        private var isVisible = false
        private var geofenceList = ArrayList<Geofence>()
    }
}