//
//  ValidateXcode.m
//  Packager
//
//  Created by Brian Buchholtz on 4/25/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ValidateXcode.h"
#import "Logger.h"

@implementation ValidateXcode {
    
}

+ (BOOL)validateXcrun {
    
    // Check for presence of xcrun
    NSString *stringLaunchPath = @"/usr/bin/xcrun";
    
    // Check for presence of settings file
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    BOOL boolValidateXcrun;
    
    if ([fileManager fileExistsAtPath:stringLaunchPath] == YES) {
        
        NSLog (@"xcrun found");
        
        // Xcrun parameters
        NSString *stringXcrunParam1 = @"--version";
        
        // Log
        NSLog (@"Xcrun Param1: %@", stringXcrunParam1);
        
        // Launch xcrun
        int pidXcrun = [[NSProcessInfo processInfo] processIdentifier];
        NSPipe *pipeXcrun = [NSPipe pipe];
        NSFileHandle *fileXcrun = pipeXcrun.fileHandleForReading;
        
        NSTask *taskXcrun = [[NSTask alloc] init];
        taskXcrun.launchPath = stringLaunchPath;
        taskXcrun.arguments = @[stringXcrunParam1];
        taskXcrun.standardOutput = pipeXcrun;
        
        [taskXcrun launch];
        
        [Logger setLogEvent:@"xcrun PID: ", [NSString stringWithFormat:@"%d", pidXcrun], nil];
        
        NSData *dataXcrun = [fileXcrun readDataToEndOfFile];
        [fileXcrun closeFile];
        
        NSString *stringXcrun = [[NSString alloc] initWithData:dataXcrun encoding:NSUTF8StringEncoding];
        
        [Logger setLogEvent:@"xcrun messages:\n", @"X", stringXcrun, @"X", nil];
        
        NSArray *arrayXcrunVersion = [stringXcrun componentsSeparatedByString:@" "];
        
        NSString *stringXcrunVersion1 = [arrayXcrunVersion objectAtIndex:0];
        NSString *stringXcrunVersion2 = [arrayXcrunVersion objectAtIndex:1];
        NSString *stringXcrunVersion3 = [arrayXcrunVersion objectAtIndex:2];
        
        NSLog (@"xcrun1 found: %@", stringXcrunVersion1);
        NSLog (@"xcrun2 found: %@", stringXcrunVersion2);
        NSLog (@"xcrun3 found: %@", stringXcrunVersion3);
        
        NSArray *arrayXcrunVersion3 = [stringXcrunVersion3 componentsSeparatedByString:@"."];
        
        NSString *stringXcrunVersion4 = [arrayXcrunVersion3 objectAtIndex:0];
        
        int intXcrunVersion = [stringXcrunVersion4 integerValue];
        
        [Logger setLogEvent:@"xcrun version ", [NSString stringWithFormat:@"%d", intXcrunVersion], @" found", nil];
        
        // Check for presence of Xcode 7.3.1 or greater
        if (intXcrunVersion >= 29) {
            
            [Logger setLogEvent:@"Suitable xcrun found", nil];
            
            boolValidateXcrun = YES;
            
        }
        
        else {
            
            [Logger setLogEvent:@"Suitable xcrun not found - Please upgrade Xcode to version 7.3.1 or greater", nil];
            
            // Load alert
            NSAlert *alertValidate = [[NSAlert alloc] init];
            
            [alertValidate setMessageText:@"Insufficient Xcode Version!"];
            [alertValidate setInformativeText:@"Please upgrade Xcode to 7.3.1 or greater"];
            [alertValidate setAlertStyle:NSCriticalAlertStyle];
            [alertValidate addButtonWithTitle:@"Ok"];
            
            NSInteger intButton = [alertValidate runModal];
            
            if (intButton == NSAlertFirstButtonReturn) {
                
                
                
            }
            
            
            boolValidateXcrun = NO;
            
        }
        
    }
    
    else {
        
        [Logger setLogEvent:@"Suitable xcrun not found - Please install Xcode version 7.3.1 or greater", nil];
        
        // Load alert
        NSAlert *alertValidate = [[NSAlert alloc] init];
        
        [alertValidate setMessageText:@"Xcode Not Found!"];
        [alertValidate setInformativeText:@"Please install Xcode 7.3.1 or greater"];
        [alertValidate setAlertStyle:NSCriticalAlertStyle];
        [alertValidate addButtonWithTitle:@"Ok"];
        
        NSInteger intButton = [alertValidate runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            
            
        }
        
        boolValidateXcrun = NO;
        
    }
    
    return boolValidateXcrun;
    
}

+ (BOOL)validateAltool {
    
    BOOL boolvalidateAltool;
    
    // Xcrun parameters
    NSString *stringXcrunParam1 = @"altool";
    NSString *stringXcrunParam2 = @"--version";
    
    // Log
    NSLog (@"Xcrun Param1: %@", stringXcrunParam1);
    NSLog (@"Xcrun Param2: %@", stringXcrunParam2);
    
    // Launch xcrun
    int pidXcrun = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeXcrun = [NSPipe pipe];
    NSFileHandle *fileXcrun = pipeXcrun.fileHandleForReading;
    
    NSTask *taskXcrun = [[NSTask alloc] init];
    taskXcrun.launchPath = @"/usr/bin/xcrun";
    taskXcrun.arguments = @[stringXcrunParam1, stringXcrunParam2];
    taskXcrun.standardOutput = pipeXcrun;
    
    [taskXcrun launch];
    
    [Logger setLogEvent:@"xcrun PID: ", [NSString stringWithFormat:@"%d", pidXcrun], nil];
    
    NSData *dataXcrun = [fileXcrun readDataToEndOfFile];
    [fileXcrun closeFile];
    
    NSString *stringXcrun = [[NSString alloc] initWithData:dataXcrun encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"xcrun messages:\n", @"X", stringXcrun, @"X", nil];
    
    NSString *stringNotFound = @"xcrun: error: unable to find utility";
    
    if ([stringXcrun rangeOfString:stringNotFound].location != NSNotFound) {
        
        [Logger setLogEvent:@"altool not found - Please install command line tools", nil];
        
        // Load alert
        NSAlert *alertValidate = [[NSAlert alloc] init];
        
        [alertValidate setMessageText:@"atool Not Found!"];
        [alertValidate setInformativeText:@"Please install command line tools"];
        [alertValidate setAlertStyle:NSCriticalAlertStyle];
        [alertValidate addButtonWithTitle:@"Ok"];
        
        NSInteger intButton = [alertValidate runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            
            
        }
        
        boolvalidateAltool = NO;
        
    }
    
    else {
        
        [Logger setLogEvent:@"altool found", nil];
        
        boolvalidateAltool = YES;
        
    }
    
    return boolvalidateAltool;
    
}

@end
