//
//  SessionRequest.m
//  Googleplace
//
//  Created by Roei Baruch on 22/11/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "SessionRequest.h"

#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"

@interface SessionRequest ()
@property(nonatomic, strong) NSMutableURLRequest *request;
@property(nonatomic, strong) NSURLSession *session;


@end
@implementation SessionRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session =
        [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                defaultSessionConfiguration]
                                      delegate:nil
                                 delegateQueue:nil];
    }
    return self;
}

- (NSURLRequest *)createRequest:(NSString *)requestPath {
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestPath]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:60.0];
    
    // use only in SET
    // NSError *error;
    // use only in SET
    //    NSData *jsondata;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"movexroei" forHTTPHeaderField:@"X-Parse-Application-Id"];
    
    // use only in SET
    //    [request setHTTPBody:jsondata];
    [request setHTTPMethod:@"GET"];
    
    NSLog(@"%@", request);
    return request;
}

-(void)DataTask:(NoError)callback
{
    
    NSURLRequest *request = [self createRequest:TestTable];

        NSURLSessionDataTask *postdata = [self.session
                            dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response,
                                                          NSError *error) {
                                          self.DateFromSession = data;
                                          self.ErrorFromSession = error;
                                          
                                          if (callback) {
                                              callback(error == nil);
                                          }
                                          
                                      }];
    [postdata resume];
    
}

@end
