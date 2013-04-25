//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "GuidelineViewController.h"
#import "SDSegmentedControl.h"

@interface GuidelineViewController ()

@property (nonatomic) IBOutlet SDSegmentedControl *segmentedControl;
@property (nonatomic) IBOutlet UITextView         *textView;

@property (nonatomic) NSArray *tabs;

@end

@implementation GuidelineViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Get
    NSString *keyPath = [[[self.title stringByReplacingOccurrencesOfString:@" " withString:@""]
                                      stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByAppendingString:@".Tabs"];
    self.tabs = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Guidelines" ofType:@"plist"]][@"Guidelines"]
            valueForKeyPath:keyPath];

    // Set
    [self.segmentedControl removeAllSegments];
    for (NSDictionary *tabTitle in [[self.tabs valueForKeyPath:@"Title"] reverseObjectEnumerator]) {
        [self.segmentedControl insertSegmentWithTitle:tabTitle atIndex:0 animated:NO];
    }

    // Go
    self.segmentedControl.selectedSegmentIndex = 0;
    [self changeTab];
}

- (IBAction)changeTab {
    self.textView.text = [self.tabs[self.segmentedControl.selectedSegmentIndex][@"Body"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

@end