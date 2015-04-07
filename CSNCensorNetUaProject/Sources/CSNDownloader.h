//
//  CSNDownloader.h
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/20/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
@interface CSNDownloader : NSObject

+ (instancetype)sharedDownloader;

- (void)addFileToDownloaderAtURL:(NSString *)anURL;

@end
