//
//  AppendFile.m
//  Packager
//
//  Created by Brian Buchholtz on 11/12/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppendFile.h"

@implementation AppendFile {
    
}

+ (void)appendToFile:(NSString *)stringEvent {
    
    // Log path and file
    NSURL *urlAppPath = [[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent];
    NSString *stringLogPath = urlAppPath.path;
    NSString *stringLogFile = [NSString stringWithFormat:@"%@/%@", stringLogPath, @"Packager.log"];
    
    // Get date and time
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *stringDate = [dateFormatter stringFromDate:date];
    NSString *stringData = [NSString stringWithFormat:@"[%@] %@\r\n", stringDate, stringEvent];
    
    NSData *dataString = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringLogFile ] == YES) {
        
        // Add the text at the end of the file
        NSLog (@"Writing to log file");
        
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:stringLogFile];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:dataString];
        [fileHandler closeFile];
        
    }
    
    else {
        
        // Create the file and write text to it
        NSLog (@"Creating new log file");
        
        [dataString writeToFile:stringLogFile atomically:YES];
        
    }
    
}

@end
