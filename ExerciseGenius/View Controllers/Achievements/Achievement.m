//
//  Created by Anh Quang Do on 4/26/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Achievement.h"


@implementation Achievement {

}

- (id)initWithType:(AchievementType)_type andValue:(NSInteger)_value completed:(BOOL)_completed {
    self = [super init];
    if (self) {
        self.type      = _type;
        self.value     = _value;
        self.completed = _completed;
    }

    return self;
}

+ (id)achievementWithType:(AchievementType)_type andValue:(NSInteger)_value completed:(BOOL)_completed {
    return [[self alloc] initWithType:_type andValue:_value completed:_completed];
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