//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Common.h"

void alertError(id error) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error isKindOfClass:[NSError class]] ? [error localizedDescription] : error
                               delegate:nil cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}