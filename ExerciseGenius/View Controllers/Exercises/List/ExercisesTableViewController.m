//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "ExercisesTableViewController.h"
#import "Exercise.h"
#import "ExerciseMapViewController.h"

@interface ExercisesTableViewController ()

@property (nonatomic) NSMutableArray *exercises;

+ (NSDateFormatter *)dateFormatter;

@end

@implementation ExercisesTableViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self performSegueWithIdentifier:@"addExercise" sender:nil];
}

NSString *const kCachedDateFormatterKey = @"CachedDateFormatterKey";

+ (NSDateFormatter *)dateFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter     *dateFormatter    = [threadDictionary objectForKey:kCachedDateFormatterKey];
    if (!dateFormatter) {
        dateFormatter             = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        [threadDictionary setObject:dateFormatter forKey:kCachedDateFormatterKey];
    }
    return dateFormatter;
}

- (NSMutableArray *)exercises {
    if (!_exercises) {
        _exercises = [[NSMutableArray alloc] init];
    }

    return _exercises;
}


#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Exercise"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Exercise"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Exercise *exercise = self.exercises[indexPath.row];
    cell.textLabel.text       = [[ExercisesTableViewController dateFormatter] stringFromDate:exercise.date];
    cell.detailTextLabel.text = [exercise description];

    return cell;
}

#pragma mark - Actions

- (IBAction)addExercise:(UIStoryboardSegue *)segue {
    ExerciseMapViewController *vc = segue.sourceViewController;
    if (vc.exerciseToAdd) {
        [self.exercises insertObject:vc.exerciseToAdd atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end