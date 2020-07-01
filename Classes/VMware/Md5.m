//
//  Md5.m
//  Packager
//
//  Created by Brian Buchholtz on 6/30/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Md5.h"
#import "Logger.h"

@implementation Md5 {
    
}

+ (NSString *)getMd5:(NSString *)stringFileName FilePath:(NSString *)stringFilePath {
    
    // File name and path
    NSString *stringFile = [NSString stringWithFormat:@"%@/%@", stringFilePath, stringFileName];
    
    // md5 parameters
    NSString *stringMd5Param1 = @"-q";
    NSString *stringMd5Param2 = stringFile;
    
    // Log
    NSLog (@"Md5 Param1: %@", stringMd5Param1);
    NSLog (@"Md5 Param2: %@", stringMd5Param2);
    
    // Launch md5
    int pidMd5 = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeMd5 = [NSPipe pipe];
    NSFileHandle *fileMd5 = pipeMd5.fileHandleForReading;
    
    NSTask *taskMd5 = [[NSTask alloc] init];
    taskMd5.launchPath = @"/sbin/md5";
    taskMd5.arguments = @[stringMd5Param1, stringMd5Param2];
    taskMd5.standardOutput = pipeMd5;
    
    [taskMd5 launch];
    
    [Logger setLogEvent:@"md5 PID: ", [NSString stringWithFormat:@"%d", pidMd5], nil];
    
    NSData *dataMd5 = [fileMd5 readDataToEndOfFile];
    [fileMd5 closeFile];
    
    NSString *stringMd5 = [[NSString alloc] initWithData:dataMd5 encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"md5 messages:\n", stringMd5, nil];
    
    return stringMd5;
    
}

@end
