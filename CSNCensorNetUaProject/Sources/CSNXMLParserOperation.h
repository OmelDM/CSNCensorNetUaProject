//
//  CSNXMLParser.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/19/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
extern NSString *const kTitleName;
extern NSString *const kLinkName;
extern NSString *const kDescriptionName;
extern NSString *const kGuidName;
extern NSString *const kPubDateName;
extern NSString *const kCommentsName;
extern NSString *const kContentName;
extern NSString *const kEnclosureName;
extern NSString *const kURLName;
extern NSString *const kPathName;

////////////////////////////////////////////////////////////////////////////////
@interface CSNXMLParserOperation : NSOperation

/**
	Initializes operation object with RSS (XML) data to parse and completion block
	@param aData RSS (XML) data to parse
	@param aCompletionHandler Parameters of completion block are array of
	NSDictionary objects from parsed RSS (XML) and NSError object (is not nil in case of any error)
*/
- (instancetype)initWithData:(NSData *)aData
			complitionHandler:(void (^)(NSArray *anItems, NSError *anError))aCompletionHandler;

@end
