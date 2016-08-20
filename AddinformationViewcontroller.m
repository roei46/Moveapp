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
  NSLog(@"this address: %@", _Address);

  NSLog(@"this id: %@", _googleId);

  //  NSLog(@"this : %f ,%f" , _dbllatitude,_dbllongitude);

  self.title = _Address;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender {
  //                            DatabaseManager *databaseManager =
  //                                [[DatabaseManager alloc] init];
  //
  //                            [databaseManager
  //                                addPlace:place
  //                                callback:^(BOOL found) {
  //                                  if (found) {
  //
  //                                    UIAlertController *alert =
  //                                    [UIAlertController
  //                                        alertControllerWithTitle:@"Alert"
  //                                                         message:nil
  //                                                  preferredStyle:
  //                                                      UIAlertControllerStyleAlert];
  //
  //                                    UIAlertAction *failed = [UIAlertAction
  //                                        actionWithTitle:@"Address uploaded!"
  //                                                  style:
  //                                                      UIAlertActionStyleDefault
  //                                                handler:nil];
  //                                    [alert addAction:failed];
  //
  //                                    [self presentViewController:alert
  //                                                       animated:YES
  //                                                     completion:nil];
  //                                    [self.navigationController loadView];
  //                                  }
  //                                  UIAlertController *alert =
  //                                  [UIAlertController
  //                                      alertControllerWithTitle:@"Alert"
  //                                                       message:nil
  //                                                preferredStyle:
  //                                                    UIAlertControllerStyleAlert];
  //
  //                                  [self presentViewController:alert
  //                                                     animated:YES
  //                                                   completion:nil];
  //
  //                                  UIAlertAction *failed = [UIAlertAction
  //                                      actionWithTitle:@"Upload failed"
  //                                                style:UIAlertActionStyleDefault
  //                                              handler:nil];
  //                                  [alert addAction:failed];
  //
  //                                  [self presentViewController:alert
  //                                                     animated:YES
  //                                                   completion:nil];
  //
  //                                }];

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
  NSLog(@"this id: %hhd", _working);
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t _myQueue =
      dispatch_queue_create("com.cocoafactory.DispatchGroupExample", 0);
  if (_working) {

    dispatch_group_async(group, _myQueue, ^{

      NSLog(@" first q ");

      DatabaseManager *databaseManager = [[DatabaseManager alloc] init];

      [databaseManager
          addPlace:_Address
           placeId:_googleId
          callback:^(BOOL found) {
            if (found) {

              UIAlertController *alert = [UIAlertController
                  alertControllerWithTitle:@"Alert"
                                   message:nil
                            preferredStyle:UIAlertControllerStyleAlert];

              UIAlertAction *failed = [UIAlertAction
                  actionWithTitle:@"Address uploaded!"
                            style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action) {
                            MapViewController *destViewController =
                                [self.storyboard
                                    instantiateViewControllerWithIdentifier:
                                        @"MapViewController"];

                            destViewController.Address = _Address;

                            [self.navigationController
                                pushViewController:destViewController
                                          animated:YES];
                          }];

              [alert addAction:failed];

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
              if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
                _DBid = [addname valueForKey:@"objectId"];
                NSLog(@"placeid :%@", _DBid);
                break;
              }
            }

            NSLog(@" second q ");

            PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
            [query
                getObjectInBackgroundWithId:_DBid
                                      block:^(PFObject *item, NSError *error) {

                                        [item addObject:_Apartment.text
                                                 forKey:@"apartments"];

                                        NSMutableDictionary *dict = [item
                                            objectForKey:@"apartmentsDict"];

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
                                                alertControllerWithTitle:
                                                    @"Alert"
                                                                 message:nil
                                                          preferredStyle:
                                                              UIAlertControllerStyleAlert];
                                            NSLog(@"error happened:%@", error);
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
                                                alertControllerWithTitle:
                                                    @"Alert"
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
              if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
                _DBid = [addname valueForKey:@"objectId"];
                NSLog(@"placeid :%@", _DBid);
                break;
              }
            }

            NSLog(@" second q ");

            PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
            [query
                getObjectInBackgroundWithId:_DBid
                                      block:^(PFObject *item, NSError *error) {

                                        [item addObject:_Apartment.text
                                                 forKey:@"apartments"];

                                        NSMutableDictionary *dict = [item
                                            objectForKey:@"apartmentsDict"];

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
                                                alertControllerWithTitle:
                                                    @"Alert"
                                                                 message:nil
                                                          preferredStyle:
                                                              UIAlertControllerStyleAlert];
                                            NSLog(@"error happened:%@", error);
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
                                                alertControllerWithTitle:
                                                    @"Alert"
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
}
@end
