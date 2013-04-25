//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "ExerciseMapViewController.h"


@implementation ExerciseMapViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    [self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate        = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.activityType    = CLActivityTypeFitness;
        _locationManager.distanceFilter  = 1; // meter
    }

    return _locationManager;
}


@end