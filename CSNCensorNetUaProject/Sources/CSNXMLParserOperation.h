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
	Array of CSNNews objects from parsed RSS (XML). Should be called after
	operation will finished
 */
@property (nonatomic, readonly) NSArray *news;

/**
	Initializes operation object with RSS (XML) data to parse
	@param aData RSS (XML) data to parse
*/
- (instancetype)initWithData:(NSData *)aData;

@end
