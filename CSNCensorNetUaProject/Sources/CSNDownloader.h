//
//  CSNDownloader.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/20/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
@interface CSNDownloader : NSObject

+ (instancetype)sharedDownloader;

/**
	@return NSString with path to downloaded file
*/
- (NSString *)addFileToDownloaderAtURL:(NSURL *)anURL;

@end
