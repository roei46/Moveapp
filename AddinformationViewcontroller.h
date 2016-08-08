//
//  AddinformationViewcontroller.h
//  Googleplace
//
//  Created by Roei Baruch on 06/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddinformationViewcontroller.h"
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "ViewController.h"
#import "ServerProtocol.h"
#import "DatabaseManager.h"
#import "MapViewController.h"

@interface AddinformationViewcontroller : UIViewController
@property(nonatomic, strong) NSString *Address;
@property (nonatomic, assign) double dbllatitude;
@property (nonatomic, assign) double dbllongitude;






@end
