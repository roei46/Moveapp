//
//  DatabaseManager.h
//  Googleplace
//
//  Created by Roei Baruch on 02/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMSPlace;


@interface DatabaseManager : NSObject

typedef void (^DatabaseChanged)(BOOL found);

//-(void)addPlace:(GMSPlace *)place  callback:(DatabaseChanged)callback;
- (void)addPlace:(NSString *)placeName
         placeId:(NSString *)placeId
        callback:(DatabaseChanged)callback;
@end
