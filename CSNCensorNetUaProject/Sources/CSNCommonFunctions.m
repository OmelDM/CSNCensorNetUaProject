//
//  CSNCommonFunctions.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 4/7/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNCommonFunctions.h"

////////////////////////////////////////////////////////////////////////////////
NSString *CSNPathToStoredFileFromURLString(NSString *anURLString)
{
	NSString *theDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
				NSUserDomainMask, YES) lastObject];
	NSString *thePath = [theDirectory stringByAppendingFormat:@"/%@/%ld.jpg",
				[[NSBundle mainBundle] bundleIdentifier], [anURLString hash]];
	return thePath;
}