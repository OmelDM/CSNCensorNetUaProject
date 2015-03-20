//
//  CSNNewsTableViewController.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/17/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNNewsTableViewController.h"
#import "CSNXMLParserOperation.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsTableViewController ()

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
		NSLog(@"%@", theWeakOperation.news);
	};

	[[NSOperationQueue new] addOperation:theOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
