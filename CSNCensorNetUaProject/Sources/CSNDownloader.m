//
//  CSNDownloader.m
//  CSNCensorNetUaProject
//
//  Created by Dmytro Omelchuk on 3/20/15.
//  Copyright (c) 2015 Dmytro Omelchuk. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
#import "CSNDownloader.h"

////////////////////////////////////////////////////////////////////////////////
@interface CSNDownloader ()

@property (nonatomic, strong) NSURLSession *session;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation CSNDownloader

+ (instancetype)sharedDownloader
{
	static CSNDownloader *sDownloader = nil;
	static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken,
	^{
		sDownloader = [[self alloc] init];
    });
	
	return sDownloader;
}

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
					ephemeralSessionConfiguration]];
	}
	
	return self;
}

- (NSString *)addFileToDownloaderAtURL:(NSURL *)anURL
{
	NSString *thePathToFile = [self pathToDownloadedFileAtURL:anURL];

	if (![[NSFileManager defaultManager] fileExistsAtPath:thePathToFile])
	{
		NSURLSessionDownloadTask *theTask = [self.session downloadTaskWithURL:anURL
					completionHandler:^(NSURL *aLocation, NSURLResponse *aResponse, NSError *anError)
					{
						if (nil != anError)
						{
							#warning Handle error
						}
						
						NSFileManager *theManager = [NSFileManager defaultManager];
						NSError *theError = nil;
						
						if (![theManager fileExistsAtPath:[thePathToFile
									stringByDeletingLastPathComponent]])
						{
							if (![theManager createDirectoryAtPath:[thePathToFile
									stringByDeletingLastPathComponent]
									withIntermediateDirectories:NO
									attributes:nil error:&theError])
							{
								#warning Handle error
							}
						}
						
						theError = nil;
						if (![theManager copyItemAtURL:aLocation toURL:[NSURL
									fileURLWithPath:thePathToFile] error:&theError])
						{
							#warning Handle error
						}
					}];
		[theTask resume];
	}
	return thePathToFile;
}

#pragma mark Private methods
- (NSString *)pathToDownloadedFileAtURL:(NSURL *)anURL
{
	NSString *theDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
				NSUserDomainMask, YES) lastObject];
	NSString *thePath = [theDirectory stringByAppendingFormat:@"/%@/%ld.jpg",
				[[NSBundle mainBundle] bundleIdentifier], [anURL hash]];
	return thePath;
}

@end
