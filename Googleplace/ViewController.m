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
#import "MainViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <Parse/Parse.h>
#import <MBProgressHUD.h>
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

@interface ViewController () <GMSAutocompleteResultsViewControllerDelegate,
                              GMSMapViewDelegate ,UISearchControllerDelegate ,CLLocationManagerDelegate , UINavigationControllerDelegate>
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
    
//    UIBarButtonItem *backButton =[[UIBarButtonItem alloc] initWithTitle:@"Manu" style:UIBarButtonItemStylePlain target:self action:@selector(backToManue:)];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Manu"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backToManue:)];

//    if (self.didComeFromAddInformation) {
//        self.navigationItem.leftBarButtonItem = backButton;
//    }
//    else{
        self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back please" style:UIBarButtonItemStylePlain target:self action:nil];

//    }
    
    self.markersOnTheMap = [NSMutableArray new]; //Instantiate and allocate memory for the first time

    self.showSegmant = YES;

    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
  };
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor  whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16]
       }
     forState:UIControlStateNormal];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

  self.navigationItem.title = @"Map";
  self.edgesForExtendedLayout =
      UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;


  self._acViewController = [[GMSAutocompleteResultsViewController alloc] init];
  self._acViewController.delegate = self;

  self.searchController = [[UISearchController alloc]
      initWithSearchResultsController:__acViewController];
  self.searchController.hidesNavigationBarDuringPresentation = YES;
  self.searchController.dimsBackgroundDuringPresentation = YES;
  self.searchController.searchBar.autoresizingMask =
      UIViewAutoresizingFlexibleWidth;
  self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
  self.searchController.searchBar.placeholder = @"Search your address";
    self.searchController.delegate =self;

  [self.searchController.searchBar sizeToFit];
  self.definesPresentationContext = YES;
  self.searchController.searchResultsUpdater = self._acViewController;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.searchController.modalPresentationStyle = UIModalPresentationPopover;
  } else {
    self.searchController.modalPresentationStyle = UIModalPresentationFullScreen;
  }
  self.definesPresentationContext = YES;
  [self.view addSubview:_searchController.searchBar];
  self.mapview.delegate = self;
  self.mapview.settings.compassButton = YES;
  self.mapview.settings.myLocationButton = YES;
    
    
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    UIImageView *imageV = (UIImageView*)searchField.leftView;
    imageV.image = [imageV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageV.tintColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]
               forKeyPath:@"_placeholderLabel.textColor"];
 
}

- (void)backToManue:(id)sender {
    MainViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    [self.navigationController pushViewController:destViewController
                                         animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
        if ( status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    CLLocation *newLocation =[[CLLocation alloc]initWithLatitude:self.coordinatats.latitude longitude:self.coordinatats.latitude];
    double latitude1 = self.coordinatats.latitude;
    double longitude1 =self.coordinatats.longitude;
    NSLog(@"didUpdateLocations!!! %@", newLocation);
    NSLog(@"firsloc!!! %@", locations.firstObject);
    NSLog(@"last!!! %@", locations.lastObject);

    
    if (latitude1 == 0 && longitude1 == 0) {
        
        GMSCameraPosition *camera = [GMSCameraPosition
                                     cameraWithLatitude:self.locationManager.location.coordinate.latitude
                                     longitude:self.locationManager.location.coordinate.longitude
                                     zoom:10];
        self.mapview.camera = camera;
        

    }else{
        NSLog(@"else!!! %f", self.coordinatats.latitude);

        GMSCameraPosition *camera = [GMSCameraPosition
                                     cameraWithLatitude:self.coordinatats.latitude                                     longitude:self.coordinatats.longitude
                                     zoom:10];
        self.mapview.camera = camera;


    }

    [manager stopUpdatingLocation];



}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    
    self.googleId = [[NSMutableDictionary alloc] init];
    _mapview.myLocationEnabled = YES;
    
    if ([CLLocationManager locationServicesEnabled]) {
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    }
  GMSCameraPosition *camera = [GMSCameraPosition
      cameraWithLatitude:self.coordinatats.latitude
               longitude:self.coordinatats.longitude
                    zoom:10];
  self.mapview.camera = camera;

    NSLog(@"Current coor : %f" , self.coordinatats.latitude);
  self.mapview.padding = UIEdgeInsetsMake(0, 0, 15, 0);

  [self.mapview addSubview:_infoLabel];


    
  PFQuery *query = [PFQuery queryWithClassName:@"Test2"];
    [query selectKeys:@[@"googlid"]];
 
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.center = self.view.center;
//    spinner.color = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
   MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.label.text = @"Loading";
    hud.mode = MBProgressHUDAnimationFade;
    hud.contentColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
    hud.bezelView.color = [UIColor clearColor];
    [self.view addSubview:hud];
    
    
    [hud showAnimated:YES];
    
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
                       [hud hideAnimated:YES];
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
    }else {
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
    self.coordinatats = marker.position;
    return YES;
}

- (void)mapView:(GMSMapView *)mapView
    didTapInfoWindowOfMarker:(GMSMarker *)marker {

  mapView.selectedMarker = nil;

  NSLog(@" Taped on marker : %@", marker.title);
    
  DetailTableViewController *destViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
    self.coordinatats = marker.position;
    destViewController.coordinatats = marker.position;
    destViewController.Address = marker.title;
    NSLog(@" marker pos : %f", marker.position.latitude);

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
            if ([place.name rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
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
                                destViewController.coordinatats = place.coordinate;
                                destViewController.Address = place.name;
                                destViewController.googleIdTblview = place.placeID;
                                destViewController.working = YES;

                              [self.navigationController
                                  pushViewController:destViewController
                                            animated:YES];

                            }];

                [alert addAction:yes];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No"
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
  [self.searchController setActive:NO];
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
  if (self.showSegmant) {
    NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];

    self.switcher = [[UISegmentedControl alloc] initWithItems:types];
    self.switcher.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                                 UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleBottomMargin;
    self.switcher.selectedSegmentIndex = 0;
    self.switcher.translatesAutoresizingMaskIntoConstraints = YES;
    float X_Co = (self.view.frame.size.width - 250)/2;
    self.switcher.frame = CGRectMake(X_Co, 50, 250, 30);
    self.switcher.tintColor = [UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];
      [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];

    [self.mapview addSubview:_switcher];

    [self.switcher addTarget:self
                  action:@selector(didChangeSwitcher)
        forControlEvents:UIControlEventValueChanged];

    [self.navigationController setNavigationBarHidden:NO];
    self.showSegmant = NO;
  } else {
    [self.switcher removeFromSuperview];
    self.showSegmant = YES;
  }
}
@end
