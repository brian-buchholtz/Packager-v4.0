//
//  SignPackage.m
//  Packager
//
//  Created by Brian Buchholtz on 12/20/19.
//
//  Contributed by Paul Evans on 12/19/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SignPackage.h"
#import "Logger.h"

@implementation SignPackage {
    
}

+ (void)productSign:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectSign:(NSString *)stringProjectSign ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    // Package is signed state
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        if ([stringBuildType isEqualToString: @"pkg"]) {
            
            // productsign parameters
            NSString *stringSignParam1 = @"--sign";
            NSString *stringSignParam2 = stringProjectSign;
            NSString *stringSignParam3 = [NSString stringWithFormat:@"%@/%@-%@.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
            NSString *stringSignParam4 = [NSString stringWithFormat:@"%@/%@-%@_signed.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
            
            // Log
            NSLog (@"Productsign Param1:%@", stringSignParam1);
            NSLog (@"Productsign Param2:%@", stringSignParam2);
            NSLog (@"Productsign Param3:%@", stringSignParam3);
            NSLog (@"Productsign Param4:%@", stringSignParam4);
            
            // Launch productsign
            int pidProductsign = [[NSProcessInfo processInfo] processIdentifier];
            NSPipe *pipeProductsign = [NSPipe pipe];
            NSFileHandle *fileProductsign = pipeProductsign.fileHandleForReading;
            
            NSTask *taskProductsign = [[NSTask alloc] init];
            taskProductsign.launchPath = @"/usr/bin/productsign";
            taskProductsign.arguments = @[stringSignParam1, stringSignParam2, stringSignParam3, stringSignParam4];
            taskProductsign.standardOutput = pipeProductsign;
            
            [taskProductsign launch];
            
            NSData *dataProductsign = [fileProductsign readDataToEndOfFile];
            [fileProductsign closeFile];
            
            NSString *stringProductsign = [[NSString alloc] initWithData: dataProductsign encoding: NSUTF8StringEncoding];
            NSLog (@"productsign messages:\n%@", stringProductsign);
            
        }
        
        else if ([stringBuildType isEqualToString: @"dmg"]) {
            
            NSString *stringSourceDMG = [NSString stringWithFormat:@"%@/%@-%@.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
            NSString *stringTargetDMG = [NSString stringWithFormat:@"%@/%@-%@_signed.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
            
            // Copy DMG for signing
            if ([[NSFileManager defaultManager] isReadableFileAtPath:stringSourceDMG]) {
                
                NSURL *urlSourceDMG = [NSURL fileURLWithPath:stringSourceDMG];
                NSURL *urlTargetDMG = [NSURL fileURLWithPath:stringTargetDMG];

                [[NSFileManager defaultManager] copyItemAtURL:urlSourceDMG toURL:urlTargetDMG error:nil];
                
            }
            
            // codesign parameters
            NSString *stringSignParam1 = @"--force";
            NSString *stringSignParam2 = @"--sign";
            NSString *stringSignParam3 = stringProjectSign;
            NSString *stringSignParam4 = stringTargetDMG;
            
            // Log
            NSLog (@"Codesign Param1:%@", stringSignParam1);
            NSLog (@"Codesign Param2:%@", stringSignParam2);
            NSLog (@"Codesign Param3:%@", stringSignParam3);
            NSLog (@"Codesign Param4:%@", stringSignParam4);
            
            // Launch productsign
            int pidCodesign = [[NSProcessInfo processInfo] processIdentifier];
            NSPipe *pipeCodesign = [NSPipe pipe];
            NSFileHandle *fileCodesign = pipeCodesign.fileHandleForReading;
            
            NSTask *taskCodesign = [[NSTask alloc] init];
            taskCodesign.launchPath = @"/usr/bin/codesign";
            taskCodesign.arguments = @[stringSignParam1, stringSignParam2, stringSignParam3, stringSignParam4];
            taskCodesign.standardOutput = pipeCodesign;
            
            [taskCodesign launch];
            
            NSData *dataCodesign = [fileCodesign readDataToEndOfFile];
            [fileCodesign closeFile];
            
            NSString *stringCodesign = [[NSString alloc] initWithData: dataCodesign encoding: NSUTF8StringEncoding];
            NSLog (@"codesign messages:\n%@", stringCodesign);
            
        }
        
    }
    
}

@end
