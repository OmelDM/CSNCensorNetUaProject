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
#import "CSNEnclosure.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNNewsTableViewController ()

@property NSArray *news;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNNewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 61.0;
	
	self.title = @"News";
	
	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
				URLWithString:@"http://en.censor.net.ua/includes/news_full_en.xml"]];

//#warning test solution
//	NSData *theXML = [NSData dataWithContentsOfURL:[NSURL
//				fileURLWithPath:@"/Users/omel/Documents/Projects/censor_net_rss.xml"]];
	
	CSNXMLParserOperation *theOperation = [[CSNXMLParserOperation alloc]
				initWithData:theXML	complitionHandler:^(NSArray *anItems, NSError *anError)
				{
					if (nil != anError)
					{
						#warning Handle error
						abort();
					}
					
					[self addNewsFromArray:anItems];
					NSError *theError = nil;
					if (![self.managedObjectContext save:&theError])
					{
						#warning Handle error
						abort();
					}
					
					NSFetchRequest *theRequest = [[NSFetchRequest alloc] initWithEntityName:@"News"];
					theRequest.returnsObjectsAsFaults = NO;
					theRequest.relationshipKeyPathsForPrefetching = @[@"enclosure"];
					theRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO]];
					theError = nil;
					self.news = [self.managedObjectContext executeFetchRequest:theRequest error:&theError];
					NSLog(@"count: %ld", self.news.count);
					if (nil != theError)
					{
						#warning Handle error
						abort();
					}
					
					dispatch_async(dispatch_get_main_queue(), ^()
					{
						[self.tableView reloadData];
					});
				}];

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
	theCell.titleLabel.text = theNews.title;

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

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
	if (nil != _managedObjectContext)
	{
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *theCoordinator = [self persistentStoreCoordinator];
	if (nil != theCoordinator)
	{
		_managedObjectContext = [[NSManagedObjectContext alloc] init];
		[_managedObjectContext setPersistentStoreCoordinator:theCoordinator];
	}
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (nil != _persistentStoreCoordinator)
	{
		return _persistentStoreCoordinator;
	}
	
	NSURL *theStoreURL = [[[[NSFileManager defaultManager]
				URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]
				lastObject] URLByAppendingPathComponent:@"News_Data.sqlite"];
	
	NSError *theError = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
				initWithManagedObjectModel:[self managedObjectModel]];
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
				configuration:nil URL:theStoreURL options:nil error:&theError])
	{
		#warning Handle error
	}
	
	return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (nil != _managedObjectModel)
	{
		return _managedObjectModel;
	}
	
	NSURL *theModelURL = [[NSBundle mainBundle] URLForResource:@"NewsData" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theModelURL];
	
	return _managedObjectModel;
}

#pragma mark - Private methods

- (void)addNewsFromArray:(NSArray *)anArray
{
	if (0 == anArray.count)
	{
		return;
	}
	
	NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:@"News"];
	theRequest.propertiesToFetch = @[@"guid"];
    [theRequest setResultType:NSDictionaryResultType];
	
	for (NSDictionary *theNews in anArray)
	{
		theRequest.predicate = [NSPredicate predicateWithFormat:@"guid = %@",
					theNews[@"guid"]];
		NSError *theError = nil;
		NSArray *theFoundNews = [self.managedObjectContext
					executeFetchRequest:theRequest error:&theError];
		if (nil != theError)
		{
			#warning handle error
			continue;
		}
		
		if (0 == theFoundNews.count)
		{
			CSNNews *theInsertedNews = [self newsWithDictionary:theNews];
			[self.managedObjectContext insertObject:theInsertedNews];
		}
	}
}

- (CSNNews *)newsWithDictionary:(NSDictionary *)aDictionary
{

	NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"News"
				inManagedObjectContext:self.managedObjectContext];
	CSNNews *theResultNews = [[CSNNews alloc] initWithEntity:theEntity
				insertIntoManagedObjectContext:nil];
	theResultNews.title = aDictionary[kTitleName];
	theResultNews.link = aDictionary[kLinkName];
	theResultNews.details = aDictionary[kDescriptionName];
	theResultNews.guid = aDictionary[kGuidName];
	theResultNews.pubDate = aDictionary[kPubDateName];
	theResultNews.comments = aDictionary[kCommentsName];
	theResultNews.content = aDictionary[kContentName];

	for (NSDictionary *theDict in aDictionary[kEnclosureName])
	{
//		NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"Enclosure"
//				inManagedObjectContext:self.managedObjectContext];
		CSNEnclosure *theResultEnclosure = [NSEntityDescription
					insertNewObjectForEntityForName:@"Enclosure"
					inManagedObjectContext:self.managedObjectContext];
		theResultEnclosure.url = theDict[kURLName];
		theResultEnclosure.path = theDict[kPathName];
		[theResultNews addEnclosureObject:theResultEnclosure];
//		[self.managedObjectContext insertObject:theResultEnclosure];
	}
	
	return theResultNews;
}

@end
