//
//  ViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 25/07/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//
#import "DetailTableViewController.h"
#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

@interface ViewController () <GMSAutocompleteResultsViewControllerDelegate,
                              GMSMapViewDelegate ,UISearchControllerDelegate ,CLLocationManagerDelegate>
- (IBAction)mapChange:(id)sender;

@property(weak, nonatomic) IBOutlet GMSMapView *mapview;
@property(nonatomic, assign) BOOL showSegmant;
@property(weak, nonatomic) IBOutlet UILabel *infoLabel;
@property(strong, nonatomic)
    IBOutlet GMSAutocompleteResultsViewController *_acViewController;
@property(weak, nonatomic)  GMSMarker *_Marker;
@property(strong, nonatomic) GMSPlacesClient *placesclient;
@property(weak, nonatomic) UITextView *_resultView;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) UISegmentedControl *switcher;
@property(strong, nonatomic)  GMSMarker *targetMarker;
@property(nonatomic, strong) NSMutableArray *markersOnTheMap;
@property(nonatomic, strong) NSMutableDictionary *googleId;
@property(nonatomic, strong) CLLocationManager *locationManager;





@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.markersOnTheMap = [NSMutableArray new]; //Instantiate and allocate memory for the first time

  _showSegmant = YES;

  self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
  };
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor  whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16]
       }
     forState:UIControlStateNormal];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  self.title = @"Moveinfo";
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
    
    _searchController.delegate =self;

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
    
    
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    UIImageView *imageV = (UIImageView*)searchField.leftView;
    imageV.image = [imageV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageV.tintColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]
               forKeyPath:@"_placeholderLabel.textColor"];
 
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
        if ( status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
        [manager startUpdatingLocation];
      
            
            
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:self.locationManager.location.coordinate.latitude
                                 longitude:self.locationManager.location.coordinate.longitude
                                 zoom:10];
    self.mapview.camera = camera;
    
    [manager stopUpdatingLocation];
    
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    
   

    
    self.googleId = [[NSMutableDictionary alloc] init];

    
    
    
  _mapview.myLocationEnabled = YES;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  [self.locationManager startUpdatingLocation];

  GMSCameraPosition *camera = [GMSCameraPosition
      cameraWithLatitude:self.locationManager.location.coordinate.latitude
               longitude:self.locationManager.location.coordinate.longitude
                    zoom:10];
  self.mapview.camera = camera;
  self.mapview.padding = UIEdgeInsetsMake(0, 0, 15, 0);

  [self.mapview addSubview:_infoLabel];


    
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
                       [self.markersOnTheMap addObject:marker];
                       [self.googleId setObject:place.placeID forKey:place.name];
                       NSLog(@"place details for %@", self.googleId);

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

- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
 _infoLabel.text = nil;
}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
  [mapView setSelectedMarker:marker];
  _infoLabel.text = marker.title;
    _infoLabel.textColor =[UIColor whiteColor];
    _infoLabel.backgroundColor =[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

  return YES;
}

- (void)mapView:(GMSMapView *)mapView
    didTapInfoWindowOfMarker:(GMSMarker *)marker {

  mapView.selectedMarker = nil;

  NSLog(@" Taped on marker : %@", marker.title);
    
  DetailTableViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"DetailTableViewController"];

  destViewController.Address = marker.title;
    NSLog(@" Taped on marker : %@", marker.title);
    NSArray*keys=[_googleId allKeys];
    NSLog(@" aLL KEYS : %@", keys);


    
    
   destViewController.gId =[self.googleId objectForKey:marker.title];

  [self.navigationController pushViewController:destViewController
                                       animated:YES];
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
    if (gesture) {
        
        		self.targetMarker.icon = [GMSMarker markerImageWithColor:[UIColor clearColor]];

    }
    
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
                    [UIAlertAction actionWithTitle:@"Address is already exist"
                                             style:UIAlertActionStyleDefault
                                           handler:nil];
                  
                 
                  GMSCameraPosition *camera = [GMSCameraPosition
                                               cameraWithLatitude:place.coordinate.latitude
                                               longitude:place.coordinate.longitude
                                               zoom:15];
                  self.mapview.camera = camera;
                  
                  for (_targetMarker in self.markersOnTheMap) {
                      if (_targetMarker.position.latitude == place.coordinate.latitude && _targetMarker.position.longitude == place.coordinate.longitude) {
                          self.targetMarker.icon =  [GMSMarker markerImageWithColor:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]];

                          break;
                      }
                  }

                  
                  
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
      float X_Co = (self.view.frame.size.width - 250)/2;

      _switcher.frame = CGRectMake(X_Co, 50, 250, 30);


      _switcher.tintColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
      [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];

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
