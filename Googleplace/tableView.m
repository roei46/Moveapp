//
//  MapViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 04/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import "tableView.h"
#include "viewFeedback.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface tableView () <GMSMapViewDelegate, UITableViewDelegate,
                         UITableViewDataSource>
@property(nonatomic, strong) GMSMarker *selectedMarker;
@property(strong, nonatomic) IBOutlet UITableView *tblView;
@property(strong, nonatomic) NSMutableString *DBid;
@property(strong, nonatomic) NSArray *arrHeader;

@end

@implementation tableView {

  GMSMapView *_mapView;
  GMSMarker *_Marker;
  GMSPlacesClient *placesclient;
  UISegmentedControl *_switcher;
  NSArray *jsonResult2;
  NSDictionary *appResult;
}

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tblView.backgroundColor =
      [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];

  self.title = _Address;
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(addInfo:)];
    
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  
  return [_arrHeader count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {

  return [_arrHeader objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return [appResult[_arrHeader[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    [cell setBackgroundColor:[UIColor colorWithRed:0.13
                                             green:0.32
                                              blue:0.43
                                             alpha:1.0]];
  }
    
    cell.textLabel.textColor = [UIColor whiteColor];

  cell.textLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row];

  return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
  viewFeedback *destViewController =
      [self.storyboard instantiateViewControllerWithIdentifier:@"viewFeedback"];

  destViewController.Address = selectedCell.textLabel.text;
  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tblView.delegate = self;
  self.tblView.dataSource = self;

  [self.view addSubview:_tblView];
    
    
    ServerProtocol *serverprotocol = [[ServerProtocol alloc]init];
    
    

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

  // use only in SET
  //  NSError *error;
  //    NSData *jsondata;

  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  [request addValue:@"movexroei" forHTTPHeaderField:@"X-Parse-Application-Id"];

  // use only in SET
  //    [request setHTTPBody:jsondata];
  [request setHTTPMethod:@"GET"];

  NSLog(@"%@", request);

  NSURLSessionDataTask *postdata = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {
            if (error == nil) {
            
          NSDictionary *result =
              [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
          jsonResult2 = [result objectForKey:@"results"];
          NSLog(@"test : %@", jsonResult2);
          for (NSDictionary *addname in jsonResult2) {
            if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
              appResult = addname[@"apartmentsDict"];

              _arrHeader = [appResult allKeys];
              NSLog(@"%@", _arrHeader);

              NSSortDescriptor *sortOrder =
                  [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                ascending:YES];
              _arrHeader = (NSMutableArray *)[_arrHeader
                  sortedArrayUsingDescriptors:[NSArray
                                                  arrayWithObject:sortOrder]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tblView reloadData];
                });

              break;
            }
           
          }
            }
        }];
   

  [postdata resume];
}

- (void)addInfo:(id)sender {

  _mapView.selectedMarker = nil;

  AddinformationViewcontroller *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];

  destViewController.Address = _Address;
  destViewController.working = NO;

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
