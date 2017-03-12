//
//  GeofenceDelegate.h
//  GeofenceDelegate
//
//  Created by Francis Knarfy Elopre on 03/08/2017.
//  Copyright © 2017 Francis Knarfy Elopre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GeofenceDelegate : UIViewController <CLLocationManagerDelegate>
{
  CLLocationManager* locationManager;
}

- (void)startMonitoring:(NSDictionary*)args;

- (void)stopMonitoring:(NSDictionary*)args;

@end
