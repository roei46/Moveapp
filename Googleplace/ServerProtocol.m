//
//  ServerProtocol.m
//  Googleplace
//
//  Created by Roei Baruch on 02/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "DatabaseManager.h"
#import "ServerProtocol.h"

#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"
@interface ServerProtocol ()

@property(nonatomic, strong) DatabaseManager *databaseManager;
@property(nonatomic, strong) NSURLSession *session;
@end
@implementation ServerProtocol

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

//- (void)http {
//    
//    
//    NSURLRequest *request = [self createRequest:TestTable];
//    
//    NSURLSessionDataTask *postdata = [self.session
//                                      dataTaskWithRequest:request
//                                      completionHandler:^(NSData *data, NSURLResponse *response,
//                                                          NSError *error) {
//                                          
//                                          NSDictionary *result = [self deserialize:data];
//                                          
//                                          
//                                          if (<#condition#>) {
//                                              <#statements#>
//                                          }
//                                      }];
//
//}





- (void)isPlaceExist:(GMSPlace *)place callback:(PlaceExist)callback {
    
  NSURLRequest *request = [self createRequest:TestTable];

  NSURLSessionDataTask *postdata = [self.session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {

          NSDictionary *result = [self deserialize:data];

          dispatch_async(dispatch_get_main_queue(), ^{
              NSMutableArray<NSString *> *googleids = [result valueForKeyPath:@"results.googlid"];
             
            NSInteger exists = [googleids indexOfObject:place.placeID];

           
              if (callback) {
                callback(exists!=NSNotFound);
              }

         });
        }];

  [postdata resume];
}

@end
