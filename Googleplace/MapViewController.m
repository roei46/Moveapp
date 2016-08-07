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
static CGFloat kSearchBarHeight = 44.0f;
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";



@interface MapViewController ()<GMSMapViewDelegate>
@property (nonatomic, strong) GMSMarker * selectedMarker;

@end

@implementation MapViewController{

    GMSMapView *_mapView;
    GMSMarker *_Marker;
    GMSPlacesClient *placesclient;
    UISegmentedControl *_switcher;


}


- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    CLLocation *myLocation = _mapView.myLocation;
    
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                longitude:myLocation.coordinate.longitude
                                     zoom:10];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _Marker = [[GMSMarker alloc] init];
    _Marker.position = CLLocationCoordinate2DMake(
                                                  myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    _Marker.map = _mapView;
    NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];
    
    _switcher = [[UISegmentedControl alloc] initWithItems:types];
    
    _switcher.selectedSegmentIndex = 0;
    _mapView.delegate = self;
   self.view = _mapView;
    
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _mapView.myLocationEnabled = YES;
    });
    
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
                                          NSArray *jsonResult2 = [result objectForKey:@"results"];
                                          NSLog(@"test : %@", jsonResult2);
                                          for (NSDictionary *dic in jsonResult2) {
                                              NSString *placeID = [dic valueForKey:@"googlid"];
                                              placesclient = [[GMSPlacesClient alloc] init];
                                              
                                              [placesclient lookUpPlaceID:placeID
                                                                 callback:^(GMSPlace *place, NSError *error) {
                                                                     if (error != nil) {
                                                                         NSLog(@"Place Details error %@",
                                                                               [error localizedDescription]);
                                                                         return;
                                                                     }
                                                                     if (place != nil) {
                                                                         GMSMarker *marker = [[GMSMarker alloc] init];
                                                                         marker.position = CLLocationCoordinate2DMake(
                                                                                                                      place.coordinate.latitude,
                                                                                                                      place.coordinate.longitude);
                                                                         marker.title = place.name;
                                                                         marker.map = _mapView;
                                                                         
                                                                     } else {
                                                                         NSLog(@"No place details for %@", placeID);
                                                                     }
                                                                 }];
                                              
                                              NSLog(@" place id : %@", placeID);
                                          }
                                          
                                      }];
    
    [postdata resume];
    
    [_switcher addTarget:self
                  action:@selector(didChangeSwitcher)
        forControlEvents:UIControlEventValueChanged];
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


    
    
- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    mapView.selectedMarker = nil;

    NSLog(@" Taped on marker : %@", marker.title);
 AddinformationViewcontroller  *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];
    NSLog(@" Taped on marker : %@", marker.userData);

   destViewController.Address = marker.title;
    
    
    [self.navigationController pushViewController:destViewController animated:YES];

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
