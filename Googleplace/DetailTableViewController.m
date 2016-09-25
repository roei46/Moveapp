//
//  DetailTableViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 15/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AddinformationViewcontroller.h"
#import "DatabaseManager.h"
#import "ServerProtocol.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "customCell.h"

@interface DetailTableViewController ()<GMSMapViewDelegate, UITableViewDelegate,
UITableViewDataSource >
@property(nonatomic, strong) GMSMarker *selectedMarker;
@property(strong, nonatomic) NSMutableString *DBid;
@property(strong, nonatomic) NSMutableArray *arrHeader;

@end



@implementation DetailTableViewController{
    GMSMapView *_mapView;
    GMSMarker *_Marker;
    GMSPlacesClient *placesclient;
    UISegmentedControl *_switcher;
    NSArray *jsonResult2;
    NSDictionary *appResult;
    NSMutableDictionary  *tempAppResult;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    self.tableView.estimatedRowHeight = 500.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor =
    [UIColor whiteColor];
    
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

//-(void)loadView
//{
//    self.tableView= [[SLExpandableTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    
//}

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
                                                          tempAppResult = [[NSMutableDictionary alloc] init];
                                                          [appResult enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                              
                                                              [tempAppResult setValue:[[NSArray alloc] init] forKey:key] ;
                                                          }];
                                                         
                                                          [self.tableView reloadData];
                                                          NSLog(@"App result: %@", appResult);
                                                          NSLog(@"Temp App result: %@", tempAppResult);
                                                      });
                                                      
                                                      break;
                                                  }
                                              }
                                          }
                                      }];
    
    [postdata resume];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
 
 
 //if(indexPath.row > 0)
 //{
 customcell.textLabel.text = tempAppResult[_arrHeader[indexPath.section]][indexPath.row];
 customcell.textLabel.numberOfLines  = 0;
 customcell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
 
 
 //customcell.label.text = appResult[_arrHeader[indexPath.section]][indexPath.row - 1];
 
 
 //customcell.cellLabel.text = appResult[_arrHeader[indexPath.section]][indexPath.row - 1];
 
 //}
 
 
 [customcell.cellLabel sizeToFit];
 
 customcell.preservesSuperviewLayoutMargins = false;
 customcell.separatorInset = UIEdgeInsetsZero;
 customcell.layoutMargins = UIEdgeInsetsZero;
 
 return customcell;
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
    
    UIButton * button = [[UIButton alloc] initWithFrame:view.frame];
    button.tag = section;
    button.accessibilityLabel = [_arrHeader objectAtIndex:section];
    [button addTarget:self action:@selector(sectionHeaderSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    
    [view addSubview:headerView];
    [view addSubview:img2];
    [view addSubview:button];
    
    
    
    return view;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44.0f;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [tempAppResult[_arrHeader[section]] count];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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


#pragma mark table view delegate




//- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
//{
//    // return YES, if the section should be expandable
//    NSLog(@"canExpandSection");
//    return TRUE;
//}
//
//- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
//{
//    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
//    NSLog(@"needsToDownloadDataForExpandableSection");
//    return FALSE;
//    
//    
//}
//- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
//{
//    // this cell will be displayed at IndexPath with section: section and row 0
//    
//    
//    NSString *CellIdentifier = @"ExpandableCell";
//    ExpandableCell *expandableCell = (ExpandableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (expandableCell == nil) {
//        expandableCell = [[ExpandableCell   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    expandableCell .textLabel.text = @"Push to see feedbacks";
//    
//    expandableCell .preservesSuperviewLayoutMargins = false;
//    expandableCell .separatorInset = UIEdgeInsetsZero;
//    expandableCell .layoutMargins = UIEdgeInsetsZero;
//    
//    return expandableCell ;
//}


-(void)sectionHeaderSelected:(id)sender
{
    NSUInteger section = ((UIButton*)sender).tag;
    NSString * key = ((UIButton*)sender).accessibilityLabel;
    NSMutableArray* IndexPathArray = [[NSMutableArray alloc] init];
    
    if( [tempAppResult[key] count] > 0 )
    {
        //if section has rows,reset value
        int row  = [tempAppResult[key] count] ;
        
        for(int i = 0 ; i < row; ++i)
        {
            [IndexPathArray addObject:[NSIndexPath indexPathForRow: i inSection:section]];
        }
        
        [tempAppResult setObject:[[NSArray alloc ] init] forKey:key];
       NSLog(@"Collapsed section %@",tempAppResult);
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:IndexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
    else
    {
        //if section has no rows,add  value
        
        [tempAppResult setObject:appResult[key] forKey:key];
        NSLog(@"Expand section %@",tempAppResult);
        NSMutableArray* IndexPathArray = [[NSMutableArray alloc] init];
        
        int row  = [tempAppResult[key] count] ;
        
        NSLog(@"Row count %d", row);
        
        for(int i = 0 ; i < row; ++i)
        {
            [IndexPathArray addObject:[NSIndexPath indexPathForRow: i inSection:section]];
        }
        
        
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:IndexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
}




#pragma mark table view delegate

//- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
//{
//    // download your data here
//    // call [tableView expandSection:section animated:YES]; if download was successful
//    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
//    NSLog(@"downloadDataForExpandableSection");
//}
//
//- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
//{
//    //...
//    NSLog(@"didExpandSection");
//}
//
//- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
//{
//    //...
//    NSLog(@"didCollapseSection");
//}
//
@end


