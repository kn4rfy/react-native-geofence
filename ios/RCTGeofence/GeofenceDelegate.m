//
//  GeofenceDelegate.m
//  GeofenceDelegate
//
//  Created by Francis Knarfy Elopre on 03/08/2017.
//  Copyright © 2017 Francis Knarfy Elopre. All rights reserved.
//

#import "RCTGeofence.h"
#import "GeofenceDelegate.h"

@implementation GeofenceDelegate

-(instancetype)init
{
  self = [super init];
  if (self) {
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
  }

  return self;
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
  //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"you are at office!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
  //    [alert show];
    
    [[RCTGeofence alloc] jsEventSender:@"didEnterRegion" body:@"success"];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLCircularRegion *)regions{
  NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager stopMonitoringForRegion:(CLCircularRegion *)region
{
  NSLog(@"stopMonitoringForRegion");
}

- (void)startMonitoring:(NSDictionary*)args
{
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
}

- (void)stopMonitoring:(NSDictionary*)args
{
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
}

@end
