//
//  RCTGeofence.m
//  RCTGeofence
//
//  Created by Francis Knarfy Elopre on 03/08/2017.
//  Copyright © 2017 Francis Knarfy Elopre. All rights reserved.
//

#import "RCTGeofence.h"
#import <React/RCTLog.h>

@implementation RCTGeofence

@synthesize geofenceDelegate;

RCT_EXPORT_MODULE()

-(instancetype)init
{
  self = [super init];
  if (self) {
    geofenceDelegate = [[GeofenceDelegate alloc] init];
  }

  return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"didEnterRegion"];
}

RCT_EXPORT_METHOD(startMonitoring:(NSDictionary *)args)
{
  RCTLogInfo(@"RCTGeofence #startMonitoring");
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [geofenceDelegate startMonitoring:args];
  });
}

RCT_EXPORT_METHOD(stopMonitoring:(NSDictionary *)args)
{
  RCTLogInfo(@"RCTGeofence #stopMonitoring");
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [geofenceDelegate stopMonitoring:args];
  });
    
    [self sendEventWithName:@"didEnterRegion" body:@"success"];
}

RCT_EXPORT_METHOD(jsEventSender:(NSString *)name body:(id)body)
{
    [self sendEventWithName:@"didEnterRegion" body:@{@"response":body}];
}

@end
