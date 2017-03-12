/*
  React Native Speech Notification Plugin
  https://github.com/kn4rfy/react-native-geofence

  Created by FRANCIS KNARFY ELOPRE
  https://github.com/kn4rfy

  MIT License
*/

'use strict';

var { DeviceEventEmitter, NativeModules } = require('react-native');
const RNGeofence = NativeModules.Geofence;

var Geofence = {
  startMonitoring: function(params) {
    RNGeofence.startMonitoring(params);
  },
  stopMonitoring: function(params) {
    RNGeofence.stopMonitoring(params);
  }
};

module.exports = Geofence;
