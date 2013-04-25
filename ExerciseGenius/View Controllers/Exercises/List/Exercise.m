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

#pragma mark - Keyed

- (void)encodeWithCoder:(NSCoder *)encoder {
//    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.title forKey:@"title"];
//    [encoder encodeObject:self.date forKey:@"date"];
//    [encoder encodeDouble:self.distance forKey:@"distance"];
//    [encoder encodeDouble:self.interval forKey:@"interval"];
//    [encoder encodeObject:self.detail forKey:@"detail"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.type     = (ExerciseType) [decoder decodeIntegerForKey:@"type"];
        self.title    = [decoder decodeObjectForKey:@"title"];
        self.date     = [decoder decodeObjectForKey:@"date"];
        self.distance = [decoder decodeDoubleForKey:@"distance"];
        self.interval = [decoder decodeDoubleForKey:@"interval"];
        self.detail   = [decoder decodeObjectForKey:@"detail"];
    }
    return self;
}

@end