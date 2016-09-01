//
//  AddinformationViewcontroller.h
//  Googleplace
//
//  Created by Roei Baruch on 06/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "tableView.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface AddinformationViewcontroller : UIViewController
@property(nonatomic, strong) NSString *Address;
@property(nonatomic, strong) NSString *googleId;
@property(strong, nonatomic) IBOutlet UITextField *Apartment;
@property(strong, nonatomic) IBOutlet UITextField *Feedback;
@property(weak, nonatomic) IBOutlet UITextView *Feedback2;
@property(nonatomic, assign) BOOL working;

@end
