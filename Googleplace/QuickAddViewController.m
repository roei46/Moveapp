//
//  QuickAddViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 20/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "QuickAddViewController.h"
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DatabaseManager.h"
#import "ServerProtocol.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>


@interface QuickAddViewController ()<GMSAutocompleteResultsViewControllerDelegate,
GMSMapViewDelegate>
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) GMSAutocompleteResultsViewController *_acViewController;


@end

@implementation QuickAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __acViewController = [[GMSAutocompleteResultsViewController alloc] init];
    __acViewController.delegate = self;
    
    _searchController = [[UISearchController alloc]
                         initWithSearchResultsController:__acViewController];
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
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

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    // Display the results and dismiss the search controller.
    [_searchController setActive:NO];
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
    // Display the error and dismiss the search controller.
    [_searchController setActive:NO];
}

// Show and hide the network activity indicator when we start/stop loading results.

- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
