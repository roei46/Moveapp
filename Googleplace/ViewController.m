//
//  ViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 25/07/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "DatabaseManager.h"
#import "MapViewController.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "AddinformationViewcontroller.h"
// static CGFloat kSearchBarHeight = 44.0f;
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

@interface ViewController () <GMSAutocompleteResultsViewControllerDelegate,
                              GMSMapViewDelegate>

@property(weak, nonatomic) IBOutlet GMSMapView *mapview;
@property(weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController {
  UISegmentedControl *_switcher;
  GMSAutocompleteTableDataSource *_tableDataSource;
  GMSAutocompleteResultsViewController *_acViewController;

  UITextView *_resultView;
  UISearchController *searchController;

  GMSMarker *_Marker;
  GMSPlacesClient *placesclient;
}

- (void)viewDidLoad {
  [super viewDidLoad];

//  self.navigationItem.rightBarButtonItem =
//      [[UIBarButtonItem alloc] initWithTitle:@"Show map"
//                                       style:UIBarButtonItemStylePlain
//                                      target:self
//                                      action:@selector(showmap:)];
  self.navigationController.navigationBar.barTintColor =
      [UIColor colorWithRed:0 green:0.24 blue:0.45 alpha:1];
  self.navigationController.navigationBar.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  self.title = @"Move-in-fo";
  self.edgesForExtendedLayout =
      UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;

  self.view.backgroundColor = [UIColor whiteColor];

  _acViewController = [[GMSAutocompleteResultsViewController alloc] init];
  _acViewController.delegate = self;

  searchController = [[UISearchController alloc]
      initWithSearchResultsController:_acViewController];

  searchController.hidesNavigationBarDuringPresentation = YES;
  searchController.dimsBackgroundDuringPresentation = YES;

  searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
  [searchController.searchBar sizeToFit];
  self.definesPresentationContext = YES;
  searchController.searchResultsUpdater = _acViewController;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    searchController.modalPresentationStyle = UIModalPresentationPopover;
  } else {
    searchController.modalPresentationStyle = UIModalPresentationFullScreen;
  }
  self.definesPresentationContext = YES;
  [self.view addSubview:searchController.searchBar];
  _mapview.delegate = self;
  _mapview.settings.compassButton = YES;
  _mapview.settings.myLocationButton = YES;

  //      NSArray *types = @[ kNormalType, kSatelliteType, kHybridType,
  //      kTerrainType
  //      ];
  //
  //      _switcher = [[UISegmentedControl alloc] initWithItems:types];
  //      _switcher.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
  //                                   UIViewAutoresizingFlexibleWidth |
  //                                   UIViewAutoresizingFlexibleBottomMargin;
  //      _switcher.selectedSegmentIndex = 0;
  //      _switcher.translatesAutoresizingMaskIntoConstraints = YES;
  //      self.navigationItem.titleView = _switcher;
  //
  // self.view = _mapview;

  //      [_switcher addTarget:self
  //                    action:@selector(didChangeSwitcher)
  //          forControlEvents:UIControlEventValueChanged];
  //
  //      [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:32.0808800
                                                          longitude:34.7805700
                                                               zoom:10];
  self.mapview.camera = camera;
  //
  //  _Marker = [[GMSMarker alloc] init];
  //  _Marker.position = CLLocationCoordinate2DMake(32.0808800, 34.7805700);
  //  _Marker.map = self.mapview;
  //  _mapview.delegate = self;

  [self.mapview addSubview:_infoLabel];

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
                                   marker.map = _mapview;

                                 } else {
                                   NSLog(@"No place details for %@", placeID);
                                 }
                               }];
            NSLog(@" place id : %@", placeID);
          }

        }];

  [postdata resume];
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
  MapViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"MapViewController"];
  NSLog(@" Taped on marker : %@", marker.userData);

  destViewController.Address = marker.title;

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

#pragma mark - GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
  // Display the results and dismiss the search controller.
  ServerProtocol *serverProtocol = [[ServerProtocol alloc] init];
  [serverProtocol
      isPlaceExist:place
          callback:^(BOOL exist) {

            if (exist) {
              UIAlertController *alert = [UIAlertController
                  alertControllerWithTitle:@"Alert"
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
                  alertControllerWithTitle:@"Alert"
                                   message:@"Do you wand to add this address?"
                            preferredStyle:UIAlertControllerStyleAlert];

              UIAlertAction *yes = [UIAlertAction
                  actionWithTitle:@"yes"
                            style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action) {
                              
                              
                              AddinformationViewcontroller *destViewController = [self.storyboard
                                                                       instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];
                              
                              destViewController.Address = place.name;
                              destViewController.googleId = place.placeID;
                              destViewController.working = YES;
                              
                              [self.navigationController pushViewController:destViewController
                                                                   animated:YES];

                              
                              
                              

//                            DatabaseManager *databaseManager =
//                                [[DatabaseManager alloc] init];
//
//                            [databaseManager
//                                addPlace:place
//                                callback:^(BOOL found) {
//                                  if (found) {
//
//                                    UIAlertController *alert = [UIAlertController
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
//                                  UIAlertController *alert = [UIAlertController
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

                          }];
              [alert addAction:yes];

              UIAlertAction *cancel =
                  [UIAlertAction actionWithTitle:@"cancel"
                                           style:UIAlertActionStyleDefault
                                         handler:nil];
              [alert addAction:cancel];

              [self presentViewController:alert animated:YES completion:nil];
            }

          }];

  [searchController setActive:NO];
}

- (void)resultsController:
            (GMSAutocompleteResultsViewController *)resultsController
    didFailAutocompleteWithError:(NSError *)error {
  // Display the error and dismiss the search controller.
  [searchController setActive:NO];
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

//- (IBAction)onLaunchClicked:(id)sender {
//  GMSAutocompleteViewController *acController =
//      [[GMSAutocompleteViewController alloc] init];
//  acController.delegate = self;
//  [self presentViewController:acController animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
