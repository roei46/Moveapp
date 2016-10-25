//
//  MainViewController.h
//  Googleplace
//
//  Created by Roei Baruch on 15/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

@interface MainViewController :UIViewController<MFMailComposeViewControllerDelegate>
- (IBAction)ShowEmail:(id)sender;

@end
