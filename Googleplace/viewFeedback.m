//
//  viewFeedback.m
//  Googleplace
//
//  Created by Roei Baruch on 25/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import "viewFeedback.h"

@interface viewFeedback ()
@property(weak, nonatomic) IBOutlet UITextView *FeedView;

@end

@implementation viewFeedback

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [self.view
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"papers.co-vl20-android-"
                                                     @"marshmallow-new-green-"
                                                     @"pink-pattern-4-"
                                                     @"wallpaper.jpg"]]];
    _FeedView.backgroundColor = [UIColor clearColor];


  _FeedView.text = _Address;
   // _FeedView.text = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
