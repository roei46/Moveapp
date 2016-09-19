//
//  ExpandableCell.h
//  Googleplace
//
//  Created by Roei Baruch on 13/09/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView.h>

@interface ExpandableCell : UITableViewCell<UIExpandingTableViewCell>

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;

@end
