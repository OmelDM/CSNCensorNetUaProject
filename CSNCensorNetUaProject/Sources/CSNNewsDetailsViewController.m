//
//  CSNNewsDetailsViewController.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/23/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNNewsDetailsViewController.h"
#import "CSNNews.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *publicationDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *fotoView;
@property (nonatomic, weak) IBOutlet UITextView *contentView;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNNewsDetailsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.publicationDateLabel.text = [NSDateFormatter
				localizedStringFromDate:self.currentNews.pubDate
				dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
	self.titleLabel.text = self.currentNews.title;
	self.fotoView.image = [UIImage imageWithContentsOfFile:self.currentNews.imagePath];
	self.contentView.text = self.currentNews.content;
	
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
