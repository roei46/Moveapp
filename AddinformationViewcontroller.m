//
//  AddinformationViewcontroller.m
//  Googleplace
//
//  Created by Roei Baruch on 06/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"

@interface AddinformationViewcontroller ()
@property(strong, nonatomic) NSMutableString *DBid;

- (IBAction)upload:(id)sender;

@end

@implementation AddinformationViewcontroller

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  NSLog(@"this : %@", _Address);
  //  NSLog(@"this : %f ,%f" , _dbllatitude,_dbllongitude);

  self.title = _Address;
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

- (IBAction)upload:(id)sender {
  NSURLSession *session =
      [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                 defaultSessionConfiguration]
                                    delegate:nil
                               delegateQueue:nil];

  NSMutableURLRequest *request = [NSMutableURLRequest
       requestWithURL:
           [NSURL
               URLWithString:@"https://movex.herokuapp.com/parse/classes/Test2"]
          cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:60.0];

  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  [request addValue:@"movexroei" forHTTPHeaderField:@"X-Parse-Application-Id"];
  [request setHTTPMethod:@"GET"];

  NSLog(@"request : %@", request);

  NSURLSessionDataTask *postdata = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {

          NSDictionary *dic =
              [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];

          NSArray *resultarr = [dic valueForKey:@"results"];

          NSLog(@"test : %@", dic);
          for (NSDictionary *addname in resultarr) {
            if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
              _DBid = [addname valueForKey:@"objectId"];
              NSLog(@"placeid :%@", _DBid);
              break;
            }
          }

          PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
          [query
              getObjectInBackgroundWithId:_DBid
                                    block:^(PFObject *item, NSError *error) {
                                      [item addObject:_Apartment.text
                                               forKey:@"apartments"];

                                      NSMutableDictionary *dict =
                                          [item objectForKey:@"apartmentsDict"];

                                      if (![dict
                                              objectForKey:_Apartment.text]) {
                                        [dict setObject:[NSMutableArray array]
                                                 forKey:_Apartment.text];
                                      }
                                      [[dict objectForKey:_Apartment.text]
                                          addObject:_Feedback.text];

                                      [item setObject:dict
                                               forKey:@"apartmentsDict"];

                                      [item saveInBackgroundWithBlock:^(
                                                BOOL succeeded,
                                                NSError *_Nullable error) {
                                        if (error) {
                                          UIAlertController *alert = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                                               message:nil
                                                        preferredStyle:
                                                            UIAlertControllerStyleAlert];
                                          NSLog(@"error happened:%@", error);
                                          UIAlertAction *failed = [UIAlertAction
                                              actionWithTitle:@"Upload failed!"
                                                        style:
                                                            UIAlertActionStyleDefault
                                                      handler:nil];
                                          [alert addAction:failed];

                                          [self presentViewController:alert
                                                             animated:YES
                                                           completion:nil];
                                        } else {
                                          UIAlertController *alert = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                                               message:nil
                                                        preferredStyle:
                                                            UIAlertControllerStyleAlert];

                                          UIAlertAction *ok = [UIAlertAction
                                              actionWithTitle:
                                                  @"Upload succeeded!"
                                                        style:
                                                            UIAlertActionStyleDefault
                                                      handler:nil];
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
@end
