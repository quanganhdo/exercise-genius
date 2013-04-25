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
#define SECONDS_PER_MINUTE (60)
#define MINUTES_PER_HOUR (60)
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * MINUTES_PER_HOUR)
#define HOURS_PER_DAY (24)

    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int ti = (int) round(timeInterval);

    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (ti / SECONDS_PER_HOUR) % HOURS_PER_DAY, (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR,
                                      ti % SECONDS_PER_MINUTE];

#undef SECONDS_PER_MINUTE
#undef MINUTES_PER_HOUR
#undef SECONDS_PER_HOUR
#undef HOURS_PER_DAY
}

NSString *stringFromMeter(CLLocationDistance distance) {
#define METERS_PER_MILE 1609.34

    return [NSString stringWithFormat:@"%.2f miles", distance / METERS_PER_MILE];

#undef METERS_PER_MILE 1609.34
}