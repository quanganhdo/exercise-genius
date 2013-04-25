//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Exercise.h"


@implementation Exercise {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%.2f miles • %d minutes",
                                      _distance / METERS_PER_MILE,
                                      (int) (_interval / SECONDS_PER_MINUTE)];
}


@end