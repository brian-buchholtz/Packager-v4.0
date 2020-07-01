//
//  AppendFile.m
//  Packager
//
//  Created by Brian Buchholtz on 11/12/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "AppendFile.h"

@implementation AppendFile {
    
}

+ (void)appendToFile:(NSString *)stringLogPath LogEvent:(NSString *)stringLogEvent {
    
    NSString *stringLogFile;
    
    // Is log path defined
    if ([stringLogPath isEqualToString:@""]) {
     
        NSURL *urlAppPath = [[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent];
        stringLogFile = [NSString stringWithFormat:@"%@/%@", urlAppPath.path, @"Packager.log"];
        
    }
    
    else if ([stringLogPath isEqualToString:@"/"]) {
    
        stringLogFile = @"/Packager.log";
        
    }
    
    else {
        
        stringLogFile = [NSString stringWithFormat:@"%@/%@", stringLogPath, @"Packager.log"];
        
    }
    
    // Get date and time
    NSDate *dateCurrent = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *stringDate = [dateFormatter stringFromDate:dateCurrent];
    NSString *stringData = [NSString stringWithFormat:@"[%@] %@\n", stringDate, stringLogEvent];
    
    NSData *dataString = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringLogFile] == YES) {
        
        // Add the text at the end of the file
        NSLog (@"Writing to log file: %@", stringLogFile);
        
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:stringLogFile];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:dataString];
        [fileHandler closeFile];
        
    }
    
    else {
        
        // Create the file and write text to it
        NSLog (@"Creating new log file: %@", stringLogFile);
        
        [dataString writeToFile:stringLogFile atomically:YES];
        
    }
    
}

@end
