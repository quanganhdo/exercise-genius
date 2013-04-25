//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "ExerciseMapViewController.h"
#import "Common.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"

#define kMaxTimeInterval 30
#define kMaxHorizontalAccuracy 20

@interface ExerciseMapViewController ()

@property (nonatomic) CLLocation    *oldLocation;
@property (nonatomic) CrumbPath     *crumbs;
@property (nonatomic) CrumbPathView *crumbView;

@end

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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        alertError(@"Please check your settings.");
    } else {
        alertError(error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSTimeInterval interval = [location.timestamp timeIntervalSinceNow];
    if (fabs(interval) < kMaxTimeInterval) {
        if (location.horizontalAccuracy >= 0 && location.horizontalAccuracy < kMaxHorizontalAccuracy) {
            NSLog(@"Current location: %@", location);

            double grade = 0.0f;
            if (self.oldLocation) {
                CLLocationDistance distance = [location distanceFromLocation:self.oldLocation];
                grade = tan(asin(fabs(location.altitude - self.oldLocation.altitude) / distance));
            }

            NSLog(@"Grade: %f", grade);

            if (!self.crumbs) {
                _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:location.coordinate];
                [self.mapView addOverlay:self.crumbs];

                MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate,
                                                                   MKCoordinateSpanMake(0.005, 0.005));
                [self.mapView setRegion:region animated:NO];
            } else {
                MKMapRect updateRect = [self.crumbs addCoordinate:location.coordinate];
                if (!MKMapRectIsNull(updateRect)) {
                    MKZoomScale scale     = (MKZoomScale) (self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
                    CGFloat     lineWidth = MKRoadWidthAtZoomScale(scale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    [self.crumbView setNeedsDisplayInMapRect:updateRect];
                }
            }

            self.oldLocation = location;
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if (!self.crumbView) {
        _crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return self.crumbView;
}

@end