//
//  MapViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 04/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "MapViewController.h"
#import "MapViewController.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface MapViewController () <GMSMapViewDelegate, UITableViewDelegate,
                                 UITableViewDataSource>
@property(nonatomic, strong) GMSMarker *selectedMarker;
@property(strong, nonatomic) IBOutlet UITableView *tblView;
@property(strong, nonatomic) NSMutableString *DBid;
@property(strong, nonatomic) NSArray *arrHeader;




@end

@implementation MapViewController {


  GMSMapView *_mapView;
  GMSMarker *_Marker;
  GMSPlacesClient *placesclient;
  UISegmentedControl *_switcher;
  NSArray *jsonResult2;
  NSDictionary *appResult;
    UIRefreshControl *refreshControl;
    NSMutableArray *expandedCells;

}

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;

  self.title = _Address;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(addInfo:)];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    

}




- (void)reloadData
{
    // Reload table data
    [self.tblView reloadData];
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}


-(void)getLatestLoans{
    
    
    [refreshControl endRefreshing];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  NSLog(@"numberofsec called arr : %lu", (unsigned long)_arrHeader.count);
//    if (_arrHeader !=0) {
//        
//        self.tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        return [_arrHeader count];
//
//        
//    }else{
//    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//    messageLabel.text = @"The are no feedbacks! please fuck your home owner now! do it!";
//    messageLabel.textColor = [UIColor blackColor];
//    messageLabel.numberOfLines = 0;
//    messageLabel.textAlignment = NSTextAlignmentCenter;
//    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//    [messageLabel sizeToFit];
//    
//    self.tblView.backgroundView = messageLabel;
//    self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        return 0;
//       
//    }
   // return [_arrHeader count];
    
    if ([_arrHeader count] == 0) {
        return 1; // a single cell to report no data
    }
    return [_arrHeader count];

}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
 
  return [_arrHeader objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSLog(@"numberOfRowsInSection called :%lu", (unsigned long)appResult.count);

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
      
  }
   
    

  cell.textLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([expandedCells containsObject:indexPath])
    {
        [expandedCells removeObject:indexPath];
    }
    else
    {
        [expandedCells addObject:indexPath];
    }
    [self.tblView beginUpdates];
    [self.tblView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([expandedCells containsObject:indexPath])
    {
        return 180; //It's not necessary a constant, though
    }
    else
    {
        return 44; //Again not necessary a constant
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    [self.view addSubview:_tblView];
    
    
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
                                          NSDictionary *result =
                                          [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&error];
                                          jsonResult2 = [result objectForKey:@"results"];
                                          NSLog(@"test : %@", jsonResult2);
                                          for (NSDictionary *addname in jsonResult2) {
                                              if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
                                                  appResult = addname[@"apartmentsDict"];
                                                  // for (NSDictionary *dictionary in appResult) {
                                                  
                                                  _arrHeader = [appResult allKeys];
                                                  NSLog(@"%@", _arrHeader);
                                                  
                                                  NSSortDescriptor *sortOrder =
                                                  [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                                ascending:YES];
                                                  _arrHeader = (NSMutableArray *)[_arrHeader
                                                                                  sortedArrayUsingDescriptors:[NSArray
                                                                                                               arrayWithObject:sortOrder]];
                                                  break;
                                                  
                                              }
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.tblView reloadData];
                                              });
                                              
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
