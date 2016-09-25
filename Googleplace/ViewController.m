//
//  ViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 25/07/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import "tableView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

@interface ViewController () <GMSAutocompleteResultsViewControllerDelegate,
                              GMSMapViewDelegate>
- (IBAction)mapChange:(id)sender;

@property(weak, nonatomic) IBOutlet GMSMapView *mapview;
@property(nonatomic, assign) BOOL showSegmant;
@property(weak, nonatomic) IBOutlet UILabel *infoLabel;
@property(strong, nonatomic)
    IBOutlet GMSAutocompleteResultsViewController *_acViewController;
@property(weak, nonatomic) IBOutlet GMSMarker *_Marker;
@property(strong, nonatomic) GMSPlacesClient *placesclient;
@property(weak, nonatomic) UITextView *_resultView;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) UISegmentedControl *switcher;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _showSegmant = YES;

  self.navigationController.navigationBar.barTintColor =
[UIColor colorWithRed:0.25 green:0.79 blue:0.78 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"Heiti TC" size:21]
  };
  self.title = @"Move-in-fo";
  self.edgesForExtendedLayout =
      UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;


  __acViewController = [[GMSAutocompleteResultsViewController alloc] init];
  __acViewController.delegate = self;

  _searchController = [[UISearchController alloc]
      initWithSearchResultsController:__acViewController];

  _searchController.hidesNavigationBarDuringPresentation = YES;
  _searchController.dimsBackgroundDuringPresentation = YES;

  _searchController.searchBar.autoresizingMask =
      UIViewAutoresizingFlexibleWidth;
  _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;

  _searchController.searchBar.placeholder = @"Search your address";

  [_searchController.searchBar sizeToFit];
  self.definesPresentationContext = YES;
  _searchController.searchResultsUpdater = __acViewController;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    _searchController.modalPresentationStyle = UIModalPresentationPopover;
  } else {
    _searchController.modalPresentationStyle = UIModalPresentationFullScreen;
  }
  self.definesPresentationContext = YES;
  [self.view addSubview:_searchController.searchBar];
  _mapview.delegate = self;
  _mapview.settings.compassButton = YES;
  _mapview.settings.myLocationButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _mapview.myLocationEnabled = YES;

  CLLocationManager *locationManager;
  locationManager = [[CLLocationManager alloc] init];
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  [locationManager startUpdatingLocation];

  GMSCameraPosition *camera = [GMSCameraPosition
      cameraWithLatitude:locationManager.location.coordinate.latitude
               longitude:locationManager.location.coordinate.longitude
                    zoom:10];
  self.mapview.camera = camera;
  self.mapview.padding = UIEdgeInsetsMake(0, 0, 15, 0);

  [self.mapview addSubview:_infoLabel];

  //  NSURLSession *session =
  //      [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
  //                                                 defaultSessionConfiguration]
  //                                    delegate:nil
  //                               delegateQueue:nil];
  //  NSMutableURLRequest *request = [NSMutableURLRequest
  //       requestWithURL:
  //           [NSURL
  //               URLWithString:@"https://movex.herokuapp.com/parse/classes/Test2"]
  //          cachePolicy:NSURLRequestUseProtocolCachePolicy
  //      timeoutInterval:60.0];
  //
  //  // use only in SET
  //  //  NSError *error;
  //  //    NSData *jsondata;
  //
  //  [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  //  [request addValue:@"movexroei"
  //  forHTTPHeaderField:@"X-Parse-Application-Id"];
  //
  //  // use only in SET
  //  //    [request setHTTPBody:jsondata];
  //  [request setHTTPMethod:@"GET"];
  //
  //  NSLog(@"%@", request);
  //
  //  NSURLSessionDataTask *postdata =
  //      [session dataTaskWithRequest:request
  //                 completionHandler:^(NSData *data, NSURLResponse *response,
  //                                     NSError *error) {
  //                   NSDictionary *result =
  //                       [NSJSONSerialization JSONObjectWithData:data
  //                                                       options:kNilOptions
  //                                                         error:&error];
    
    
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
                     GMSMarker *marker = [[GMSMarker alloc] init];
                     marker.position = CLLocationCoordinate2DMake(
                         place.coordinate.latitude, place.coordinate.longitude);
                     marker.title = place.name;
                     marker.snippet = @"Push to see feedbacks";
                     marker.map = _mapview;

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

- (bool)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
  _infoLabel.text = nil;
  return YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
  [mapView setSelectedMarker:marker];
  _infoLabel.text = marker.title;
  return YES;
}

- (void)mapView:(GMSMapView *)mapView
    didTapInfoWindowOfMarker:(GMSMarker *)marker {

  mapView.selectedMarker = nil;

  NSLog(@" Taped on marker : %@", marker.title);
    
  tableView *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
  NSLog(@" Taped on marker : %@", marker.userData);

  destViewController.Address = marker.title;

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

#pragma mark - GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
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
                    [UIAlertAction actionWithTitle:@"Place exist"
                                             style:UIAlertActionStyleDefault
                                           handler:nil];
                [alert addAction:exist];
                [self presentViewController:alert animated:YES completion:nil];

              } else {

                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:nil
                                     message:@"Do you wand to add this address?"
                              preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *yes = [UIAlertAction
                    actionWithTitle:@"yes"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {

                              AddinformationViewcontroller *destViewController =
                                  [self.storyboard
                                      instantiateViewControllerWithIdentifier:
                                          @"AddinformationViewcontroller"];

                              destViewController.Address = place.name;
                              destViewController.googleId = place.placeID;
                              destViewController.working = YES;

                              [self.navigationController
                                  pushViewController:destViewController
                                            animated:YES];

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

- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
    didFailAutocompleteWithError:(NSError *)error {
  // Display the error and dismiss the search controller.
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

- (void)didChangeSwitcher {
  NSString *title =
      [_switcher titleForSegmentAtIndex:_switcher.selectedSegmentIndex];
  if ([kNormalType isEqualToString:title]) {
    _mapview.mapType = kGMSTypeNormal;
  } else if ([kSatelliteType isEqualToString:title]) {
    _mapview.mapType = kGMSTypeSatellite;
  } else if ([kHybridType isEqualToString:title]) {
    _mapview.mapType = kGMSTypeHybrid;
  } else if ([kTerrainType isEqualToString:title]) {
    _mapview.mapType = kGMSTypeTerrain;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)mapChange:(id)sender {
  if (_showSegmant) {

    NSArray *types =
        @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];

    _switcher = [[UISegmentedControl alloc] initWithItems:types];
    _switcher.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                 UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleBottomMargin;
    _switcher.selectedSegmentIndex = 0;
    _switcher.translatesAutoresizingMaskIntoConstraints = YES;
    _switcher.frame = CGRectMake(50, 50, 210, 30);
    _switcher.tintColor = [UIColor whiteColor];
         [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.25 green:0.79 blue:0.78 alpha:1.0]} forState:UIControlStateNormal];

    [self.mapview addSubview:_switcher];

    [_switcher addTarget:self
                  action:@selector(didChangeSwitcher)
        forControlEvents:UIControlEventValueChanged];

    [self.navigationController setNavigationBarHidden:NO];
    _showSegmant = NO;
  } else {

    [self.switcher removeFromSuperview];
    _showSegmant = YES;
  }
}
@end
