//
//  ExtractPackage.m
//  Packager
//
//  Created by Brian Buchholtz on 5/1/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ExtractPackage.h"
#import "Logger.h"

@implementation ExtractPackage {
    
}

+ (void)extractPackage:(NSString *)stringBuildType PackageSource:(NSString *)stringPackageSource PackageTarget:(NSString *)stringPackageTarget ExpandMode:(NSString *)stringExpandMode {
    
    if ([stringBuildType isEqualToString:@"pkg"]) {
        
        // Extact PKG
        NSString *stringPackageName = [[stringPackageSource lastPathComponent] stringByDeletingPathExtension];
        
        // pkgutil parameters
        NSString *stringPkgutilParam1;
        
        if ([stringExpandMode isEqualToString:@"NORMAL"]) {
         
            stringPkgutilParam1 = @"--expand";
            
        }
        
        else if ([stringExpandMode isEqualToString:@"FULL"]) {
            
            stringPkgutilParam1 = @"--expand-full";
            
        }
        
        NSString *stringPkgutilParam2 = stringPackageSource;
        NSString *stringPkgutilParam3 = [NSString stringWithFormat:@"%@/%@", stringPackageTarget, stringPackageName];
        
        // Log
        NSLog (@"Pkgutil Param1: %@", stringPkgutilParam1);
        NSLog (@"Pkgutil Param2: %@", stringPkgutilParam2);
        NSLog (@"Pkgutil Param3: %@", stringPkgutilParam3);
        
        // Launch pkgutil
        int pidPkgutil = [[NSProcessInfo processInfo] processIdentifier];
        NSPipe *pipePkgutil = [NSPipe pipe];
        NSFileHandle *filePkgutil = pipePkgutil.fileHandleForReading;
        
        NSTask *taskPkgutil = [[NSTask alloc] init];
        taskPkgutil.launchPath = @"/usr/sbin/pkgutil";
        taskPkgutil.arguments = @[stringPkgutilParam1, stringPkgutilParam2, stringPkgutilParam3];
        taskPkgutil.standardOutput = pipePkgutil;
        
        [taskPkgutil launch];
        
        [Logger setLogEvent:@"pkgutil PID: ", [NSString stringWithFormat:@"%d", pidPkgutil], nil];
        
        NSData *dataPkgutil = [filePkgutil readDataToEndOfFile];
        [filePkgutil closeFile];
        
        NSString *stringPkgutil = [[NSString alloc] initWithData:dataPkgutil encoding:NSUTF8StringEncoding];
        
        [Logger setLogEvent:@"pkgutil messages:\n", stringPkgutil, nil];
        
    }
    
    else if ([stringBuildType isEqualToString:@"dmg"]) {
        
        // hdiutil parameters
        NSString *stringHdiutilParam1 = @"attach";
        NSString *stringHdiutilParam2 = stringPackageSource;
        
        // Log
        NSLog (@"Hdiutil Param1: %@", stringHdiutilParam1);
        NSLog (@"Hdiutil Param2: %@", stringHdiutilParam2);
        
        // Launch hdiutil
        int pidHdiutil = [[NSProcessInfo processInfo] processIdentifier];
        NSPipe *pipeHdiutil = [NSPipe pipe];
        NSFileHandle *fileHdiutil = pipeHdiutil.fileHandleForReading;
        
        NSTask *taskHdiutil = [[NSTask alloc] init];
        taskHdiutil.launchPath = @"/usr/bin/hdiutil";
        taskHdiutil.arguments = @[stringHdiutilParam1, stringHdiutilParam2];
        taskHdiutil.standardOutput = pipeHdiutil;
        
        [taskHdiutil launch];
        
        [Logger setLogEvent:@"hdiutil PID: ", [NSString stringWithFormat:@"%d", pidHdiutil], nil];
        
        NSData *dataHdiutil = [fileHdiutil readDataToEndOfFile];
        [fileHdiutil closeFile];
        
        NSString *stringHdiutil = [[NSString alloc] initWithData:dataHdiutil encoding:NSUTF8StringEncoding];
        
        [Logger setLogEvent:@"hdiutil messages:\n", stringHdiutil, nil];
        
        NSString *stringPackageName;
        
        NSArray *arrayHdiutil1 = [stringHdiutil componentsSeparatedByString:@"\n"];
        
        for (NSString *stringArrayHdiutil1 in arrayHdiutil1) {
            
            if ([stringArrayHdiutil1 rangeOfString:@"/Volumes/"].location != NSNotFound) {
                
                //NSLog(@"Hdiutil 1: %@", stringArrayHdiutil1);
                
                NSArray *arrayHdiutil2 = [stringArrayHdiutil1 componentsSeparatedByString:@"/Volumes/"];
                stringPackageName = [arrayHdiutil2 objectAtIndex:1];
                
                //NSLog(@"Hdiutil 2: %@", stringArrayHdiutil2);
                
            }
            
        }
        
        // Create folder
        NSString *stringTargetPath = [NSString stringWithFormat:@"%@/%@", stringPackageTarget, stringPackageName];
        
        // Check for presence of target path
        NSFileManager *fileManager;
        fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:stringTargetPath] == NO) {
         
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:stringTargetPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error != nil) {
                
                [Logger setLogEvent:@"Error creating directory: ", error, nil];
                
            }
            
        }
        
        NSString *stringSourcePath = [NSString stringWithFormat:@"/Volumes/%@", stringPackageName];
        
        if ([stringExpandMode isEqualToString:@"NORMAL"]) {
            
            // Do not copy hidden items
            NSURL *urlSourcePath = [NSURL fileURLWithPath:stringSourcePath];
            
            NSArray *arraySourcePath = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:urlSourcePath
                                                                     includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                          error:nil];
            
            for (NSString *stringSourcePathItem in arraySourcePath) {
                
                NSString *stringNewSourcePathItem = [stringSourcePathItem lastPathComponent];
                NSString *stringSourceItem = [NSString stringWithFormat:@"%@/%@", stringSourcePath, stringNewSourcePathItem];
                NSString *stringTargetItem = [NSString stringWithFormat:@"%@/%@/%@", stringPackageTarget, stringPackageName, stringNewSourcePathItem];
                
                NSLog (@"Source item: %@", stringSourceItem);
                NSLog (@"Target item: %@", stringTargetItem);
                
                NSURL *urlSourceItem = [NSURL fileURLWithPath:stringSourceItem];
                NSURL *urlTargetItem = [NSURL fileURLWithPath:stringTargetItem];
                
                if ([[NSFileManager defaultManager] isReadableFileAtPath:stringSourceItem] ) {
                    
                    // Copy items from DMG
                    [[NSFileManager defaultManager] copyItemAtURL:urlSourceItem toURL:urlTargetItem error:nil];
                    
                    [Logger setLogEvent:@"Copying from: ", stringSourceItem, @" to: ", stringTargetItem, nil];
                    
                }
                
            }
            
        }
        
        else if ([stringExpandMode isEqualToString:@"FULL"]) {
            
            // Copy all items
            NSArray *arraySourcePath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringSourcePath error:nil];
            
            for (NSString *stringSourcePathItem in arraySourcePath) {
                
                NSString *stringSourceItem = [NSString stringWithFormat:@"%@/%@", stringSourcePath, stringSourcePathItem];
                NSString *stringTargetItem = [NSString stringWithFormat:@"%@/%@/%@", stringPackageTarget, stringPackageName, stringSourcePathItem];
                
                NSLog (@"Source item: %@", stringSourceItem);
                NSLog (@"Target item: %@", stringTargetItem);
                
                NSURL *urlSourceItem = [NSURL fileURLWithPath:stringSourceItem];
                NSURL *urlTargetItem = [NSURL fileURLWithPath:stringTargetItem];
                
                if ([[NSFileManager defaultManager] isReadableFileAtPath:stringSourceItem] ) {
                    
                    // Copy items from DMG
                    [[NSFileManager defaultManager] copyItemAtURL:urlSourceItem toURL:urlTargetItem error:nil];
                    
                    [Logger setLogEvent:@"Copying from: ", stringSourceItem, @" to: ", stringTargetItem, nil];
                    
                }
            
            }
        
        }
        
        // diskutil parameters
        NSString *stringDiskutilParam1 = @"unmount";
        NSString *stringDiskutilParam2 = stringSourcePath;
        
        // Log
        NSLog (@"Diskutil Param1: %@", stringDiskutilParam1);
        NSLog (@"Diskutil Param2: %@", stringDiskutilParam2);
        
        // Launch diskutil
        int pidDiskutil = [[NSProcessInfo processInfo] processIdentifier];
        NSPipe *pipeDiskutil = [NSPipe pipe];
        NSFileHandle *fileDiskutil = pipeDiskutil.fileHandleForReading;
        
        NSTask *taskDiskutil = [[NSTask alloc] init];
        taskDiskutil.launchPath = @"/usr/sbin/diskutil";
        taskDiskutil.arguments = @[stringDiskutilParam1, stringDiskutilParam2];
        taskDiskutil.standardOutput = pipeDiskutil;
        
        [taskDiskutil launch];
        
        [Logger setLogEvent:@"diskutil PID: ", [NSString stringWithFormat:@"%d", pidDiskutil], nil];
        
        NSData *dataDiskutil = [fileDiskutil readDataToEndOfFile];
        [fileDiskutil closeFile];
        
        NSString *stringDiskutil = [[NSString alloc] initWithData:dataDiskutil encoding:NSUTF8StringEncoding];
        
        [Logger setLogEvent:@"diskutil messages:\n", stringDiskutil, nil];
        
    }
    
}

@end
