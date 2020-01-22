//
//  ShaSum.m
//  Packager
//
//  Created by Brian Buchholtz on 12/19/19.
//
//  Contributed by Paul Evans on 9/16/19.
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

+ (NSString *)getShaSum:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    // shasum parameters
    NSString *stringShaParam1 = @"-a";
    NSString *stringShaParam2 = @"256";
    NSString *stringShaParam3;
    
    // Package is signed state
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        stringShaParam3 = [NSString stringWithFormat:@"%@/%@-%@_signed.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
        
    }
    
    else if ([stringProjectIsSigned isEqualToString: @"FALSE"]) {
        
        stringShaParam3 = [NSString stringWithFormat:@"%@/%@-%@.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
        
    }
    
    // Log
    NSLog (@"Shasum Param1:%@", stringShaParam1);
    NSLog (@"Shasum Param2:%@", stringShaParam2);
    NSLog (@"Shasum Param3:%@", stringShaParam3);
    
    // Launch shasum
    int pidShasum = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeShasum = [NSPipe pipe];
    NSFileHandle *fileShasum = pipeShasum.fileHandleForReading;
    
    NSTask *taskShasum = [[NSTask alloc] init];
    taskShasum.launchPath = @"/usr/bin/shasum";
    taskShasum.arguments = @[stringShaParam1, stringShaParam2, stringShaParam3];
    taskShasum.standardOutput = pipeShasum;
    
    [taskShasum launch];
    
    NSData *dataShasum = [fileShasum readDataToEndOfFile];
    [fileShasum closeFile];
    
    NSString *stringShasum = [[NSString alloc] initWithData: dataShasum encoding: NSUTF8StringEncoding];
    NSLog (@"shasum messages:\n%@", stringShasum);
    
    NSArray *arrayShasum = [stringShasum componentsSeparatedByString: @"  "];
    NSString *stringFileHash = [arrayShasum objectAtIndex:0];
    
    [Logger setLogEvent:@"shasum hash: ", stringFileHash, nil];
    
    return stringFileHash;
    
}

@end
