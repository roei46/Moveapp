//
//  AddinformationViewcontroller.m
//  Googleplace
//
//  Created by Roei Baruch on 06/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//
#import "DetailTableViewController.h"
#import "AddinformationViewcontroller.h"
#import "StreetViewController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <GooglePlaces/GooglePlaces.h>
#import <IQKeyboardManager.h>

#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"

@interface AddinformationViewcontroller () <UITextViewDelegate , GMSPanoramaViewDelegate>
@property(strong, nonatomic) NSMutableString *DBid;
@property(weak, nonatomic) IBOutlet UIImageView *streetImage;
@property(weak, nonatomic) IBOutlet UILabel *TITLE;
@property (weak, nonatomic) IBOutlet UIButton *upload;
@property (weak, nonatomic)  UIView *streetView;
//@property(strong, nonatomic) GMSPanoramaView *panoView;
@property (retain, nonatomic) IBOutlet GMSPanoramaView *gmsView;


- (IBAction)upload:(id)sender;

@end

@implementation AddinformationViewcontroller

- (void)viewDidLoad {
  [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager] isEnabled];

    
    _upload.backgroundColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(cancel:)];

    [self.view setBackgroundColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.65 alpha:1.0]];
  self.title = @"Add Review";
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
                                                                    };

  _TITLE.text = _Address;
  self.automaticallyAdjustsScrollViewInsets = false;

  _Feedback2.placeholder = @"Please add your review here";
    [_Apartment.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    
    self.gmsView.delegate = self;
    [self.gmsView moveNearCoordinate:CLLocationCoordinate2DMake(self.coordinatats.latitude, self.coordinatats.longitude)];
    self.gmsView.streetNamesHidden = true;
    self.gmsView.navigationLinksHidden = true;



}
- (void) panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama {
    
    NSLog(@"panID: %@" , panorama.panoramaID);
    if (panorama.panoramaID == NULL) {
        NSLog(@"null: %@" , panorama.panoramaID);

    }

}

- (void) panoramaView:(GMSPanoramaView *)view error:(nonnull NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate {
    if (error) {
        
//        [self.gmsView removeFromSuperview];
            self.streetImage.image = [UIImage imageNamed:@"cover.jpeg"];

        
        NSLog(@"error: %@" , error);

    }
    
    
    
}

- (void)panoramaView:(GMSPanoramaView *)panoramaView didTap:(CGPoint)point{
    StreetViewController *destViewController = [self.storyboard
                                                     instantiateViewControllerWithIdentifier:@"StreetViewController"];
    
    destViewController.coordinatats = self.coordinatats;
    

    [self.navigationController pushViewController:destViewController
                                         animated:YES];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_Feedback2 resignFirstResponder];
  [_Apartment resignFirstResponder];
}


- (void)cancel:(id)sender {

  ViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"ViewController"];
    destViewController.didComeFromAddInformation = YES;

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender {
  if (self.Feedback2.text.length < 3 || self.Apartment.text.length == 0 ) {
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
             placeId:_googleIdTblview
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

                              destViewController.Address = _Address;
                                destViewController.gId = _googleIdTblview;
                                _TITLE.text =@"";
                                _Apartment.text =@"";
                                
                                _Feedback2.text =@"";


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
                                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
                                            NSString *trimmed = [regex stringByReplacingMatchesInString:_Feedback2.text options:0 range:NSMakeRange(0, [_Feedback2.text length]) withTemplate:@"\n"];
//                                            NSString *trimmed = [_Feedback2.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                                          
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
                                                  alertControllerWithTitle:nil
                                                    
                                                                   message:nil
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
                                                                        @"DetailTableViewController"
                                                                    ];

                                                            destViewController
                                                                .Address =
                                                                _Address;
                                                              destViewController.gId = _googleIdTblview;

                                                              _TITLE.text =@"";
                                                              _Apartment.text =@"";
                                                              
                                                              _Feedback2.text =@"";

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

              NSLog(@" second q2 ");
                

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
                                            
//                                            NSString *trimmed = [_Feedback2.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                                            
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
                                                  alertControllerWithTitle:nil
                                                                   message:nil
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

                                                            destViewController
                                                                .Address =
                                                                _Address;
                                                              destViewController.gId = _googleIdTblview;

                                                              
                                                              _Apartment.text =@"";
                                                              
                                                              _Feedback2.text =@"";
                                                              _TITLE.text =@"";
                                                              
                                                              


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
