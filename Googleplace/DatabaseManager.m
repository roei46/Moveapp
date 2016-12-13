//
//  DatabaseManager.m
//  Googleplace
//
//  Created by Roei Baruch on 02/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
//#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <Parse/Parse.h>
@implementation DatabaseManager

//- (void)addPlace:(GMSPlace *)place callback:(DatabaseChanged)callback {

- (void)addPlace:(NSString *)placeName
         placeId:(NSString *)placeId
        callback:(DatabaseChanged)callback {

  PFObject *testObject = [PFObject objectWithClassName:@"Test2"];
  testObject[@"Address"] = placeName;
  testObject[@"googlid"] = placeId;
  testObject[@"apartments"] = [NSMutableArray array];
  testObject[@"apartmentsDict"] = [NSMutableDictionary dictionary];

  [testObject

      saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {

        if (error) {
          NSLog(@"error happened:%@", error);
        }

        if (callback) {
          callback(succeeded);
        }

      }];
}
@end
