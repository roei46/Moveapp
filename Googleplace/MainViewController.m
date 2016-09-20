//
//  MainViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 15/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "QuickAddViewController.h"


@interface MainViewController ()
- (IBAction)mapButton:(id)sender;
- (IBAction)addButton:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
    
 
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mapButton:(id)sender {

  ViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"ViewController"];

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

- (IBAction)addButton:(id)sender {
    
    QuickAddViewController *destViewController = [self.storyboard
                                          instantiateViewControllerWithIdentifier:@"QuickAddViewController"];
    
    [self.navigationController pushViewController:destViewController
                                         animated:YES];
}
@end
