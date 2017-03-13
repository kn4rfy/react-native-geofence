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

RCT_EXPORT_MODULE()

-(instancetype)init
{
    self = [super init];
    if (self) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
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
      NSString *identifier = [args objectForKey:@"identifier"];
      NSNumber *latitude = [args objectForKey:@"latitude"];
      NSNumber *longitude = [args objectForKey:@"longitude"];
      NSNumber *radius = [args objectForKey:@"radius"];
      NSObject *region = [CLCircularRegion alloc];
      
      if([CLLocationManager regionMonitoringAvailable]){
          if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
              CLLocationCoordinate2D center = CLLocationCoordinate2DMake((CLLocationDegrees)[latitude doubleValue], (CLLocationDegrees)[longitude doubleValue]);
              region = [[CLCircularRegion alloc]initWithCenter:center radius:25 identifier:identifier];
              [self->locationManager startMonitoringForRegion:region];
          } else {
              [self->locationManager requestAlwaysAuthorization];
          }
      }
  });
}

RCT_EXPORT_METHOD(stopMonitoring:(NSDictionary *)args)
{
  RCTLogInfo(@"RCTGeofence #stopMonitoring");
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSString *identifier = [args objectForKey:@"identifier"];
      NSNumber *latitude = [args objectForKey:@"latitude"];
      NSNumber *longitude = [args objectForKey:@"longitude"];
      NSNumber *radius = [args objectForKey:@"radius"];
      NSObject *region = [CLCircularRegion alloc];
      
      if([CLLocationManager regionMonitoringAvailable]){
          if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
              CLLocationCoordinate2D center = CLLocationCoordinate2DMake((CLLocationDegrees)[latitude doubleValue], (CLLocationDegrees)[longitude doubleValue]);
              region = [[CLCircularRegion alloc]initWithCenter:center radius:25 identifier:identifier];
              [self->locationManager stopMonitoringForRegion:region];
          } else {
              [self->locationManager requestAlwaysAuthorization];
          }
      }
  });
}

- (void)locationManager:(CLLocationManager *)manager startMonitoringForRegion:(CLCircularRegion *)region
{
    NSLog(@"startMonitoringForRegion");
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLCircularRegion *)regions {
    NSLog(@"didStartMonitoringForRegion");
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLCircularRegion *)regions withError:(nonnull NSError *)error{
    NSLog(@"monitoringDidFailForRegion");
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLCircularRegion *)regions{
    NSLog(@"didEnterRegion");
    
    [self sendEventWithName:@"didEnterRegion" body:@"success"];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLCircularRegion *)regions{
    NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager stopMonitoringForRegion:(CLCircularRegion *)region
{
    NSLog(@"stopMonitoringForRegion");
}

@end
