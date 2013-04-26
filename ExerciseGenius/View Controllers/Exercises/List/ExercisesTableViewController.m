//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "ExercisesTableViewController.h"
#import "Exercise.h"
#import "ExerciseMapViewController.h"
#import "HealthVault.h"
#import "HealthVaultService.h"
#import "WebViewController.h"

#define kUserDefaultsExercisesKey @"kUserDefaultsExercisesKey"

@interface ExercisesTableViewController ()

@property (nonatomic) NSMutableArray *exercises;

+ (NSDateFormatter *)dateFormatter;

- (IBAction)startSyncing;

@end

@implementation ExercisesTableViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsExercisesKey];
        if (data) {
            _exercises = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        } else {
            _exercises = [[NSMutableArray alloc] init];
        }
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
    }

    Exercise *exercise = self.exercises[indexPath.row];
    cell.textLabel.text       = [[ExercisesTableViewController dateFormatter] stringFromDate:exercise.date];
    cell.detailTextLabel.text = [exercise description];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.exercises removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];

        [self save];
    }
}


#pragma mark - Actions

- (IBAction)addExercise:(UIStoryboardSegue *)segue {
    ExerciseMapViewController *vc = segue.sourceViewController;
    if (vc.exerciseToAdd) {
        [self.exercises insertObject:vc.exerciseToAdd atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];

        [self save];
    }
}

- (IBAction)finishShellAuthentication:(UIStoryboardSegue *)segue {
    WebViewController *vc = segue.sourceViewController;
    if (vc.isSuccess) {
        // Retry
        [self startSyncing];
    }
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.exercises];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsExercisesKey];
}

- (IBAction)startSyncing {
    [[HealthVault mainVault] performAuthenticationCheckOnAuthenticationCompleted:^(HealthVaultService *service, HealthVaultResponse *response) {
        // Duh
        if (response.hasError) {
            alertError(@"Please try again.");

            return;
        }

        if (!service.currentRecord && service.records && [service.records count] > 0) {
            // Yay
            [[HealthVault mainVault] updateCurrentRecord:service.records[0]];
        } else if (!service.records) {
            // Duh
            alertError(@"Your HealthVault account doesn't have any records.");
        }

        if (service.records) {
            // Things went well
            LOG_EXPR([service.records[0] recordName]);

            self.navigationItem.rightBarButtonItem.enabled = NO;

            // Submit
            [[HealthVault mainVault] putExercises:self.exercises onCompletion:^(HealthVaultService *service, HealthVaultResponse *response) {
                // Duh
                if (response.hasError) {
                    alertError(response.errorText);

                    return;
                }

                // TODO: Update exercises
                LOG_EXPR(response.responseXml);

                self.navigationItem.rightBarButtonItem.enabled = YES;
            }];
        }
    }                                                          shellAuthRequired:^(HealthVaultService *service, HealthVaultResponse *response) {
        // Duh
        if (response.hasError) {
            alertError(response.errorText);

            // TODO: return?
        }

        [self performSegueWithIdentifier:@"doShellAuth" sender:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"doShellAuth"]) {
        WebViewController *vc = segue.destinationViewController;
        vc.URL = [[HealthVault mainVault] URL];
    }
}

@end