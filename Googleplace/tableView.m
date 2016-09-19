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
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "customCell.h"
#import "ExpandableCell.h"




@interface tableView () <GMSMapViewDelegate, UITableViewDelegate,
                         UITableViewDataSource >
@property(nonatomic, strong) GMSMarker *selectedMarker;
@property(strong, nonatomic) IBOutlet UITableView *tblView;
@property(strong, nonatomic) NSMutableString *DBid;
@property(strong, nonatomic) NSMutableArray *arrHeader;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;

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
    
   
    self.tblView.tableFooterView.hidden = YES;
    self.tblView.estimatedRowHeight = 500.0;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    
    
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
    [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     style:UIBarButtonItemStylePlain target:self action:@selector(addInfo:)];
    

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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    
    [view setBackgroundColor:[UIColor colorWithRed:0.31 green:0.65 blue:0.83 alpha:1.0]];
    UIImage *img = [UIImage imageNamed:@"home.png"];
    UIImageView *img2 =[[UIImageView alloc] initWithImage:img];
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, tableView.bounds.size.width, 44)];
    
    
    [img2 setCenter:CGPointMake( 15,view.bounds.size.height/2)];

    [view addSubview:headerView];
    

    NSString *title1 = @" Apartment : ";

    headerView.text =[title1 stringByAppendingString:[_arrHeader objectAtIndex:section]];
   [view addSubview:headerView];
    [view addSubview:img2];

    
    
    return view;
    
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
  return [appResult[_arrHeader[section]] count] + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    


        static NSString *CellIdentifier = @"cell";
        customCell * customcell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (customcell== nil) {
            customcell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier];
   
        }
        
        
        [customcell setSeparatorInset:UIEdgeInsetsZero];
        
        [customcell setBackgroundColor:[UIColor colorWithRed:0.91 green:0.97 blue:1.00 alpha:1.0]];
    
    
    if(indexPath.row > 0)
    {
        customcell.textLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row - 1];
        customcell.textLabel.numberOfLines  = 0;
        customcell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        //customcell.label.text = appResult[_arrHeader[indexPath.section]][indexPath.row - 1];
        
        
        //customcell.cellLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row - 1];
        
    }

    
     [customcell.cellLabel sizeToFit];
    
    customcell.preservesSuperviewLayoutMargins = false;
    customcell.separatorInset = UIEdgeInsetsZero;
    customcell.layoutMargins = UIEdgeInsetsZero;

  return customcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    [tableView beginUpdates];
    [tableView endUpdates];
}


//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  self.tblView.delegate = self;
//  self.tblView.dataSource = self;
    


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
            NSLog(@"result : %@", result);
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
                   
                    self.tblView= [[SLExpandableTableView alloc] initWithFrame:self.tblView.frame style:UITableViewStylePlain];
                    self.tblView.delegate = self;
                    self.tblView.dataSource = self;
                    self.tblView.separatorInset = UIEdgeInsetsZero;
                    [self.view addSubview:self.tblView];
                    self.tblView= [[SLExpandableTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    
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

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    // return YES, if the section should be expandable
    NSLog(@"canExpandSection");
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    NSLog(@"needsToDownloadDataForExpandableSection");
    return FALSE;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    // this cell will be displayed at IndexPath with section: section and row 0
    
    
    NSString *CellIdentifier = @"ExpandableCell";
    ExpandableCell *expandableCell = (ExpandableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (expandableCell == nil) {
        expandableCell = [[ExpandableCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    expandableCell .textLabel.text = @"blah blah";
    
    return expandableCell ;
}

#pragma mark table view delegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    // download your data here
    //call [tableView expandSection:section animated:YES]; if your download was successful
    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
    NSLog(@"downloadDataForExpandableSection");
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
    NSLog(@"didExpandSection");
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    //...
    NSLog(@"didCollapseSection");
}





@end
