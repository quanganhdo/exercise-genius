//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#define SECONDS_PER_MINUTE (60)
#define MINUTES_PER_HOUR (60)
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * MINUTES_PER_HOUR)
#define HOURS_PER_DAY (24)

#define METERS_PER_MILE 1609.34

typedef enum {
    kExerciseTypeWalking = 0,
    kExerciseTypeRunning = 1
} ExerciseType;

void alertMessage(id error);

NSString *stringFromInterval(NSTimeInterval timeInterval);
NSString *stringFromMeter(CLLocationDistance distance);

double metsForExercise(ExerciseType type, CLLocationDistance distance, NSTimeInterval interval, double grade);
NSString *intensityForExercise(ExerciseType type, CLLocationDistance distance, NSTimeInterval interval, double grade);
double gradeBetweenLocations(CLLocation *location1, CLLocation *location2, double distance);