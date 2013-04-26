//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "HealthVault.h"
#import "HealthVaultService.h"
#import "Exercise.h"

#define HEALTH_VAULT_PLATFORM_URL @"https://platform.healthvault-ppe.com/platform/wildcat.ashx"
#define HEALTH_VAULT_SHELL_URL @"https://account.healthvault-ppe.com"

#define HEALTH_VAULT_MASTER_APPLICATION_ID @"92de2338-7cef-4972-907a-2ee2860956d4"

#define kHealthVaultSettingName @"Default"

@interface HealthVault ()

@property (nonatomic) HealthVaultService *service;

@property (nonatomic, copy) HVBlock authenticationCompletedBlock;
@property (nonatomic, copy) HVBlock shellAuthRequiredBlock;

@property (nonatomic, copy) HVBlock putThingsCallbackBlock;

@property (nonatomic, copy) HVBlock getThingsCallbackBlock;

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

- (void)updateCurrentRecord:(HealthVaultRecord *)record {
    self.service.currentRecord = record;
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

- (void)getExercisesOnCompletion:(void (^)(HealthVaultService *, HealthVaultResponse *))completion {
    self.getThingsCallbackBlock = completion;

    NSString *XMLString =
                     @"<info>"
                             "<group>"
                             "<filter>"
                             "<type-id>85a21ddb-db20-4c65-8d30-33c899ccf612</type-id>"
                             "<thing-state>Active</thing-state>"
                             "</filter>"
                             "<format>"
                             "<section>core</section>"
                             "<xml/>"
                             "<type-version-format>85a21ddb-db20-4c65-8d30-33c899ccf612</type-version-format>"
                             "</format>"
                             "</group>"
                             "</info>";

    HealthVaultRequest *request = [[HealthVaultRequest alloc] initWithMethodName:@"GetThings"
                                                                   methodVersion:3
                                                                     infoSection:XMLString
                                                                          target:self
                                                                        callBack:@selector(getThingsCallback:)];

    [self startSpinner];

    [self.service sendRequest:request];
}

- (void)putExercises:(NSArray *)exercises onCompletion:(void (^)(HealthVaultService *, HealthVaultResponse *))completion {
    self.putThingsCallbackBlock = completion;

    NSMutableString *XMLString = [[NSMutableString alloc] initWithString:@"<info>\n"];
    for (Exercise   *exercise in exercises) {
        if (!exercise.healthVaultID) {
            [XMLString appendString:exercise.healthVaultXMLValue];
        }
    }
    [XMLString appendString:@"</info>"];

    LOG_EXPR(XMLString);

    HealthVaultRequest *request = [[HealthVaultRequest alloc] initWithMethodName:@"PutThings"
                                                                   methodVersion:2
                                                                     infoSection:XMLString
                                                                          target:self
                                                                        callBack:@selector(putThingsCallback:)];

    [self startSpinner];

    [self.service sendRequest:request];
}

- (void)putThingsCallback:(HealthVaultResponse *)response {
    if (self.putThingsCallbackBlock) self.putThingsCallbackBlock(self.service, response);

    [self stopSpinner];
}

- (void)getThingsCallback:(HealthVaultResponse *)response {
    if (self.getThingsCallbackBlock) self.getThingsCallbackBlock(self.service, response);

    [self stopSpinner];
}

@end