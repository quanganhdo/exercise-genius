//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "Common.h"

void alertError(id error) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error isKindOfClass:[NSError class]] ? [error localizedDescription] : error
                               delegate:nil cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
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