//
//  StreetViewController.m
//  Googleplace
//
//  Created by Roei Baruch on 17/12/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "StreetViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface StreetViewController ()<GMSPanoramaViewDelegate>

@end

@implementation StreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Street view";

    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    [panoView moveNearCoordinate:CLLocationCoordinate2DMake(self.coordinatats.latitude, self.coordinatats.longitude)];
    panoView.delegate = self;
    self.view = panoView;
    
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
