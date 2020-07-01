//
//  XcrunAltool.m
//  Packager
//
//  Created by Brian Buchholtz on 4/27/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "XcrunAltool.h"
#import "NotarizeResponse.h"
#import "Logger.h"

@implementation XcrunAltool {
    
}

+ (NSDictionary *)xcrunAltool:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectDevId:(NSString *)stringProjectDevId ProjectDevPassword:(NSString *)stringProjectDevPassword {
    
    // File name and path
    NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringFilePath, stringFileName];
    
    // xcrun parameters
    NSString *stringXcrunParam1 = @"altool";
    NSString *stringXcrunParam2 = @"--output-format";
    NSString *stringXcrunParam3 = @"xml";
    NSString *stringXcrunParam4 = @"--notarize-app";
    NSString *stringXcrunParam5 = @"-f";
    NSString *stringXcrunParam6 = stringPackageFile;
    NSString *stringXcrunParam7 = @"--primary-bundle-id";
    NSString *stringXcrunParam8 = stringProjectIdentifier;
    NSString *stringXcrunParam9 = @"-u";
    NSString *stringXcrunParam10 = stringProjectDevId;
    NSString *stringXcrunParam11 = @"-p";
    NSString *stringXcrunParam12 = stringProjectDevPassword;
    
    // Log
    NSLog (@"Xcrun Param1: %@", stringXcrunParam1);
    NSLog (@"Xcrun Param2: %@", stringXcrunParam2);
    NSLog (@"Xcrun Param3: %@", stringXcrunParam3);
    NSLog (@"Xcrun Param4: %@", stringXcrunParam4);
    NSLog (@"Xcrun Param5: %@", stringXcrunParam5);
    NSLog (@"Xcrun Param6: %@", stringXcrunParam6);
    NSLog (@"Xcrun Param7: %@", stringXcrunParam7);
    NSLog (@"Xcrun Param8: %@", stringXcrunParam8);
    NSLog (@"Xcrun Param9: %@", stringXcrunParam9);
    NSLog (@"Xcrun Param10: %@", stringXcrunParam10);
    NSLog (@"Xcrun Param11: %@", stringXcrunParam11);
    NSLog (@"Xcrun Param12: %@", stringXcrunParam12);
    
    // Launch xcrun
    int pidXcrun = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeXcrun = [NSPipe pipe];
    NSFileHandle *fileXcrun = pipeXcrun.fileHandleForReading;
    
    NSTask *taskXcrun = [[NSTask alloc] init];
    taskXcrun.launchPath = @"/usr/bin/xcrun";
    taskXcrun.arguments = @[stringXcrunParam1, stringXcrunParam2, stringXcrunParam3, stringXcrunParam4, stringXcrunParam5, stringXcrunParam6, stringXcrunParam7, stringXcrunParam8, stringXcrunParam9, stringXcrunParam10, stringXcrunParam11, stringXcrunParam12];
    taskXcrun.standardOutput = pipeXcrun;
    
    [taskXcrun launch];
    
    [Logger setLogEvent:@"xcrun PID: ", [NSString stringWithFormat:@"%d", pidXcrun], nil];
    
    NSData *dataXcrun = [fileXcrun readDataToEndOfFile];
    [fileXcrun closeFile];
    
    NSString *stringXcrun = [[NSString alloc] initWithData:dataXcrun encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"xcrun messages:\n", stringXcrun, nil];
    
    // Create notarize response class
    NotarizeResponse *notarizeResponse = [[NotarizeResponse alloc] init];
    NSDictionary *dictNotarizeResponse = [notarizeResponse readNotarizeResponse:dataXcrun];
    
    // Parse dictionary
    NSString *stringStatus = dictNotarizeResponse[@"Status"];
    NSString *stringResult = dictNotarizeResponse[@"Result"];
    
    // Xcrun Altool dictionary
    return @{@"Status":stringStatus,
             @"Result":stringResult};
    
}

@end
