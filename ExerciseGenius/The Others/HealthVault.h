//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>

@class HealthVaultService;
@class HealthVaultResponse;

typedef void (^HVBlock)(HealthVaultService *service, HealthVaultResponse *response);

@interface HealthVault : NSObject

@property (nonatomic, readonly) NSURL *URL;

+ (id)mainVault;

- (void)startSpinner;
- (void)stopSpinner;
- (void)performAuthenticationCheckOnAuthenticationCompleted:(HVBlock)complete shellAuthRequired:(HVBlock)required;
@end