//
//  QuickAddViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 20/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//
#import "DetailTableViewController.h"
#import "QuickAddViewController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <GooglePlaces/GooglePlaces.h>

#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"

@interface QuickAddViewController () <UISearchBarDelegate,
     GMSAutocompleteResultsViewControllerDelegate,
    GMSMapViewDelegate ,UITextFieldDelegate,UITextViewDelegate>

@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic)
    GMSAutocompleteResultsViewController *_acViewController;
@property(strong, nonatomic) NSMutableString *DBid;
@property(weak, nonatomic)  UILabel *TITLE;
@property (weak, nonatomic)  UIButton *submit;
@property(nonatomic, strong) NSMutableDictionary *googleIdDic;
@property(strong, nonatomic) GMSPlacesClient *placesclient;



- (IBAction)submit:(id)sender;

@end

@implementation QuickAddViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.googleIdDic = [[NSMutableDictionary alloc] init];

    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(cancel:)];

  self.navigationController.navigationBar.barTintColor =
      [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
  self.navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
  };
  self.title = @"Moveinfo";
  self.edgesForExtendedLayout =
      UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;

    [self.view setBackgroundColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.65 alpha:1.0]];

    _submit.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

  __acViewController = [[GMSAutocompleteResultsViewController alloc] init];
  __acViewController.delegate = self;

  _searchController = [[UISearchController alloc]
      initWithSearchResultsController:__acViewController];
    
    _searchController.searchBar.autoresizingMask =
    UIViewAutoresizingFlexibleWidth;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    _searchController.searchBar.placeholder = @"Search your address";
    

    [_searchController.searchBar sizeToFit];

  [_searchController.searchBar sizeToFit];
    _searchController.searchBar.barTintColor = [UIColor colorWithRed:0.31
                                                               green:0.65
                                                                blue:0.83
                                                               alpha:1.0];

    
   
    
     _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]];


  self.definesPresentationContext = YES;
  _searchController.searchResultsUpdater = __acViewController;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    _searchController.modalPresentationStyle = UIModalPresentationPopover;
  } else {
    _searchController.modalPresentationStyle = UIModalPresentationFullScreen;
  }
    
    
    
    _Feedback2.placeholder = @"Please add your review here";

    
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    
    UIImageView *imageV = (UIImageView*)searchField.leftView;
    imageV.image = [imageV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageV.tintColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    [searchField setValue:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]
               forKeyPath:@"_placeholderLabel.textColor"];
    searchField.backgroundColor = [UIColor redColor];
    
    
    [self.view addSubview:_searchController.searchBar];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
    [query selectKeys:@[@"googlid"]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@" objects : %@", objects);
            for (NSDictionary *dic in objects) {
                NSString *placeID = [dic valueForKey:@"googlid"];
                _placesclient = [[GMSPlacesClient alloc] init];
                
                [_placesclient
                 lookUpPlaceID:placeID
                 callback:^(GMSPlace *place, NSError *error) {
                     if (error != nil) {
                         NSLog(@"Place Details error %@",
                               [error localizedDescription]);
                         return;
                     }
                     if (place != nil) {
                         
                         [self.googleIdDic setObject:place.placeID forKey:place.name];
                         NSLog(@"place details for %@", self.googleIdDic);
                         
                     } else {
                         NSLog(@"No place details for %@", placeID);
                     }
                 }];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
        
    }];

}



- (UIImage *)tintedImageWithColor:(UIColor *)tintColor image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.Feedback2 resignFirstResponder];
  [self.Apartment resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.Apartment resignFirstResponder];
    [self.Feedback2 resignFirstResponder];

    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]) {
        [self.Feedback2 resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)setImage:(UIImage *)iconImage
forSearchBarIcon:(UISearchBarIcon)icon
           state:(UIControlState)state{
[_searchController.searchBar setImage:[UIImage imageNamed:@"SearchIcon"]
   forSearchBarIcon:UISearchBarIconSearch
              state:UIControlStateNormal];
}
- (void)cancel:(id)sender {
    
    _Apartment.text =@"";
    
    _Feedback2.text =@"";

  MainViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"MainViewController"];

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

#pragma mark - GMSAutocompleteResultsViewControllerDelegate



- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
    didFailAutocompleteWithError:(NSError *)error {
  // Display the error and dismiss the search controller.

  [_searchController setActive:NO];
}
- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
  _TITLE.text = place.name;
  ServerProtocol *serverProtocol = [[ServerProtocol alloc] init];
  [serverProtocol
      isPlaceExist:place
          callback:^(BOOL exist) {

            if ([place.name
                    rangeOfCharacterFromSet:[NSCharacterSet
                                                decimalDigitCharacterSet]]
                    .location != NSNotFound) {

              if (exist) {
                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:nil
                                     message:nil
                              preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *exist =
                    [UIAlertAction actionWithTitle:@"Address is already exist"
                                             style:UIAlertActionStyleDefault
                                           handler:nil];
                _Address = place.name;
                _googleId = place.placeID;
                  _working = NO;
                [alert addAction:exist];
                [self presentViewController:alert animated:YES completion:nil];

              } else {

                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:nil
                                     message:@"Do you want to add this address?"
                              preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *yes =
                    [UIAlertAction actionWithTitle:@"yes"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               
                                             _Address = place.name;
                                             _googleId = place.placeID;
                                             _working = YES;
                                    
                                           }];

                [alert addAction:yes];

                UIAlertAction *cancel =
                    [UIAlertAction actionWithTitle:@"No"
                                             style:UIAlertActionStyleDefault
                                           handler:nil];
                [alert addAction:cancel];

                [self presentViewController:alert animated:YES completion:nil];
              }

            } else {
              UIAlertController *alert = [UIAlertController
                  alertControllerWithTitle:nil
                                   message:nil
                            preferredStyle:UIAlertControllerStyleAlert];

              UIAlertAction *error1 =
                  [UIAlertAction actionWithTitle:@"Please enter a valid address"
                                           style:UIAlertActionStyleDefault
                                         handler:nil];
              [alert addAction:error1];
              [self presentViewController:alert animated:YES completion:nil];
            }
          }];

  [_searchController setActive:NO];
}

// Show and hide the network activity indicator when we start/stop loading
// results.

- (void)didRequestAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (IBAction)submit:(id)sender {
  if (self.Feedback2.text.length < 3 || self.Apartment.text.length == 0) {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Cant submit"
                         message:nil
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *failed =
        [UIAlertAction actionWithTitle:@"Please fill in the boxes"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:failed];

    [self presentViewController:alert animated:YES completion:nil];
  } else if (self.Feedback2.text.length > 70 || self.Apartment.text.length >4) {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Cant submit"
                         message:nil
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *failed =
        [UIAlertAction actionWithTitle:@"Write up to 70 and 4 digit"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:failed];

    [self presentViewController:alert animated:YES completion:nil];
  }

  else {

    NSURLSession *session =
        [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                   defaultSessionConfiguration]
                                      delegate:nil
                                 delegateQueue:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest
         requestWithURL:[NSURL URLWithString:@"https://movex.herokuapp.com/"
                                             @"parse/classes/Test2"]
            cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"movexroei"
        forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setHTTPMethod:@"GET"];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t _myQueue =
        dispatch_queue_create("com.cocoafactory.DispatchGroupExample", 0);
    if (_working) {

      dispatch_group_async(group, _myQueue, ^{

        DatabaseManager *databaseManager = [[DatabaseManager alloc] init];

        [databaseManager
            addPlace:_Address
             placeId:_googleId
            callback:^(BOOL found) {
              if (found) {

                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:nil
                                     message:nil
                              preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *uploaded = [UIAlertAction
                    actionWithTitle:@"Address uploaded!"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                              DetailTableViewController *destViewController = [self.storyboard
                                  instantiateViewControllerWithIdentifier:
                                      @"DetailTableViewController"];
                                
                                destViewController.gId = _googleId;
                                
                                _Apartment.text =@"";
                                
                                _Feedback2.text =@"";
                                _TITLE.text = @"";
                              destViewController.Address = _Address;

                              [self.navigationController
                                  pushViewController:destViewController
                                            animated:YES];
                            }];

                [alert addAction:uploaded];

                [self presentViewController:alert animated:YES completion:nil];
                [self.navigationController loadView];
              }
              UIAlertController *alert = [UIAlertController
                  alertControllerWithTitle:@"Alert"
                                   message:nil
                            preferredStyle:UIAlertControllerStyleAlert];

              [self presentViewController:alert animated:YES completion:nil];

              UIAlertAction *failed =
                  [UIAlertAction actionWithTitle:@"Upload failed"
                                           style:UIAlertActionStyleDefault
                                         handler:nil];
              [alert addAction:failed];

              [self presentViewController:alert animated:YES completion:nil];

            }];

      });
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

      NSURLSessionDataTask *postdata = [session
          dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {

              NSDictionary *dic =
                  [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];

              NSArray *resultarr = [dic valueForKey:@"results"];

              NSLog(@"test : %@", resultarr);

              for (NSDictionary *addname in resultarr) {
                if ([[addname valueForKey:@"Address"]
                        isEqualToString:_Address]) {
                  _DBid = [addname valueForKey:@"objectId"];
                  NSLog(@"placeid :%@", _DBid);
                  break;
                }
              }

              NSLog(@" first q ");

              PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
              [query
                  getObjectInBackgroundWithId:_DBid
                                        block:^(PFObject *item,
                                                NSError *error) {

                                          [item addObject:_Apartment.text
                                                   forKey:@"apartments"];

                                          NSMutableDictionary *dict = [item
                                              objectForKey:@"apartmentsDict"];

                                          if (![dict objectForKey:_Apartment
                                                                      .text]) {
                                            [dict
                                                setObject:[NSMutableArray array]
                                                   forKey:_Apartment.text];
                                          }
                                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
                                            NSString *trimmed = [regex stringByReplacingMatchesInString:_Feedback2.text options:0 range:NSMakeRange(0, [_Feedback2.text length]) withTemplate:@"\n"];
                                            
//                                              NSString *trimmed = [_Feedback2.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                                            
                                            
                                          [[dict objectForKey:_Apartment.text]
                                              addObject:trimmed];

                                          [item setObject:dict
                                                   forKey:@"apartmentsDict"];

                                          [item saveInBackgroundWithBlock:^(
                                                    BOOL succeeded,
                                                    NSError *_Nullable error) {
                                            if (error) {
                                              UIAlertController *alert = [UIAlertController
                                                  alertControllerWithTitle:
                                                      @"Alert"
                                                                   message:nil
                                                            preferredStyle:
                                                                UIAlertControllerStyleAlert];
                                              NSLog(@"error happened:%@",
                                                    error);
                                              UIAlertAction *failed = [UIAlertAction
                                                  actionWithTitle:
                                                      @"Upload failed!!!"
                                                            style:
                                                                UIAlertActionStyleDefault
                                                          handler:nil];
                                              [alert addAction:failed];

                                              [self presentViewController:alert
                                                                 animated:YES
                                                               completion:nil];
                                            } else {
                                              UIAlertController *alert = [UIAlertController
                                                  alertControllerWithTitle:nil                                                                   message:nil
                                                            preferredStyle:
                                                                UIAlertControllerStyleAlert];

                                              UIAlertAction *ok = [UIAlertAction
                                                  actionWithTitle:
                                                      @"Upload succeeded!"
                                                            style:
                                                                UIAlertActionStyleDefault
                                                          handler:^(
                                                              UIAlertAction
                                                                  *action) {
                                                            DetailTableViewController *destViewController =
                                                                [self.storyboard
                                                                    instantiateViewControllerWithIdentifier:
                                                                        @"DetailTableViewController"];
 destViewController.gId = [self.googleIdDic objectForKey:_TITLE.text];
                                                            destViewController
                                                                .Address =
                                                                _Address;
                                                              _Apartment.text =@"";
                                                              
                                                              _Feedback2.text =@"";
                                                              _TITLE.text = @"";
                                                             


                                                            [self.navigationController
                                                                pushViewController:
                                                                    destViewController
                                                                          animated:
                                                                              YES];
                                                          }];

                                              [alert addAction:ok];

                                              [self presentViewController:alert
                                                                 animated:YES
                                                               completion:nil];
                                            }
                                          }];
                                        }];

            }];

      [postdata resume];

    } else {
      NSURLSessionDataTask *postdata = [session
          dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {

              NSDictionary *dic =
                  [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];

              NSArray *resultarr = [dic valueForKey:@"results"];

              NSLog(@"test : %@", resultarr);

              for (NSDictionary *addname in resultarr) {
                if ([[addname valueForKey:@"Address"]
                        isEqualToString:_Address]) {
                  _DBid = [addname valueForKey:@"objectId"];
                  NSLog(@"placeid :%@", _DBid);
                  break;
                }
              }

              NSLog(@" second q ");

              PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
              [query
                  getObjectInBackgroundWithId:_DBid
                                        block:^(PFObject *item,
                                                NSError *error) {

                                          [item addObject:_Apartment.text
                                                   forKey:@"apartments"];

                                          NSMutableDictionary *dict = [item
                                              objectForKey:@"apartmentsDict"];

                                          if (![dict objectForKey:_Apartment
                                                                      .text]) {
                                            [dict
                                                setObject:[NSMutableArray array]
                                                   forKey:_Apartment.text];
                                          }
//                                              NSString *trimmed = [_Feedback2.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                                            
                                            
                                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
                                            NSString *trimmed = [regex stringByReplacingMatchesInString:_Feedback2.text options:0 range:NSMakeRange(0, [_Feedback2.text length]) withTemplate:@"\n"];
                                            
                                            
                                          [[dict objectForKey:_Apartment.text]
                                              addObject:trimmed];

                                          [item setObject:dict
                                                   forKey:@"apartmentsDict"];

                                          [item saveInBackgroundWithBlock:^(
                                                    BOOL succeeded,
                                                    NSError *_Nullable error) {
                                            if (error) {
                                              UIAlertController *alert = [UIAlertController
                                                  alertControllerWithTitle:
                                                      @"Alert"
                                                                   message:nil
                                                            preferredStyle:
                                                                UIAlertControllerStyleAlert];
                                              NSLog(@"error happened:%@",
                                                    error);
                                              UIAlertAction *failed = [UIAlertAction
                                                  actionWithTitle:
                                                      @"Upload failed!!!"
                                                            style:
                                                                UIAlertActionStyleDefault
                                                          handler:nil];
                                              [alert addAction:failed];

                                              [self presentViewController:alert
                                                                 animated:YES
                                                               completion:nil];
                                            } else {
                                              UIAlertController *alert = [UIAlertController
                                                  alertControllerWithTitle:nil                                                                   message:nil
                                                            preferredStyle:
                                                                UIAlertControllerStyleAlert];

                                              UIAlertAction *ok = [UIAlertAction
                                                  actionWithTitle:
                                                      @"Upload succeeded!"
                                                            style:
                                                                UIAlertActionStyleDefault
                                                          handler:^(
                                                              UIAlertAction
                                                                  *action) {
                                                            DetailTableViewController *destViewController =
                                                                [self.storyboard
                                                                    instantiateViewControllerWithIdentifier:
                                                                       @"DetailTableViewController"];
 destViewController.gId =[self.googleIdDic objectForKey:_TITLE.text];
                                                            destViewController
                                                                .Address =
                                                                _Address;
                                                              
                                                              _Apartment.text =@"";
                                                              
                                                              _Feedback2.text =@"";
                                                              _TITLE.text = @"";


                                                            [self.navigationController
                                                                pushViewController:
                                                                    destViewController
                                                                          animated:
                                                                              YES];
                                                          }];

                                              [alert addAction:ok];

                                              [self presentViewController:alert
                                                                 animated:YES
                                                               completion:nil];
                                            }
                                          }];
                                        }];

            }];

      [postdata resume];
    }
  }
}
@end
