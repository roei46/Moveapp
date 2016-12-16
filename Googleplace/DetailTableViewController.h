//
//  DetailTableViewController.h
//  Googleplace
//
//  Created by Roei Baruch on 15/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface DetailTableViewController : UITableViewController

@property(nonatomic, strong) NSString *Address;
@property(nonatomic, strong) NSString *gId;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinatats;






@end
