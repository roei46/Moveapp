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
@property(strong, nonatomic) UIImageView *img2;


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
  _tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tblView.backgroundColor =
      [UIColor clearColor];

  self.title = _Address;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"STHeitiTC-Medium" size:16]
                                                                    };
    
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(addInfo:)];

  self.navigationItem.backBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(back:)];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [_arrHeader count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    NSString *title1 = @"Apartment : ";
   


    return [title1 stringByAppendingString:[_arrHeader objectAtIndex:section]];
}
- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    
    view.tintColor = [UIColor colorWithRed:0.31 green:0.65 blue:0.83 alpha:1.0];
    
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width, 44)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed :@"cover.jpeg"]];
//    imageView.frame = CGRectMake(0,0,0,0);
//   // [headerView addSubview: imageView];
//    return imageView;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];

    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.31 green:0.65 blue:0.83 alpha:1.0]];

    [view addSubview:headerView];
    
    _img2.image = [UIImage imageNamed:@"cover.jpeg"];

    _img2.frame = CGRectMake(0,0,self.view.bounds.size.width,100);
    [view addSubview:headerView];
    [headerView addSubview:_img2];
    NSString *title1 = @" Apartment : ";

    headerView.text =[title1 stringByAppendingString:[_arrHeader objectAtIndex:section]];
   
    
    
    
    return headerView;
    
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return [appResult[_arrHeader[section]] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
    [cell setSeparatorInset:UIEdgeInsetsZero];

    [cell setBackgroundColor:[UIColor colorWithRed:0.91 green:0.97 blue:1.00 alpha:1.0]];
  cell.textLabel.textColor = [UIColor blackColor];

  cell.textLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row];

  return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//  UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//  viewFeedback *destViewController =
//      [self.storyboard instantiateViewControllerWithIdentifier:@"viewFeedback"];
//
//  destViewController.Address = selectedCell.textLabel.text;
//  [self.navigationController pushViewController:destViewController
//                                       animated:YES];
    [self.tblView beginUpdates];
    [self.tblView endUpdates];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    
//    
//}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tblView.delegate = self;
  self.tblView.dataSource = self;

  [self.view addSubview:_tblView];

  // ServerProtocol *serverprotocol = [[ServerProtocol alloc]init];

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

- (void)back:(id)sender {

  _mapView.selectedMarker = nil;

  AddinformationViewcontroller *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];

  destViewController.Address = _Address;
  destViewController.working = NO;

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
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
