//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) NSURL *URL;
@property (nonatomic, readonly) BOOL isSuccess;

@end