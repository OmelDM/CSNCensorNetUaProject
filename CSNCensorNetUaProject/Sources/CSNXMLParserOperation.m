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
NSString *const kImagePathName = @"imagePath";

////////////////////////////////////////////////////////////////////////////////
@interface CSNXMLParserOperation () <NSXMLParserDelegate>

@property (nonatomic, copy) NSData *parsedData;
@property (nonatomic, strong) NSMutableDictionary *currentNews;
@property (nonatomic, strong) NSMutableArray *compositNews;
@property (nonatomic, strong) NSMutableString *currentCharacters;
@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, copy) void (^completionHandler)(NSArray *anItems, NSError *anError);

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

- (instancetype)initWithData:(NSData *)aData
			complitionHandler:(void (^)(NSArray *anItems, NSError *anError))aCompletionHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.parsedData = aData;
		self.completionHandler = aCompletionHandler;
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
		self.currentNews = [NSMutableDictionary dictionary];
	}
	else if (nil != self.currentNews && ([anElementName isEqualToString:kTitleName] ||
				[anElementName isEqualToString:kLinkName] ||
				[anElementName isEqualToString:kDescriptionName] ||
				[anElementName isEqualToString:kGuidName] ||
				[anElementName isEqualToString:kPubDateName] ||
				[anElementName isEqualToString:kCommentsName] ||
				[anElementName isEqualToString:kContentName]))
	{
		self.currentCharacters = [NSMutableString new];
	}
	else if (nil != self.currentNews && [anElementName isEqualToString:kEnclosureName])
	{
		NSString *theURL = anAttributeDictionary[kURLName];
		if (nil != theURL)
		{
			self.currentNews[kEnclosureName] = theURL;
			self.currentNews[kImagePathName] = [[CSNDownloader sharedDownloader]
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
		[self.compositNews addObject:self.currentNews];
	}
	else if ([anElementName isEqualToString:kTitleName])
	{
		self.currentNews[kTitleName] = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kLinkName])
	{
		self.currentNews[kLinkName] = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kDescriptionName])
	{
		self.currentNews[kDescriptionName] = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kGuidName])
	{
		self.currentNews[kGuidName] = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kPubDateName])
	{
		NSTextCheckingResult *theResult = [[self.dataDetector
					matchesInString:self.currentCharacters options:0
					range:NSMakeRange(0, self.currentCharacters.length)] lastObject];
		self.currentNews[kPubDateName] = theResult.date;
	}
	else if ([anElementName isEqualToString:kCommentsName])
	{
		self.currentNews[kCommentsName] = self.currentCharacters;
	}
	else if ([anElementName isEqualToString:kContentName])
	{
		self.currentNews[kContentName] = [self cleanedContentStringFromString:self.currentCharacters];
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

@end
