//
//  Created by Anh Quang Do on 4/26/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Achievement.h"


@implementation Achievement {

}

- (id)initWithType:(AchievementType)_type andValue:(NSInteger)_value {
    self = [super init];
    if (self) {
        self.type  = _type;
        self.value = _value;
    }

    return self;
}

+ (id)achievementWithType:(AchievementType)_type andValue:(NSInteger)_value {
    return [[self alloc] initWithType:_type andValue:_value];
}


- (NSString *)description {
    NSString *retVal;

    switch (_type) {
        case AchievementTypeConsecutiveDays:
            retVal = [NSString stringWithFormat:@"%d consecutive days", _value];
            break;
        case AchievementTypeTotalDistance:
            retVal = [NSString stringWithFormat:@"%d miles in one session", _value];
            break;
        case AchievementTypeTotalTime:
            retVal = [NSString stringWithFormat:@"%d minutes in one session", _value];
            break;
    }

    return retVal;
}

@end