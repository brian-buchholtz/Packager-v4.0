//
//  SignPackage.m
//  Packager
//
//  Created by Brian Buchholtz on 12/20/2019.
//
//  Contributed by Paul Evans on 12/19/2019.
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

+ (void)productSign:(NSString *)stringSignedPackageFileName PackageFileName:(NSString *)stringPackageFileName BuildType:(NSString *)stringBuildType ProjectTarget:(NSString *)stringProjectTarget ProjectDevCert:(NSString *)stringProjectDevCert ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    // Package is signed state
    if ([stringProjectIsSigned isEqualToString:@"TRUE"]) {
        
        // Package file name
        NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringPackageFileName];
        
        // Signed package file name
        NSString *stringSignedPackageFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringSignedPackageFileName];
        
        // Sign pkg
        if ([stringBuildType isEqualToString:@"pkg"]) {
            
            // productsign parameters
            NSString *stringSignParam1 = @"--sign";
            NSString *stringSignParam2 = stringProjectDevCert;
            NSString *stringSignParam3 = stringPackageFile;
            NSString *stringSignParam4 = stringSignedPackageFile;
            
            // Log
            NSLog (@"Productsign Param1: %@", stringSignParam1);
            NSLog (@"Productsign Param2: %@", stringSignParam2);
            NSLog (@"Productsign Param3: %@", stringSignParam3);
            NSLog (@"Productsign Param4: %@", stringSignParam4);
            
            // Launch productsign
            int pidProductsign = [[NSProcessInfo processInfo] processIdentifier];
            NSPipe *pipeProductsign = [NSPipe pipe];
            NSFileHandle *fileProductsign = pipeProductsign.fileHandleForReading;
            
            NSTask *taskProductsign = [[NSTask alloc] init];
            taskProductsign.launchPath = @"/usr/bin/productsign";
            taskProductsign.arguments = @[stringSignParam1, stringSignParam2, stringSignParam3, stringSignParam4];
            taskProductsign.standardOutput = pipeProductsign;
            
            [taskProductsign launch];
            
            [Logger setLogEvent:@"productsign PID: ", [NSString stringWithFormat:@"%d", pidProductsign], nil];
            
            NSData *dataProductsign = [fileProductsign readDataToEndOfFile];
            [fileProductsign closeFile];
            
            NSString *stringProductsign = [[NSString alloc] initWithData:dataProductsign encoding:NSUTF8StringEncoding];
            
            [Logger setLogEvent:@"productsign messages:\n", stringProductsign, nil];
            
        }
        
        // Sign dmg
        else if ([stringBuildType isEqualToString:@"dmg"]) {
            
            NSString *stringSourceDMG = stringPackageFile;
            NSString *stringTargetDMG = stringSignedPackageFile;
            
            // Copy DMG for signing
            if ([[NSFileManager defaultManager] isReadableFileAtPath:stringSourceDMG]) {
                
                NSURL *urlSourceDMG = [NSURL fileURLWithPath:stringSourceDMG];
                NSURL *urlTargetDMG = [NSURL fileURLWithPath:stringTargetDMG];

                [[NSFileManager defaultManager] copyItemAtURL:urlSourceDMG toURL:urlTargetDMG error:nil];
                
            }
            
            // codesign parameters
            NSString *stringSignParam1 = @"--force";
            NSString *stringSignParam2 = @"--sign";
            NSString *stringSignParam3 = stringProjectDevCert;
            NSString *stringSignParam4 = stringTargetDMG;
            
            // Log
            NSLog (@"Codesign Param1: %@", stringSignParam1);
            NSLog (@"Codesign Param2: %@", stringSignParam2);
            NSLog (@"Codesign Param3: %@", stringSignParam3);
            NSLog (@"Codesign Param4: %@", stringSignParam4);
            
            // Launch codesign
            int pidCodesign = [[NSProcessInfo processInfo] processIdentifier];
            NSPipe *pipeCodesign = [NSPipe pipe];
            NSFileHandle *fileCodesign = pipeCodesign.fileHandleForReading;
            
            NSTask *taskCodesign = [[NSTask alloc] init];
            taskCodesign.launchPath = @"/usr/bin/codesign";
            taskCodesign.arguments = @[stringSignParam1, stringSignParam2, stringSignParam3, stringSignParam4];
            taskCodesign.standardOutput = pipeCodesign;
            
            [taskCodesign launch];
            
            [Logger setLogEvent:@"codesign PID: ", [NSString stringWithFormat:@"%d", pidCodesign], nil];
            
            NSData *dataCodesign = [fileCodesign readDataToEndOfFile];
            [fileCodesign closeFile];
            
            NSString *stringCodesign = [[NSString alloc] initWithData:dataCodesign encoding:NSUTF8StringEncoding];
            
            [Logger setLogEvent:@"codesign messages:\n", stringCodesign, nil];
            
        }
        
    }
    
}

@end
