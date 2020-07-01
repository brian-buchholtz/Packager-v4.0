//
//  ShaSum.m
//  Packager
//
//  Created by Brian Buchholtz on 12/19/2019.
//
//  Contributed by Paul Evans on 9/16/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ShaSum.h"
#import "Logger.h"

@implementation ShaSum {
    
}

+ (NSString *)getShaSum:(NSString *)stringFileName FilePath:(NSString *)stringFilePath {
    
    // File name and path
    NSString *stringFile = [NSString stringWithFormat:@"%@/%@", stringFilePath, stringFileName];
    
    // shasum parameters
    NSString *stringShasumParam1 = @"-a";
    NSString *stringShasumParam2 = @"256";
    NSString *stringShasumParam3 = stringFile;
    
    // Log
    NSLog (@"Shasum Param1: %@", stringShasumParam1);
    NSLog (@"Shasum Param2: %@", stringShasumParam2);
    NSLog (@"Shasum Param3: %@", stringShasumParam3);
    
    // Launch shasum
    int pidShasum = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeShasum = [NSPipe pipe];
    NSFileHandle *fileShasum = pipeShasum.fileHandleForReading;
    
    NSTask *taskShasum = [[NSTask alloc] init];
    taskShasum.launchPath = @"/usr/bin/shasum";
    taskShasum.arguments = @[stringShasumParam1, stringShasumParam2, stringShasumParam3];
    taskShasum.standardOutput = pipeShasum;
    
    [taskShasum launch];
    
    [Logger setLogEvent:@"shasum PID: ", [NSString stringWithFormat:@"%d", pidShasum], nil];
    
    NSData *dataShasum = [fileShasum readDataToEndOfFile];
    [fileShasum closeFile];
    
    NSString *stringShasum = [[NSString alloc] initWithData:dataShasum encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"shasum messages:\n", stringShasum, nil];
    
    NSArray *arrayShasum = [stringShasum componentsSeparatedByString:@"  "];
    NSString *stringFileHash = [arrayShasum objectAtIndex:0];
    
    [Logger setLogEvent:@"shasum hash: ", stringFileHash, nil];
    
    return stringFileHash;
    
}

@end
