//
//  CSNNewsTableViewController.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/17/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNNewsTableViewController.h"
#import "CSNNewsDetailsViewController.h"
#import "CSNXMLParserOperation.h"
#import "CSNNewsTableViewCell.h"
#import "CSNNews.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsTableViewController ()

@property NSArray *news;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNNewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
//				URLWithString:@"http://en.censor.net.ua/includes/news_full_en.xml"]];

#warning test solution
	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
				fileURLWithPath:@"/Users/omel/Documents/Projects/censor_net_rss.xml"]];
	
	CSNXMLParserOperation *theOperation = [[CSNXMLParserOperation alloc]
				initWithData:theXML];
	__weak CSNXMLParserOperation *theWeakOperation = theOperation;
	
	theOperation.completionBlock = ^()
	{
		self.news = theWeakOperation.news;
		dispatch_async(dispatch_get_main_queue(), ^()
		{
			[self.tableView reloadData];
		});
	};

	[[NSOperationQueue new] addOperation:theOperation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
	return self.news.count;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    CSNNewsTableViewCell *theCell = [aTableView
				dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:anIndexPath];
	CSNNews *theNews = self.news[anIndexPath.row];
	theCell.dateLabel.text = [NSDateFormatter localizedStringFromDate:theNews.pubDate
				dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
	theCell.titleView.text = theNews.title;

	return theCell;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
	if ([aSegue.identifier isEqualToString:@"NewsDetailsSegue"])
	{
		CSNNews *theCurrentNews = self.news[self.tableView.indexPathForSelectedRow.row];
		CSNNewsDetailsViewController *theDestination = aSegue.destinationViewController;
		theDestination.currentNews = theCurrentNews;
	}
}


@end
