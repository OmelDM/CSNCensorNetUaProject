//
//  CSNXMLParser.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNXMLParserOperation.h"
#import "CSNNews.h"
#import "CSNDownloader.h"

////////////////////////////////////////////////////////////////////////////////
NSString *const kItemName = @"item";
NSString *const kTitleName = @"title";
NSString *const kLinkName = @"link";
NSString *const kDescriptionName = @"description";
NSString *const kGuidName = @"guid";
NSString *const kPubDateName = @"pubDate";
NSString *const kCommentsName = @"comments";
NSString *const kContentName = @"content";
NSString *const kEnclosureName = @"enclosure";
NSString *const kURLName = @"url";

////////////////////////////////////////////////////////////////////////////////
@interface CSNXMLParserOperation () <NSXMLParserDelegate>

@property (nonatomic, copy) NSData *parsedData;
@property (nonatomic, strong) CSNNews *currentNews;
@property (nonatomic, strong) NSMutableArray *compositNews;
@property (nonatomic, strong) NSMutableString *currentCharacters;
@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, copy) void (^completionHandler)(NSArray *anItems, NSError *anError);
// TODO: move away from parser any core data handling
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNXMLParserOperation

- (instancetype)initWithData:(NSData *)aData
{
	self = [super init];
	
	if (nil != self)
	{
		self.parsedData = aData;
	}
	
	return self;
}

- (instancetype)initWithData:(NSData *)aData persistentStoreCoordinator:(NSPersistentStoreCoordinator *)aCoordinator
			complitionHandler:(void (^)(NSArray *anItems, NSError *anError))aCompletionHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.parsedData = aData;
		self.completionHandler = aCompletionHandler;
		self.coordinator = aCoordinator;
	}
	
	return self;
}

#pragma mark NSOperation overrode methods
- (void)main
{
	@autoreleasepool
	{
		@try
		{
			self.context = [[NSManagedObjectContext alloc] init];
			self.context.persistentStoreCoordinator = self.coordinator;
		NSLog(@"start parser count: %ld", [self.context executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"News"] error:NULL].count);
			NSXMLParser *theParser = [[NSXMLParser alloc]
						initWithData:self.parsedData];
			theParser.delegate = self;
			if (![theParser parse])
			{
				self.completionHandler(nil, theParser.parserError);
			}
		}
		@catch(...)
		{
			self.completionHandler(nil, [NSError
						errorWithDomain:NSCocoaErrorDomain code:101
						userInfo:@{NSLocalizedDescriptionKey: @"Unexpected parser error"}]);
		}
	}
}

#pragma mark NSXMLParserDelegate methods
- (void)parserDidStartDocument:(NSXMLParser *)aParser
{
	self.compositNews = [NSMutableArray new];
	self.currentCharacters = [NSMutableString new];
	self.dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
				error:NULL];
}

- (void)parserDidEndDocument:(NSXMLParser *)aParser
{
	NSError *theError = nil;
	if (![self.context save:&theError])
	{
		#warning Handle error
		self.completionHandler(nil, theError);
	}
	
	self.completionHandler([NSArray arrayWithArray:self.compositNews], nil);
	self.compositNews = nil;
	self.currentNews = nil;
	self.currentCharacters = nil;
	self.dataDetector = nil;
}

- (void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)anElementName
			namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aName
			attributes:(NSDictionary *)anAttributeDictionary
{
	if ([anElementName isEqualToString:kItemName])
	{
		NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"News"
					inManagedObjectContext:self.context];
		self.currentNews = [[CSNNews alloc] initWithEntity:theEntity
					insertIntoManagedObjectContext:nil];
	}
	else if (nil != self.currentNews && ([anElementName isEqualToString:kTitleName] ||
				[anElementName isEqualToString:kLinkName] ||
				[anElementName isEqualToString:kDescriptionName] ||
				[anElementName isEqualToString:kGuidName] ||
				[anElementName isEqualToString:kPubDateName] ||
				[anElementName isEqualToString:kCommentsName] ||
				[anElementName isEqualToString:kContentName]))
	{
		[self.currentCharacters setString:@""];
	}
	else if (nil != self.currentNews && [anElementName isEqualToString:kEnclosureName])
	{
		NSString *theURL = anAttributeDictionary[kURLName];
		if (nil != theURL)
		{
			self.currentNews.enclosure = theURL;
			self.currentNews.imagePath = [[CSNDownloader sharedDownloader]
						addFileToDownloaderAtURL:[NSURL URLWithString:theURL]];
		}
	}

}

- (void)parser:(NSXMLParser *)aParser didEndElement:(NSString *)anElementName
			namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aName
{
	if (nil == self.currentNews)
	{
		return;
	}
	else if ([anElementName isEqualToString:kItemName])
	{
		[self addNews:self.currentNews];
	}
	else if ([anElementName isEqualToString:kTitleName])
	{
		self.currentNews.title = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kLinkName])
	{
		self.currentNews.link = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kDescriptionName])
	{
		self.currentNews.details = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kGuidName])
	{
		self.currentNews.guid = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kPubDateName])
	{
		NSTextCheckingResult *theResult = [[self.dataDetector
					matchesInString:self.currentCharacters options:0
					range:NSMakeRange(0, self.currentCharacters.length)] lastObject];
		self.currentNews.pubDate = theResult.date;
	}
	else if ([anElementName isEqualToString:kCommentsName])
	{
		self.currentNews.comments = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kContentName])
	{
		self.currentNews.content = [self cleanedContentStringFromString:self.currentCharacters];
	}
}

- (void)parser:(NSXMLParser *)aParser foundCharacters:(NSString *)aString
{
	[self.currentCharacters appendString:aString];
}

- (void)parser:(NSXMLParser *)aParser parseErrorOccurred:(NSError *)aParseError
{
	self.completionHandler(nil, aParseError);
}

#pragma mark Private methods
- (NSString *)cleanedContentStringFromString:(NSString *)aString
{
	NSString *theResult = [aString stringByTrimmingCharactersInSet:[NSCharacterSet
					whitespaceAndNewlineCharacterSet]];
	theResult = [theResult stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n"];
	theResult = [theResult stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
	
	return theResult;
}

- (void)addNews:(CSNNews *)aNews
{
	NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:@"News"];
	theRequest.predicate = [NSPredicate predicateWithFormat:@"guid = %@", aNews.guid];
	theRequest.propertiesToFetch = @[@"guid"];
    [theRequest setResultType:NSDictionaryResultType];
	
	NSError *theError = nil;
	NSArray *theFoundNews = [self.context executeFetchRequest:theRequest error:&theError];
	if (nil != theError)
	{
		#warning handle error
		return;
	}
	
	if (0 == theFoundNews.count)
	{
		[self.context insertObject:aNews];
	}
}

@end
