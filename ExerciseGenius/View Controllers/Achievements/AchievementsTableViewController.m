//
//  Created by Anh Quang Do on 4/26/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "AchievementsTableViewController.h"
#import "Achievement.h"

@interface AchievementsTableViewController ()

@property (nonatomic) NSArray *achievements;

@end

@implementation AchievementsTableViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.achievements = @[
            @[
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:3 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:7 completed:NO ],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:14 completed:NO ],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:30 completed:NO ],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:90 completed:NO ],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:365 completed:NO ]
            ], @[
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:0.5 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:1 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:3 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:7 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:10 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:26 completed:NO ]
            ], @[
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:15 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:30 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:60 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:90 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:120 completed:YES ],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:240 completed:NO ]
            ],
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.achievements count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.achievements[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Achievement"];

    Achievement *achievement = self.achievements[indexPath.section][indexPath.row];
    cell.textLabel.text  = [achievement description];
    cell.imageView.image = [UIImage imageNamed:achievement.completed ? @"complete.png" : @"incomplete.png"];

    return cell;
}

@end