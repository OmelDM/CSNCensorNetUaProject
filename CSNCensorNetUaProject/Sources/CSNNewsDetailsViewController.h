//
//  CSNNewsDetailsViewController.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/23/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
@class CSNNews;

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsDetailsViewController : UIViewController

@property (nonatomic, strong) CSNNews *currentNews;

@end
