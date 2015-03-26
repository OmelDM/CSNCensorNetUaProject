//
//  CSNNewsTableViewCell.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/21/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end
