//
//  ServerProtocolAddinfo.h
//  Googleplace
//
//  Created by Roei Baruch on 08/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ServerProtocolAddinfo : NSObject
typedef void (^PlaceExist)(BOOL exist);

- (void)isPlaceExist:(GMSPlace *)place callback:(PlaceExist)callback;

@end
