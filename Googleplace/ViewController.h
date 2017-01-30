//
//  ViewController.h
//  Googleplace
//
//  Created by Roei Baruch on 25/07/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (assign, nonatomic)BOOL didComeFromAddInformation;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinatats;


@end

