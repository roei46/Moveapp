//
//  MapViewController.h
//  Googleplace
//
//  Created by Roei Baruch on 04/08/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView.h>


@interface tableView : UIViewController<SLExpandableTableViewDelegate,SLExpandableTableViewDatasource>

@property(nonatomic, strong) NSString *Address;




@end
