//
//  ENGAOperation.m
//  ENGoogleMeasurementProtocol
//
//  Created by Steve High on 1/7/14.
//  Copyright (c) 2014 Evilnode Software. All rights reserved.
//

#import "ENGAOperation.h"
#import <stdlib.h>
@interface ENGAOperation()
@property (nonatomic) BOOL ready;
@property (nonatomic) BOOL finished;
@end
@implementation ENGAOperation

@synthesize ready = _ready;
@synthesize finished = _finished;

- (id) init
{
    self = [super init];
    if (self) {
        _ready = YES;
        _finished = NO;
    }
    return self;
}

+ (id) operation
{
    ENGAOperation *ret = [[ENGAOperation alloc] init];
#ifdef ENGA_DEFAULT_QUEUE_PRIORITY
    [ret setQueuePriority:(NSOperationQueuePriority)ENGA_DEFAULT_QUEUE_PRIORITY];
#else
    [ret setQueuePriority:NSOperationQueuePriorityVeryLow];
#endif
#ifdef ENGA_DEFAULT_THREAD_PRIORITY
    [ret setThreadPriority:ENGA_DEFAULT_THREAD_PRIORITY];
#else
    [ret setThreadPriority:0.1];
#endif

    return ret;
}

- (void) start
{
    self.ready = NO;
#ifdef ENGA_NO_SSL
    NSString *endpoint = ENGA_ENDPOINT_NO_SSL;
#else
    NSString *endpoint = ENGA_ENDPOINT_SSL;
#endif
    NSString *userAgent = self.requestParams[@(kReservedUserAgentKey)];
    NSDictionary *userHeaders = self.requestParams[@(kReservedUserDefinedHeaderKey)];
    for (NSString *key in userHeaders) {

    }
    NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:[self.rawParams count]];
    for (NSString *key in self.rawParams) {
        id value = self.rawParams[key];
        [keyValuePairs addObject:
         [NSString stringWithFormat:@"%@=%@",key, [[value description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }

    NSString *queryString = [keyValuePairs componentsJoinedByString:@"&"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    for (NSString *headerKey in self.requestHeaders) {
        [request addValue:self.requestHeaders[headerKey] forHTTPHeaderField:headerKey];
    }
#ifdef ENGA_NO_POST
    //  add cache buster to the end of query string for GET requests
    endpoint = [NSString stringWithFormat:@"%@?%@&z=%d", endpoint, queryString, (arc4random() % 9999999)];
#else
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
#endif
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    self.finished = YES;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return !(_ready || _finished);
}

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isReady
{
    return _ready;
}
@end
