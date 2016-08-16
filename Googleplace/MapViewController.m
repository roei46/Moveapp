//
//  MapViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 04/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "ViewController.h"
#import "ServerProtocol.h"
#import "DatabaseManager.h"
#import "MapViewController.h"
#import "AddinformationViewcontroller.h"
//static CGFloat kSearchBarHeight = 44.0f;
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";



@interface MapViewController ()<GMSMapViewDelegate ,UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) GMSMarker * selectedMarker;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property(strong, nonatomic) NSMutableString *DBid;
@property(strong, nonatomic) NSArray *arrHeader;



@end

@implementation MapViewController{

    GMSMapView *_mapView;
    GMSMarker *_Marker;
    GMSPlacesClient *placesclient;
    UISegmentedControl *_switcher;
    NSArray *jsonResult2;
    NSDictionary *appResult;
    //NSArray *arrHeader;

}


- (void)viewDidLoad {
    
    
    self.title = _Address;

    self.tblView.delegate = self;
    self.tblView.dataSource = self;


    [self.view addSubview:_tblView];
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(showmap:)];

    
    
    
    
    
    
    
    
    
    
//    _mapView.settings.compassButton = YES;
//    _mapView.settings.myLocationButton = YES;
//    CLLocation *myLocation = _mapView.myLocation;
//    
//    GMSCameraPosition *camera =
//    [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
//                                longitude:myLocation.coordinate.longitude
//                                     zoom:10];
//    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    _Marker = [[GMSMarker alloc] init];
//    _Marker.position = CLLocationCoordinate2DMake(
//                                                  myLocation.coordinate.latitude, myLocation.coordinate.longitude);
//    _Marker.map = _mapView;
//    NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];
//    
//    _switcher = [[UISegmentedControl alloc] initWithItems:types];
//    
//    _switcher.selectedSegmentIndex = 0;
//    _mapView.delegate = self;
//   self.view = _mapView;
//    
//    _mapView.settings.compassButton = YES;
//    _mapView.settings.myLocationButton = YES;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _mapView.myLocationEnabled = YES;
//    });
//    
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
                                                      //for (NSDictionary *dictionary in appResult) {
                                                          
                                                          _arrHeader=[appResult allKeys];
                                                      NSLog(@"%@",_arrHeader);
                                                  
                                                  
                                                  NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
                                                  _arrHeader =  (NSMutableArray *)[_arrHeader sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
                                                  
                                                  
                                                  [_tblView reloadData];

                                                  
                                                      
                                                  }
                                                  
                                                  

                                                  
//                                                  _arrHeader = addname[@"apartments"];
//                                                 NSLog(@"arr :%@", _arrHeader);
//                                                  NSLog(@"arr :%lu", (unsigned long)_arrHeader.count);

                                            //  }
                                              
                                          
                                          
                                          }
                                          
                                      }];
    
    [postdata resume];
    
    [_switcher addTarget:self
                  action:@selector(didChangeSwitcher)
        forControlEvents:UIControlEventValueChanged];
    
    

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    NSLog(@"numberofsec called arr : %lu" ,(unsigned long)_arrHeader.count);
    return [_arrHeader count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"titleForHeaderInSection called :%@" ,[_arrHeader objectAtIndex:section]);


    
    return [_arrHeader objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    NSLog(@"numberOfRowsInSection called :%lu" , (unsigned long)appResult.count);

    return [appResult[_arrHeader[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    cell.textLabel.text = appResult[_arrHeader [indexPath.section]][indexPath.row];
    
    return cell;
    
    
    
}


- (void)showmap:(id)sender {
    
    _mapView.selectedMarker = nil;
    
    MapViewController  *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];
    
    
    
    destViewController.Address = _Address;
    
    
    
    [self.navigationController pushViewController:destViewController animated:YES];
    
    
    }

- (void)didChangeSwitcher {
    NSString *title =
    [_switcher titleForSegmentAtIndex:_switcher.selectedSegmentIndex];
    if ([kNormalType isEqualToString:title]) {
        _mapView.mapType = kGMSTypeNormal;
    } else if ([kSatelliteType isEqualToString:title]) {
        _mapView.mapType = kGMSTypeSatellite;
    } else if ([kHybridType isEqualToString:title]) {
        _mapView.mapType = kGMSTypeHybrid;
    } else if ([kTerrainType isEqualToString:title]) {
        _mapView.mapType = kGMSTypeTerrain;
    }
}


    




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
