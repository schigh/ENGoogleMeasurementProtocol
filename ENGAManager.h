//
//  ENGAManager.h
//  ENGoogleMeasurementProtocol
//
//  Created by Steve High on 1/9/14.
//  Copyright (c) 2014 Evilnode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef ENGoogleMeasurementProtocol_ENGoogleMeasurementProtocol_h
#import "ENGoogleMeasurementProtocol.h"
#endif
#ifndef ENGoogleMeasurementProtocol_ENGAManager_h
#define ENGoogleMeasurementProtocol_ENGAManager_h

@interface ENGAManager : NSObject
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSDictionary *userHeaders;
#ifdef ENGA_USER_PROVIDED_OPQUEUE
@property (nonatomic, strong) NSOperationQueue *opQueue;
#endif
+ (id) sharedManager;
- (NSString *) clientToken;
- (void) registerDefaults:(NSDictionary *)params;
- (void) performActionWithType:(ENGAHitType)t hitTypeString:(NSString *)typestr params:(NSDictionary *)params;
- (void) pageView:(NSDictionary *)params;
- (void) event:(NSDictionary *)params;
- (void) appView:(NSDictionary *)params;
- (void) transaction:(NSDictionary *)params;
- (void) item:(NSDictionary *)params;
- (void) social:(NSDictionary *)params;
- (void) exception:(NSDictionary *)params;
- (void) timing:(NSDictionary *)params;
@end
#endif