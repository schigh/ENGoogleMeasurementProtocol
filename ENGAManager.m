//
//  ENGAManager.m
//  ENGoogleMeasurementProtocol
//
//  Created by Steve High on 1/9/14.
//  Copyright (c) 2014 Evilnode Software. All rights reserved.
//

#import "ENGAManager.h"
#import "ENGAOperation.h"
@interface ENGAManager()
@property (nonatomic, strong) NSMutableDictionary *defaults;
@property (nonatomic, strong) NSDictionary *gKeys;
- (NSDictionary *) resolvedParams:(NSDictionary *)instanceParams;
@end

@implementation ENGAManager
@synthesize defaults = _defaults;
@synthesize gKeys = _gKeys;
@synthesize userAgent = _userAgent;
@synthesize userHeaders = _userHeaders;

- (id) init
{
    self = [super init];
    if (self) {
        _userAgent = [NSString stringWithFormat:@"%@ v%@", ENGA_USERAGENT_STRING, ENGA_VERSION];
        _defaults = [NSMutableDictionary dictionaryWithCapacity:5];
        _gKeys = @{
           @(kVersionKey): @"v",
           @(kTrackingIDKey): @"tid",
           @(kClientIDKey): @"cid",
           @(kCampaignNameKey): @"cn",
           @(kCampaignSourceKey): @"cs",
           @(kCampaignMediumKey): @"cm",
           @(kCampaignKeywordKey): @"ck",
           @(kCampaignContentKey): @"cc",
           @(kCampaignIDKey): @"ci",
           @(kAdwordsIDKey): @"gclid",
           @(kDisplayAdsIDKey): @"dclid",
           @(kShouldAnonymizeIPKey): @"aip",
           @(kShouldUseSessionControlKey): @"sc",
           @(kScreenResolutionKey): @"sr",
           @(kViewportSizeKey): @"vp",
           @(kDocumentEncodingKey): @"de",
           @(kScreenColorsKey): @"sd",
           @(kUserLanguageKey): @"ul",
           @(kHitTypeKey): @"t",
           @(kAppNameKey): @"an",
           @(kAppVersionKey): @"av",
           @(kTransactionIDKey): @"ti",
           @(kTransactionAffiliationKey): @"ta",
           @(kTransactionRevenueKey): @"tr",
           @(kTransactionShippingKey): @"ts",
           @(kTransactionTaxKey): @"tt",
           @(kNonInteractiveHitKey): @"ni",
           @(kContentDescriptionKey): @"cd",
           @(kLinkIDKey): @"linkid",
           @(kEventCategoryKey): @"ec",
           @(kEventActionKey): @"ea",
           @(kEventLabelKey): @"el",
           @(kEventValueKey): @"ev",
           @(kItemNameKey): @"in",
           @(kItemPriceKey): @"ip",
           @(kItemQuantityKey): @"iq",
           @(kItemCodeKey): @"ic",
           @(kItemCategoryKey): @"iv",
           @(kCurrencyCodeKey): @"cu",
           @(kSocialNetworkKey): @"sn",
           @(kSocialActionKey): @"sa",
           @(kSocialActionTargetKey): @"st",
           @(kUserTimingCategoryKey): @"utc",
           @(kUserTimingVariableNameKey): @"utv",
           @(kUserTimingTimeKey): @"utt",
           @(kUserTimingLabelKey): @"utl",
           @(kPageLoadTimeKey): @"plt",
           @(kDNSTimeKey): @"dns",
           @(kPageDownloadTimeKey): @"pdt",
           @(kRedirectResponseTimeKey): @"rrt",
           @(kTCPConnectTimeKey): @"tcp",
           @(kServerResponseTimeKey): @"srt",
           @(kExceptionDescriptionKey): @"exd",
           @(kExceptionFatalKey): @"exf",
           @(kExperimentIDKey): @"xid",
           @(kExperimentVariantKey): @"xvar"
        };
        _userHeaders = @{};
    }
    return self;
}

+ (id) sharedManager
{
    __strong static ENGAManager *_instance = nil;
    static dispatch_once_t dot;
    dispatch_once(&dot, ^{
        _instance = [[ENGAManager alloc] init];
    });
    return _instance;
}

- (NSString *) clientToken
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *ret = [userdefaults valueForKey:ENGA_CID_NAME];
    if (ret == nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        ret = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [userdefaults setValue:ret forKey:ENGA_CID_NAME];
        [userdefaults synchronize];
    }
    return ret;
}

- (void) registerDefaults:(NSDictionary *)params
{
    for (NSNumber *key in params) {
        self.defaults[key] = params[key];
    }
}

- (NSDictionary *) resolvedParams:(NSDictionary *)instanceParams
{
    NSMutableDictionary *resolved = [NSMutableDictionary
                                     dictionaryWithCapacity:([self.defaults count] + [instanceParams count])];

    for (NSNumber *key in self.defaults) {
        NSString *resolvedKey = self.gKeys[key];
        if (nil == resolvedKey) {
            continue;
        }
        resolved[resolvedKey] = self.defaults[key];
    }
    for (NSNumber *key in instanceParams) {
        NSString *resolvedKey = self.gKeys[key];
        if (nil == resolvedKey) {
            continue;
        }
        resolved[resolvedKey] = instanceParams[key];
    }
    return [NSDictionary dictionaryWithDictionary:resolved];
}

- (void) performActionWithType:(ENGAHitType)t hitTypeString:(NSString *)typestr params:(NSDictionary *)params
{
    NSMutableDictionary *paramsWithHitType = [NSMutableDictionary dictionaryWithDictionary:params];
    paramsWithHitType[@(kHitTypeKey)] = typestr;
    NSDictionary *rawParams = [self resolvedParams:paramsWithHitType];
    ENGAOperation *op = [ENGAOperation operation];
    op.rawParams = rawParams;
    op.requestParams = @{
        @(kReservedUserAgentKey): self.userAgent
    };
    op.requestHeaders = self.userHeaders;
#ifdef ENGA_USER_PROVIDED_OPQUEUE
    [self.opQueue addOperation:op];
#else
    [[NSOperationQueue mainQueue] addOperation:op];
#endif

}

- (void) pageView:(NSDictionary *)params
{
    [self performActionWithType:kHitTypePageView hitTypeString:@"pageview" params:params];
}

- (void) event:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeEvent hitTypeString:@"event" params:params];
}

- (void) appView:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeAppView hitTypeString:@"appview" params:params];
}

- (void) transaction:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeTransaction hitTypeString:@"transaction" params:params];
}

- (void) item:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeItem hitTypeString:@"item" params:params];
}

- (void) social:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeSocial hitTypeString:@"social" params:params];
}

- (void) exception:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeException hitTypeString:@"exception" params:params];
}

- (void) timing:(NSDictionary *)params
{
    [self performActionWithType:kHitTypeTiming hitTypeString:@"timing" params:params];
}

@end
