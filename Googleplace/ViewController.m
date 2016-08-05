//
//  ViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 25/07/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "ViewController.h"
#import "ServerProtocol.h"
#import "DatabaseManager.h"
#import "MapViewController.h"
static CGFloat kSearchBarHeight = 44.0f;
static NSString const *kNormalType = @"Normal";
static NSString const *kSatelliteType = @"Satellite";
static NSString const *kHybridType = @"Hybrid";
static NSString const *kTerrainType = @"Terrain";

@interface ViewController ()<GMSAutocompleteTableDataSourceDelegate,
                             UISearchDisplayDelegate>

@end

@implementation ViewController {
  UISegmentedControl *_switcher;
  UISearchBar *_searchBar;
  UISearchDisplayController *_searchDisplayController;
  GMSAutocompleteTableDataSource *_tableDataSource;
  UITextView *_resultView;
  GMSMapView *_mapView;
  GMSMarker *_Marker;
  GMSPlacesClient *placesclient;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Show map"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(showmap:)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.24 blue:0.45 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationItem.title = @"Moveinfo";
  self.edgesForExtendedLayout =
      UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;

  self.view.backgroundColor = [UIColor whiteColor];

  _searchBar = [[UISearchBar alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               kSearchBarHeight)];

  _tableDataSource = [[GMSAutocompleteTableDataSource alloc] init];
  _tableDataSource.delegate = self;

  _searchDisplayController =
      [[UISearchDisplayController alloc] initWithSearchBar:_searchBar
                                        contentsController:self];
  _searchDisplayController.searchResultsDataSource = _tableDataSource;
  _searchDisplayController.searchResultsDelegate = _tableDataSource;
  _searchDisplayController.delegate = self;
  _searchDisplayController.displaysSearchBarInNavigationBar = NO;

  _resultView = [[UITextView alloc]
      initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.bounds.size.width,
                               self.view.bounds.size.width - kSearchBarHeight)];
  _resultView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _resultView.editable = NO;

  [self.view addSubview:_searchBar];
  [self.view addSubview:_resultView];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    NSLog(@"prepareForSegue: %@", segue.identifier);

    if ([segue.identifier isEqualToString:@"map"]) {
  MapViewController *vc = (MapViewController *)segue.destinationViewController;
    
    
    }
    
    
}

- (void)showmap:(id)sender {
    
    [self performSegueWithIdentifier:@"map" sender:sender];

    
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchString:(NSString *)searchString {
  [_tableDataSource sourceTextHasChanged:searchString];
  return NO;
}

- (void)searchDisplayControllerDidEndSearch:
    (UISearchDisplayController *)controller {
  [_tableDataSource sourceTextHasChanged:@""];
}

#pragma mark - GMSAutocompleteTableDataSourceDelegate

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
    didAutocompleteWithPlace:(GMSPlace *)place {


    ServerProtocol *serverProtocol = [[ServerProtocol alloc]init];
    [serverProtocol isPlaceExist:place callback:^(BOOL exist) {
        
        
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
        }
        else{
            DatabaseManager *databaseManager = [[DatabaseManager alloc]init];
        [databaseManager addPlace:place callback:^(BOOL found) {
            
            if (found ) {
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Alert"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:@"Upload succeeded!"
                                     style:UIAlertActionStyleDefault
                                     handler:nil];
                [alert addAction:ok];
                
                [self presentViewController:alert
                                   animated:YES
                                 completion:nil];

            }
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Alert"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Upload succeeded!"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
            [alert addAction:ok];
            
            [self presentViewController:alert
                               animated:YES
                             completion:nil];
            
            
            UIAlertAction *failed = [UIAlertAction
                                     actionWithTitle:@"Upload failed!"
                                     style:UIAlertActionStyleDefault
                                     handler:nil];
            [alert addAction:failed];
            
            [self presentViewController:alert
                               animated:YES
                             completion:nil];

        }];
        }
        
        
        
    }];
    
  GMSCameraPosition *camera =
      [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                  longitude:place.coordinate.longitude
                                       zoom:10];
  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _Marker = [[GMSMarker alloc] init];
  _Marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude,
                                                place.coordinate.longitude);
  _Marker.map = _mapView;
  NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];

  _switcher = [[UISegmentedControl alloc] initWithItems:types];
  _switcher.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                               UIViewAutoresizingFlexibleWidth |
                               UIViewAutoresizingFlexibleBottomMargin;
  _switcher.selectedSegmentIndex = 0;
  _switcher.translatesAutoresizingMaskIntoConstraints = YES;
  self.navigationItem.titleView = _switcher;

  self.view = _mapView;

  [_switcher addTarget:self
                action:@selector(didChangeSwitcher)
      forControlEvents:UIControlEventValueChanged];

  [self.navigationController setNavigationBarHidden:NO];

  
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

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
    didFailAutocompleteWithError:(NSError *)error {
  _resultView.text =
      [NSString stringWithFormat:@"Autocomplete failed with error: %@",
                                 error.localizedDescription];
  [_searchDisplayController setActive:NO animated:YES];
}

- (void)didRequestAutocompletePredictionsForTableDataSource:
    (GMSAutocompleteTableDataSource *)tableDataSource {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [_searchDisplayController.searchResultsTableView reloadData];

}
- (void)didUpdateAutocompletePredictionsForTableDataSource:
    (GMSAutocompleteTableDataSource *)tableDataSource {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [_searchDisplayController.searchResultsTableView reloadData];
}

- (IBAction)onLaunchClicked:(id)sender {
  GMSAutocompleteViewController *acController =
      [[GMSAutocompleteViewController alloc] init];
  acController.delegate = self;
  [self presentViewController:acController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
