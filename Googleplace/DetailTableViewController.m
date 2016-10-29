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
@property(strong, nonatomic) UIImage *btnImge;
@property(nonatomic, assign) BOOL press;
@property(strong, nonatomic) GMSMapView *_mapView;
@property(strong, nonatomic) GMSMarker *_Marker;
@property(strong, nonatomic) GMSPlacesClient *placesclient;
@property(strong, nonatomic) UISegmentedControl *_switcher;
@property(strong, nonatomic) NSArray *jsonResult2;
@property(strong, nonatomic) NSDictionary *appResult;
@property(strong, nonatomic) NSMutableDictionary *tempAppResult;


@end



@implementation DetailTableViewController
//    GMSMapView *_mapView;
//    GMSMarker *_Marker;
//    GMSPlacesClient *placesclient;
//    UISegmentedControl *_switcher;
//    NSArray *jsonResult2;
//    NSDictionary *appResult;
//    NSMutableDictionary  *tempAppResult;
//    
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);

   
    self.tableView.estimatedRowHeight = 500.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
  //  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor =
    [UIColor colorWithRed:0.25 green:0.73 blue:0.65 alpha:1.0];
    
    self.title = _Address;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21]
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
                                              self.jsonResult2 = [result objectForKey:@"results"];
                                              NSLog(@"result : %@", result);
                                              NSLog(@"test : %@", self.jsonResult2);
                                              for (NSDictionary *addname in self.jsonResult2) {
                                                  if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
                                                      self.appResult = addname[@"apartmentsDict"];
                                                      
                                                      self.arrHeader = (NSMutableArray *)[self.appResult allKeys];
                                                      NSLog(@"not sortd :%@", _arrHeader);
                                                      
                       
                                                      self.arrHeader  = (NSMutableArray *)[self.arrHeader sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                          return [obj1 compare:obj2 options:NSNumericSearch];
                                                      }];
                                                      
                                                      
                                                      NSLog(@" sortd :%@", self.arrHeader );

                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          self.tempAppResult = [[NSMutableDictionary alloc] init];
                                                          [self.appResult enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                              
                                                              [self.tempAppResult setValue:[[NSArray alloc] init] forKey:key] ;
                                                          }];
                                                         
                                                          [self.tableView reloadData];
                                                          NSLog(@"App result: %@", self.appResult);
                                                          NSLog(@"Temp App result: %@", self.tempAppResult);
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
 
 
 [customcell setBackgroundColor:[UIColor whiteColor]];
  
 customcell.textLabel.text = self.tempAppResult[self.arrHeader[indexPath.section]][indexPath.row];
     customcell.textLabel.textColor =[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0];

 customcell.textLabel.numberOfLines  = 0;
 customcell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
 
 
 
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
    
    [view setBackgroundColor:[UIColor colorWithRed:0.09 green:0.36 blue:0.41 alpha:1.0]];
    UIImage *img = [UIImage imageNamed:@"home.png"];
    UIImageView *img2 =[[UIImageView alloc] initWithImage:img];
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, tableView.bounds.size.width, 44)];
    
    [img2 setCenter:CGPointMake( 15,view.bounds.size.height/2)];
    
    

    NSString *title1 = [[NSString alloc] initWithFormat:@" Apartment : %@" ,[self.arrHeader objectAtIndex:section]];

    NSMutableAttributedString *title3 = [[NSMutableAttributedString alloc] initWithString:title1];
    
    [title3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,title1.length)];
   headerView.attributedText =title3;

    //headerView.text =[title1 stringByAppendingString:title2];
    self.btnImge = [UIImage imageNamed:@"expand-button.png"];

    UIImageView *ximage =[[UIImageView alloc] initWithImage:self.btnImge];
    ximage.accessibilityLabel = @"expand-button.png";

    //[ximage setCenter:CGPointMake( 300,view.bounds.size.height/2)];
    ximage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30,ximage.bounds.size.height/2,20,20);
    ximage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin ;

    
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:view.frame];
    button.tag = section;
    button.accessibilityLabel = [self.arrHeader objectAtIndex:section];
    [button addTarget:self action:@selector(sectionHeaderSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor
                              ];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin ;

   
    [view addSubview:ximage];
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
    
    return [self.tempAppResult[self.arrHeader[section]] count];
}



- (void)back:(id)sender {
    
    self._mapView.selectedMarker = nil;
    
    AddinformationViewcontroller *destViewController = [self.storyboard
                                                        instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];
    
    destViewController.Address = _Address;
    destViewController.working = NO;
    
    [self.navigationController pushViewController:destViewController
                                         animated:YES];
}

- (void)addInfo:(id)sender {
    
    self._mapView.selectedMarker = nil;
    
    AddinformationViewcontroller *destViewController = [self.storyboard
                                                        instantiateViewControllerWithIdentifier:@"AddinformationViewcontroller"];
    
    destViewController.Address = _Address;
    destViewController.working = NO;
    
    [self.navigationController pushViewController:destViewController
                                         animated:YES];
}


#pragma mark table view delegate





-(void)sectionHeaderSelected:(id)sender
{
    
    NSUInteger section = ((UIButton*)sender).tag;
    NSString * key = ((UIButton*)sender).accessibilityLabel;
    NSMutableArray* IndexPathArray = [[NSMutableArray alloc] init];
    
    UIImageView* tempImageView;
    
    for (UIImageView* imageView in ((UIView*)((UIButton*)sender).superview).subviews)
    {
        if([imageView.accessibilityLabel isEqualToString:@"expand-button.png"])
        {
            
            
            tempImageView = imageView;
            break;
        }
    }
    
    if( [self.tempAppResult[key] count] > 0 )
    {
        //if section has rows,reset value
        
        tempImageView.image = [UIImage imageNamed:@"expand-button.png"];
       
        
        
        int row  = (int)[self.tempAppResult[key] count] ;
        
        for(int i = 0 ; i < row; ++i)
        {
            [IndexPathArray addObject:[NSIndexPath indexPathForRow: i inSection:section]];
        }
        
        [self.tempAppResult setObject:[[NSArray alloc ] init] forKey:key];
       NSLog(@"Collapsed section %@",self.tempAppResult);
        
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:IndexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        
        
    }
    else
    {
        //if section has no rows,add  value
        
         tempImageView.image = [UIImage imageNamed:@"expand-arrow.png"];
        
        [self.tempAppResult setObject:self.appResult[key] forKey:key];
        NSLog(@"Expand section %@",self.tempAppResult);
        NSMutableArray* IndexPathArray = [[NSMutableArray alloc] init];
        
        int row  = (int)[self.tempAppResult[key] count] ;
        
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





@end


