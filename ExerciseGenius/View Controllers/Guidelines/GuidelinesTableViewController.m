//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "GuidelinesTableViewController.h"
#import "GuidelineViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation GuidelinesTableViewController {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Video
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSURL                       *URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"mp4"]];
        MPMoviePlayerViewController *vc  = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [self.navigationController presentMoviePlayerViewControllerAnimated:vc];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    GuidelineViewController *vc = segue.destinationViewController;
    vc.title = sender.textLabel.text;
}

@end