//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import <Foundation/Foundation.h>

@class HealthVaultService;

typedef void (^HVBlock)(HealthVaultService *service);

@interface HealthVault : NSObject

+ (id)mainVault;

- (void)performAuthenticationCheckOnAuthenticationCompleted:(HVBlock)complete shellAuthRequired:(HVBlock)required;
@end