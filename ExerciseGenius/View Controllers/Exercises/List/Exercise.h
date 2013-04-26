//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Common.h"


@interface Exercise : NSObject

@property (nonatomic) NSString *healthVaultID;
@property (nonatomic) ExerciseType type;
@property (nonatomic) NSString *title;
@property (nonatomic) NSDate   *date;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) NSTimeInterval     interval;
@property (nonatomic) NSDictionary       *detail;
@property (nonatomic, readonly) NSString *healthVaultXMLValue;

@end