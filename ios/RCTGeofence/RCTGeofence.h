//
//  RCTGeofence.h
//  RCTGeofence
//
//  Created by Francis Knarfy Elopre on 03/08/2017.
//  Copyright © 2017 Francis Knarfy Elopre. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <CoreLocation/CoreLocation.h>

@interface RCTGeofence : RCTEventEmitter <RCTBridgeModule, CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
}

@end
