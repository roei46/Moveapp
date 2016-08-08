//
//  ServerProtocolAddinfo.m
//  Googleplace
//
//  Created by Roei Baruch on 08/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "ServerProtocolAddinfo.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DatabaseManager.h"
#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"
@interface ServerProtocolAddinfo ()

@property(nonatomic, strong) DatabaseManager *databaseManager;
@property(nonatomic, strong) NSURLSession *session;
@end


@implementation ServerProtocolAddinfo
- (instancetype)init {
    self = [super init];
    if (self) {
        self.databaseManager = [[DatabaseManager alloc] init];
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

- (NSDictionary *)deserialize:(NSData *)data {
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    
    if (error) {
        NSLog(@"cant deserialize data:%@", error);
    }
    return result;
}

- (void)isPlaceExist:(GMSPlace *)place callback:(PlaceExist)callback {
    NSURLRequest *request = [self createRequest:TestTable];
    
    NSURLSessionDataTask *postdata = [self.session
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response,
                                                          NSError *error) {
                                          
                                          NSDictionary *result = [self deserialize:data];
                                          NSArray *arr = [result valueForKey:@"Address"];

                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              NSMutableArray<NSString *> *googleids = [result valueForKeyPath:@"results.googlid"];
//                                              
//                                              NSInteger exists = [googleids indexOfObject:place.placeID];
                                              for (NSString __strong *addname in arr){
                                              
                                              if (callback) {
                                                  callback(exists!=NSNotFound);
                                              }
                                              }
                                          });
                                      }];
    
    [postdata resume];
}
dispatch_async(dispatch_get_main_queue(), ^{
    //                                            NSString *googleids = [resultvalueForKeyPath:@"results.googlid"];
    //
    //                                              NSInteger exists = [googleids indexOfObject:place.placeID];
    NSArray *arr = [result valueForKey:@"Address"];
    
    for (NSString __strong *addname in arr){
        if ([addname isEqualToString:_Address] ) {
            break;
            exists =YES;
            if (callback) {
                callback(exists!=NSNotFound);
            }
        }
    }});


@end
