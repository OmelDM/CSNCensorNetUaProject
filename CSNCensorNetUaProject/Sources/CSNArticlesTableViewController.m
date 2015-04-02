//
//  CSNArticlesTableViewController.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/26/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNArticlesTableViewController.h"
#import "CSNXMLParserOperation.h"
#import "CSNNewsTableViewCell.h"
#import "CSNNews.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNArticlesTableViewController ()

@property NSArray *articles;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNArticlesTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"Articles";
	
//	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
//				URLWithString:@"http://en.censor.net.ua/includes/resonance_full_en.xml"]];

#warning test solution
//	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
//				fileURLWithPath:@"/Users/omel/Documents/Projects/resonance_full_en.xml"]];
//	
//	CSNXMLParserOperation *theOperation = [[CSNXMLParserOperation alloc]
//				initWithData:theXML complitionHandler:^(NSArray *anItems, NSError *anError)
//				{
//					if (nil != anError)
//					{
//						#warning Handle error
//						return;
//					}
//					
//					self.articles = anItems;
//					dispatch_async(dispatch_get_main_queue(), ^()
//					{
//						[self.tableView reloadData];
//					});
//				}];
//
//	[[NSOperationQueue new] addOperation:theOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    CSNNewsTableViewCell *theCell = [aTableView
				dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:anIndexPath];
	CSNNews *theNews = self.articles[anIndexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
