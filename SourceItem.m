//
//  SourceItem.m
//  Packager
//
//  Created by Brian Buchholtz on 1/16/20.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "SourceItem.h"
#import "Logger.h"

@implementation SourceItem {
    
}

- (NSArray *)getSourceItem:(NSString *)stringProjectSource {
    
    // ls parameters
    NSString *stringLsParam1 = @"-1";
    NSString *stringLsParam2 = stringProjectSource;
    
    // Log
    NSLog (@"Ls Param1:%@", stringLsParam1);
    NSLog (@"Ls Param2:%@", stringLsParam2);
    
    // Launch ls
    int pidLs = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeLs = [NSPipe pipe];
    NSFileHandle *fileLs = pipeLs.fileHandleForReading;
    
    NSTask *taskLs = [[NSTask alloc] init];
    taskLs.launchPath = @"/bin/ls";
    taskLs.arguments = @[stringLsParam1, stringLsParam2];
    taskLs.standardOutput = pipeLs;
    
    [taskLs launch];
    
    NSData *dataLs = [fileLs readDataToEndOfFile];
    [fileLs closeFile];
    
    NSString *stringLs = [[NSString alloc] initWithData: dataLs encoding: NSUTF8StringEncoding];
    NSLog (@"ls messages:\n%@", stringLs);
    
    NSArray *arrayLs = [stringLs componentsSeparatedByString: @"\n"];
    
    // Ignore last line
    arrayLs = [arrayLs subarrayWithRange:NSMakeRange(0, arrayLs.count - 1)];
    
    [Logger setLogEvent:@"Parsing source item: ", stringProjectSource, nil];
    
    return arrayLs;
    
}

@end
