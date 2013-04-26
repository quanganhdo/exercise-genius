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
#import "XMLReader.h"
#import "CKSparkline.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define kUserDefaultsExercisesKey @"kUserDefaultsExercisesKey"

@interface ExercisesTableViewController ()

@property (nonatomic) NSMutableArray       *exercises;
@property (nonatomic) IBOutlet UIView      *summaryView;
@property (nonatomic) IBOutlet UILabel     *totalDistanceLabel;
@property (nonatomic) IBOutlet UILabel     *totalTimeLabel;
@property (nonatomic) IBOutlet CKSparkline *sparkView;

+ (NSDateFormatter *)dateFormatter;

- (IBAction)startSyncing;

@end

@implementation ExercisesTableViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.summaryView.layer.borderWidth = 1;
    self.summaryView.layer.borderColor = self.tableView.separatorColor.CGColor;
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

            Exercise *ex1 = [[Exercise alloc] init];
            ex1.type     = kExerciseTypeRunning;
            ex1.date     = [NSDate dateWithTimeIntervalSinceNow:-SECONDS_PER_MINUTE* MINUTES_PER_HOUR * HOURS_PER_DAY];
            ex1.interval = 15 * SECONDS_PER_MINUTE;
            ex1.distance = 2000;
            [_exercises addObject:ex1];

            Exercise *ex2 = [[Exercise alloc] init];
            ex2.type     = kExerciseTypeRunning;
            ex2.date     = [NSDate dateWithTimeIntervalSinceNow:-round(SECONDS_PER_MINUTE* MINUTES_PER_HOUR * HOURS_PER_DAY * 2.5)];
            ex2.interval = 5 * SECONDS_PER_MINUTE;
            ex2.distance = 500;
            [_exercises addObject:ex2];

            Exercise *ex3 = [[Exercise alloc] init];
            ex3.type     = kExerciseTypeRunning;
            ex3.date     = [NSDate dateWithTimeIntervalSinceNow:-round(SECONDS_PER_MINUTE* MINUTES_PER_HOUR * HOURS_PER_DAY* 4.5)];
            ex3.interval = 180 * SECONDS_PER_MINUTE;
            ex3.distance = 30000;
            [_exercises addObject:ex3];

            Exercise *ex4 = [[Exercise alloc] init];
            ex4.type     = kExerciseTypeRunning;
            ex4.date     = [NSDate dateWithTimeIntervalSinceNow:-round(SECONDS_PER_MINUTE* MINUTES_PER_HOUR * HOURS_PER_DAY * 5.25)];
            ex4.interval = 50 * SECONDS_PER_MINUTE;
            ex4.distance = 7200;
            [_exercises addObject:ex4];

            Exercise *ex5 = [[Exercise alloc] init];
            ex5.type     = kExerciseTypeRunning;
            ex5.date     = [NSDate dateWithTimeIntervalSinceNow:-round(SECONDS_PER_MINUTE* MINUTES_PER_HOUR * HOURS_PER_DAY* 6.75)];
            ex5.interval = 50 * SECONDS_PER_MINUTE;
            ex5.distance = 4000;
            [_exercises addObject:ex5];
        }
    }

    return _exercises;
}


#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = [self.exercises count];

    if (numRows >= 3) {
        self.totalDistanceLabel.text      = [NSString stringWithFormat:@"%.2f miles",
                                                                       [[self.exercises valueForKeyPath:@"@sum.boxedDistance"] floatValue] / METERS_PER_MILE];
        self.totalDistanceLabel.textColor = [UIColor colorWithRed:0.254 green:0.434 blue:0.136 alpha:1.0];

        self.totalTimeLabel.text      = [NSString stringWithFormat:@"%.0f mins",
                                                                   [[self.exercises valueForKeyPath:@"@sum.boxedInterval"] floatValue] / SECONDS_PER_MINUTE];
        self.sparkView.data           = [self.exercises valueForKeyPath:@"boxedInterval"];
        self.sparkView.lineWidth      = 2;
        self.totalTimeLabel.textColor = self.sparkView.lineColor = [UIColor colorWithRed:0.209 green:0.548 blue:0.800 alpha:1.0];
    }

    return numRows;
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
        [self.tableView reloadData];

        [self save];
    }
}


#pragma mark - Actions

- (IBAction)addExercise:(UIStoryboardSegue *)segue {
    ExerciseMapViewController *vc = segue.sourceViewController;
    if (vc.exerciseToAdd) {
        [self.exercises insertObject:vc.exerciseToAdd atIndex:0];
        [self.tableView reloadData];

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
            alertMessage(@"Something wrong happened. Please try again.");

            return;
        }

        if (!service.currentRecord && service.records && [service.records count] > 0) {
            // Yay
            [[HealthVault mainVault] updateCurrentRecord:service.records[0]];
        } else if (!service.records) {
            // Duh
            alertMessage(@"Your HealthVault account doesn't have any records.");
        }

        if (service.records) {
            // Things went well
            LOG_EXPR([service.records[0] recordName]);

            // Prepare
            NSPredicate     *predicate         = [NSPredicate predicateWithFormat:@"healthVaultID = nil"];
            __block NSArray *unsyncedExercises = [self.exercises filteredArrayUsingPredicate:predicate];

            // Check
            if ([unsyncedExercises count] == 0) {
                alertMessage(@"Your exercises are in synced with Microsoft HealthVault already.");

                return;
            }

            // Submit
            self.navigationItem.leftBarButtonItem.enabled  = NO;
            self.navigationItem.rightBarButtonItem.enabled = NO;

            [[HealthVault mainVault] putExercises:self.exercises onCompletion:^(HealthVaultService *service, HealthVaultResponse *response) {
                self.navigationItem.leftBarButtonItem.enabled  = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;

                // Duh
                if (response.hasError) {
                    alertMessage(response.errorText);

                    return;
                }

                LOG_EXPR(response.responseXml);

                NSError      *error      = nil;
                NSDictionary *dictionary = [XMLReader dictionaryForXMLString:response.responseXml error:&error];
                if (error) {
                    alertMessage(@"Unable to retrieve data. Please try again.");

                    return;
                }

                id things = nil;
                if (dictionary[@"response"] && dictionary[@"response"][@"wc:info"]) {
                    things = [dictionary[@"response"][@"wc:info"] valueForKeyPath:@"thing-id"];

                    // Edge case
                    if ([things isKindOfClass:[NSDictionary class]]) {
                        things = @[things];
                    }

                    for (NSInteger idx = 0; idx < [things count]; idx++) {
                        Exercise *exercise = unsyncedExercises[idx];
                        exercise.healthVaultID           = things[idx][@"text"];
                        exercise.healthVaultVersionStamp = things[idx][@"version-stamp"];
                    }

                    [self save];
                }

                alertMessage(@"Your exercises have been uploaded to Microsoft HealthVault successfully.");
            }];
        }
    }                                                          shellAuthRequired:^(HealthVaultService *service, HealthVaultResponse *response) {
        // Duh
        if (response.hasError) {
            alertMessage(response.errorText);

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