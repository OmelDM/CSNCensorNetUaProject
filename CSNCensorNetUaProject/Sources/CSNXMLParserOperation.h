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
@interface CSNXMLParserOperation : NSOperation

/**
	Initializes operation object with RSS (XML) data to parse and completion block
	@param aData RSS (XML) data to parse
	@param aCompletionHandler Parameters of completion block are array of
	CSNNews objects from parsed RSS (XML) and NSError object (is nil in case of any error)
*/
- (instancetype)initWithData:(NSData *)aData
			complitionHandler:(void (^)(NSArray *anItems, NSError *anError))aCompletionHandler;

@end
