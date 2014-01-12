//
//  ENGAOperation.h
//  ENGoogleMeasurementProtocol
//
//  Created by Steve High on 1/7/14.
//  Copyright (c) 2014 Evilnode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef ENGoogleMeasurementProtocol_ENGoogleMeasurementProtocol_h
#import "ENGoogleMeasurementProtocol.h"
#endif
#ifndef ENGoogleMeasurementProtocol_ENGAOperation_h
#define ENGoogleMeasurementProtocol_ENGAOperation_h

@interface ENGAOperation : NSOperation
@property (nonatomic, strong) NSDictionary *rawParams;
@property (nonatomic, strong) NSDictionary *requestParams;
@property (nonatomic, strong) NSDictionary *requestHeaders;
+ (id) operation;
@end
#endif
