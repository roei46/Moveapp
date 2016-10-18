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
@property (weak, nonatomic) IBOutlet UITextView *text;
- (IBAction)mapButton:(id)sender;
- (IBAction)addButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mapbutton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _mapbutton.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    _addButton.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
                                                                    };
    self.title = @"Move-in-fo";
    self.edgesForExtendedLayout =
    UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.65 alpha:1.0]];
    _text.backgroundColor = [UIColor colorWithRed:0.25 green:0.73 blue:0.65 alpha:1.0];
    
    
    

    
    _text.editable = NO;
    
    
    
    
    
    
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
