//
//  DatabaseManager.m
//  Googleplace
//
//  Created by Roei Baruch on 02/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "DatabaseManager.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
@implementation DatabaseManager



-(void)addPlace:(GMSPlace *)place callback:(DatabaseChanged)callback{
    PFObject *testObject = [PFObject objectWithClassName:@"Test2"];
    testObject[@"Address"] = place.name;
    testObject[@"googlid"] = place.placeID;
   // testObject[@"Apartment"] =;
    
    [testObject
     
     saveInBackgroundWithBlock:^(BOOL succeeded,
                                 NSError *_Nullable error) {
     
         if(error){
             NSLog(@"error happened:%@",error);
         }
         
         if(callback){
             callback(succeeded);
         }
         
     }];
}
@end
