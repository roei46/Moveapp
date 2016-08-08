//
//  AddinformationViewcontroller.m
//  Googleplace
//
//  Created by Roei Baruch on 06/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "AddinformationViewcontroller.h"
#define TestTable @"https://movex.herokuapp.com/parse/classes/Test2"

@interface AddinformationViewcontroller ()
@property(strong ,nonatomic)NSMutableString  *googlid;

@end

@implementation AddinformationViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"this : %@" , _Address);
  //  NSLog(@"this : %f ,%f" , _dbllatitude,_dbllongitude);

    self.title = _Address;
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://movex.herokuapp.com/parse/classes/Test2"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"movexroei" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setHTTPMethod:@"GET"];
    
    NSLog(@"request : %@",request);
    
    NSURLSessionDataTask *postdata = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        NSArray *resarr = [dic valueForKey:@"results"];
        
        NSLog(@"test : %@" , dic);
         for (NSDictionary *addname in resarr){
             if ([[addname valueForKey:@"Address"] isEqualToString:_Address]) {
                 
                 _googlid =[addname valueForKey:@"googlid"];
                 NSLog(@"placeid :%@" ,_googlid);
                 break;
             }
             
             
             
         }
    }];
    
    [postdata resume];
    
    
    
    
    
    
    
    
    
    
    
//    
//    CLLocationCoordinate2D Location;
//    
//    Location.latitude = _dbllatitude;
//    Location.longitude = _dbllongitude;
//    
//    NSLog(@"this : %f ,%f" , Location.latitude,Location.longitude);
//    
//    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:CLLocationCoordinate2DMake(Location.latitude , Location.longitude)
//                                  completionHandler:^(GMSReverseGeocodeResponse * response, NSError *error){
//                                      for(GMSAddress *result in response.results){
//                                          NSLog(@"addressLine1:%@", result.lines);
//                                          NSLog(@"addressLine1:%@", result.thoroughfare);
//
//                                      }
//                                  }];
    
    
  

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
