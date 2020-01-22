//
//  PayloadSize.m
//  Packager
//
//  Created by Brian Buchholtz on 1/15/20.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "PayloadSize.h"
#import "Logger.h"

@implementation PayloadSize {
    
}

+ (NSNumber *)getFolderSize:(NSString *)stringProjectSource {
    
    // du parameters
    NSString *stringDuParam1 = @"-s";
    NSString *stringDuParam2 = stringProjectSource;
    
    // Log
    NSLog (@"Du Param1:%@", stringDuParam1);
    NSLog (@"Du Param2:%@", stringDuParam2);
    
    // Launch du
    int pidDu = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeDu = [NSPipe pipe];
    NSFileHandle *fileDu = pipeDu.fileHandleForReading;
    
    NSTask *taskDu = [[NSTask alloc] init];
    taskDu.launchPath = @"/usr/bin/du";
    taskDu.arguments = @[stringDuParam1, stringDuParam2];
    taskDu.standardOutput = pipeDu;
    
    [taskDu launch];
    
    NSData *dataDu = [fileDu readDataToEndOfFile];
    [fileDu closeFile];
    
    NSString *stringDu = [[NSString alloc] initWithData: dataDu encoding: NSUTF8StringEncoding];
    NSLog (@"du messages:\n%@", stringDu);
    
    NSArray *arrayDu = [stringDu componentsSeparatedByString: @"	"];
    NSString *stringSectors = [arrayDu objectAtIndex:0];
    
    NSLog (@"Payload sector count: %@", stringSectors);
    
    // Convert string to integer
    int intSectors = [stringSectors intValue];
    
    // Convert sectors to bytes
    intSectors = intSectors * 512;
    
    // Convert to kilobytes
    NSNumber *numberFolderSize = @(intSectors / 1024);
    
    NSString *stringFolderSize = [numberFolderSize stringValue];
    [Logger setLogEvent:@"Payload size: ", stringFolderSize, nil];
    
    return numberFolderSize;
    
}

@end