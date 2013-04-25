//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface ExerciseMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager  *locationManager;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UILabel   *averagePaceLabel;
@property (nonatomic) IBOutlet UILabel   *currentPaceLabel;
@property (nonatomic) IBOutlet UILabel   *distanceLabel;
@property (nonatomic) IBOutlet UILabel   *timeLabel;

@end