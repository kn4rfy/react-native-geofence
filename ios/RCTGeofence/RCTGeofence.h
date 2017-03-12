//
//  RCTGeofence.h
//  RCTGeofence
//
//  Created by Francis Knarfy Elopre on 03/08/2017.
//  Copyright © 2017 Francis Knarfy Elopre. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "GeofenceDelegate.h"

@interface RCTGeofence : RCTEventEmitter <RCTBridgeModule>

@property (nonatomic, strong) GeofenceDelegate* geofenceDelegate;

-(void)jsEventSender:(NSString *)name body:(id)body;

@end
