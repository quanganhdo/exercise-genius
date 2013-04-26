//
//  Created by Anh Quang Do on 4/26/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum {
    AchievementTypeConsecutiveDays = 0,
    AchievementTypeTotalDistance   = 1,
    AchievementTypeTotalTime       = 2
} AchievementType;

@interface Achievement : NSObject

@property (nonatomic) AchievementType type;
@property (nonatomic) NSInteger       value;
@property (nonatomic) BOOL            completed;

- (id)initWithType:(AchievementType)_type andValue:(NSInteger)_value;
+ (id)achievementWithType:(AchievementType)_type andValue:(NSInteger)_value;

@end