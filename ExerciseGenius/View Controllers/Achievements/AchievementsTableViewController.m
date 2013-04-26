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
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:3],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:7],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:14],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:30],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:90],
                    [Achievement achievementWithType:AchievementTypeConsecutiveDays andValue:365]
            ], @[
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:0.5],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:1],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:3],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:7],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:10],
                    [Achievement achievementWithType:AchievementTypeTotalDistance andValue:26]
            ], @[
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:15],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:30],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:60],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:90],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:120],
                    [Achievement achievementWithType:AchievementTypeTotalTime andValue:240]
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