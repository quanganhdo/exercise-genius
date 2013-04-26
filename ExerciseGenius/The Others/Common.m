//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Common.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"

void alertMessage(UIView *view, BOOL isError, id message) {
    id notice = nil;
    message = [message isKindOfClass:[NSError class]] ? [message localizedDescription] : message;

    if (isError) {
        notice = [WBErrorNoticeView errorNoticeInView:view title:@"Error" message:message];
    } else {
        notice = [WBSuccessNoticeView successNoticeInView:view title:message];
    }

    [notice show];
}

NSString *stringFromInterval(NSTimeInterval timeInterval) {
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int ti = (int) round(timeInterval);

    if (ti < SECONDS_PER_HOUR) {
        return [NSString stringWithFormat:@"%.2d:%.2d", (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR,
                                          ti % SECONDS_PER_MINUTE];
    }

    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (ti / SECONDS_PER_HOUR) % HOURS_PER_DAY, (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR,
                                      ti % SECONDS_PER_MINUTE];
}


NSString *stringFromMeter(CLLocationDistance distance) {
    return [NSString stringWithFormat:@"%.2f miles", distance / METERS_PER_MILE];
}

double metsForExercise(ExerciseType type, CLLocationDistance distance, NSTimeInterval interval, double grade) {
    double c1 = 0, c2 = 0;
    if (type == kExerciseTypeWalking) {
        c1 = 0.1f;
        c2 = 1.8f;
    } else if (type == kExerciseTypeRunning) {
        c1 = 0.2f;
        c2 = 0.9f;
    }

    interval /= SECONDS_PER_MINUTE;

    return ((c1 * distance / interval + c2 * distance / interval * grade) + 3.5) / 3.5;
}

NSString *intensityForExercise(ExerciseType type, CLLocationDistance distance, NSTimeInterval interval, double grade) {
    double mets = metsForExercise(type, distance, interval, grade);

    LOG_EXPR(mets);

    if (mets < 3.0f) {
        return @"light";
    } else if (mets < 5.9f) {
        return @"moderate";
    } else {return @"vigorous";}
}

double gradeBetweenLocations(CLLocation *location1, CLLocation *location2, double distance) {
    return tan(asin(fabs(location1.altitude - location2.altitude) / distance));
}