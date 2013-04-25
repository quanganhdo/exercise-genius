//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "ExerciseMapViewController.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxTimeInterval 30
#define kMaxHorizontalAccuracy 20

@interface ExerciseMapViewController ()

@property (nonatomic) CLLocationManager  *locationManager;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UILabel   *averagePaceLabel;
@property (nonatomic) IBOutlet UILabel   *currentPaceLabel;
@property (nonatomic) IBOutlet UILabel   *distanceLabel;
@property (nonatomic) IBOutlet UILabel   *timeLabel;
@property (nonatomic) IBOutlet UILabel   *intensityLabel;
@property (nonatomic) IBOutlet UIView    *mapContainerView;

@property (nonatomic) CLLocation    *lastLocation;
@property (nonatomic) CrumbPath     *crumbs;
@property (nonatomic) CrumbPathView *crumbView;

@property (nonatomic) CLLocation *originalLocation;
@property (nonatomic) NSTimer    *exerciseTimer;
@property (nonatomic) CLLocationDistance totalDistance;

@property (nonatomic) BOOL isExercising;

- (IBAction)toggleExercise:(UIButton *)button;

@end

@implementation ExerciseMapViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _exerciseType = kExerciseTypeRunning;

    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
}

- (void)updateStats {
    NSTimeInterval interval = fabs([_originalLocation.timestamp timeIntervalSinceNow]);

    self.timeLabel.text        = stringFromInterval(interval);
    self.distanceLabel.text    = stringFromMeter(_totalDistance);
    self.averagePaceLabel.text = stringFromInterval(interval / (_totalDistance / METERS_PER_MILE));
    self.currentPaceLabel.text = self.averagePaceLabel.text;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_exerciseTimer) [_exerciseTimer invalidate];
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
            if (_lastLocation) {
                // Calculate grade
                CLLocationDistance distance = [location distanceFromLocation:_lastLocation];
                grade = tan(asin(fabs(location.altitude - _lastLocation.altitude) / distance));

                // Total distance
                _totalDistance += distance;

                // Intensity
                NSTimeInterval interval = [location.timestamp timeIntervalSinceDate:_lastLocation.timestamp];
                self.intensityLabel.text = intensityForExercise(_exerciseType, distance, interval, grade);
            } else {
                // Start exercise
                _originalLocation = location;
                _totalDistance    = 0;

                _exerciseTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                  target:self
                                                                selector:@selector(updateStats)
                                                                userInfo:nil repeats:YES];
            }

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

            _lastLocation = location;
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if (!self.crumbView) {
        _crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return self.crumbView;
}

#pragma mark - Actions

- (IBAction)toggleExercise:(UIButton *)button {
    if (!_isExercising) {
        [self.locationManager startUpdatingLocation];

        _isExercising = YES;
        [button setTitle:@"Stop" forState:UIControlStateNormal];

        return;
    }

    [self.locationManager stopUpdatingLocation];
    if (_exerciseTimer) [_exerciseTimer invalidate];

    _isExercising = NO;
    [button setTitle:@"Start" forState:UIControlStateNormal];
}

@end