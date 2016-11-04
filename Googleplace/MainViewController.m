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
@property (weak, nonatomic) IBOutlet UIButton *ShowEmail;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.mapbutton.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    self.addButton.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    self.ShowEmail.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

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
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)ShowEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]){

    NSArray *toRecipents = [NSArray arrayWithObject:@"roei46@yahoo.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;

    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}
    else
    {
        NSLog(@"This device cannot send email");
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Mailoff =
        [UIAlertAction actionWithTitle:@"please activate your email"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alert addAction:Mailoff];
        [self presentViewController:alert animated:YES completion:nil];

    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
