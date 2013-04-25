//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "HealthVault.h"
#import "HealthVaultService.h"
#import "HealthVaultResponse.h"
#import "Common.h"

#define HEALTH_VAULT_PLATFORM_URL @"https://platform.healthvault-ppe.com/platform/wildcat.ashx"
#define HEALTH_VAULT_SHELL_URL @"https://account.healthvault-ppe.com"

#define HEALTH_VAULT_MASTER_APPLICATION_ID @"92de2338-7cef-4972-907a-2ee2860956d4"

#define kHealthVaultSettingName @"Default"

@interface HealthVault ()

@property (nonatomic) HealthVaultService *service;

@property (nonatomic, copy) HVBlock authenticationCompletedBlock;
@property (nonatomic, copy) HVBlock shellAuthRequiredBlock;

@end

@implementation HealthVault

+ (id)mainVault {
    static dispatch_once_t once;
    static id              sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (HealthVaultService *)service {
    if (!_service) {
        _service = [[HealthVaultService alloc]
                                        initWithUrl:HEALTH_VAULT_PLATFORM_URL shellUrl:HEALTH_VAULT_SHELL_URL masterAppId:HEALTH_VAULT_MASTER_APPLICATION_ID];

        [_service loadSettings:kHealthVaultSettingName];
    }

    return _service;
}

- (void)startSpinner {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopSpinner {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)performAuthenticationCheckOnAuthenticationCompleted:(HVBlock)complete shellAuthRequired:(HVBlock)required {
    self.authenticationCompletedBlock = complete;
    self.shellAuthRequiredBlock       = required;

    [self startSpinner];

    [self.service performAuthenticationCheck:self
                     authenticationCompleted:@selector(authenticationCompleted:)
                           shellAuthRequired:@selector(shellAuthRequired:)];
}

- (void)authenticationCompleted:(HealthVaultResponse *)response {
    [self.service saveSettings:kHealthVaultSettingName];

    [self stopSpinner];

    if (self.authenticationCompletedBlock) self.authenticationCompletedBlock(self.service, response);
}

- (void)shellAuthRequired:(HealthVaultResponse *)response {
    [self.service saveSettings:kHealthVaultSettingName];

    [self stopSpinner];

    if (self.shellAuthRequiredBlock) self.shellAuthRequiredBlock(self.service, response);
}

- (NSURL *)URL {
    return [NSURL URLWithString:[self.service getApplicationCreationUrl]];
}

@end