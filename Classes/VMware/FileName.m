//
//  FileName.m
//  Packager
//
//  Created by Brian Buchholtz on 6/25/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FileName.h"
#import "Logger.h"

@implementation FileName {
    
}

+ (NSString *)setFileName:(NSString *)stringBuildType CurrentDate:(NSDate *)dateCurrent ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectType:(NSString *)stringProjectType ProjectIsPlist:(NSString *)stringProjectIsPlist ProjectIsSigned:(NSString *)stringProjectIsSigned VersionPackageName:(NSString *)stringVersionPackageName VersionPlistName:(NSString *)stringVersionPlistName DateTimePackageName:(NSString *)stringDateTimePackageName DateTimePlistName:(NSString *)stringDateTimePlistName PackageTypePlistName:(NSString *)stringPackageTypePlistName {
    
    // Project date/time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_hh-mm-ss"];
    NSString *stringProjectDateTime = [dateFormatter stringFromDate:dateCurrent];
    
    // Start building file name
    NSString *stringFileName = stringProjectName;
    
    // File is plist
    if ([stringProjectIsPlist isEqualToString:@"TRUE"]) {
        
        // Version in plist name
        if ([stringVersionPlistName isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_%@", stringFileName, stringProjectVersion];
            
        }
        
        // Date/Time in plist name
        if ([stringDateTimePlistName isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_%@", stringFileName, stringProjectDateTime];
            
        }
        
        // Package is signed state
        if ([stringProjectIsSigned isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_signed", stringFileName];
            
        }
        
        // Package type in plist name
        if ([stringPackageTypePlistName isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@.%@", stringFileName, stringBuildType];
            
        }
        
        // Finish building plist file name
        stringFileName = [NSString stringWithFormat:@"%@.plist", stringFileName];
        
    }
    
    // File is package
    else if ([stringProjectIsPlist isEqualToString:@"FALSE"]) {
        
        // Version in package name
        if ([stringVersionPackageName isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_%@", stringFileName, stringProjectVersion];
            
        }
        
        // Date/Time in package name
        if ([stringDateTimePackageName isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_%@", stringFileName, stringProjectDateTime];
            
        }
        
        // Package is signed state
        if ([stringProjectIsSigned isEqualToString:@"TRUE"]) {
            
            stringFileName = [NSString stringWithFormat:@"%@_signed", stringFileName];
            
        }
        
        // Finish building package file name
        stringFileName = [NSString stringWithFormat:@"%@.%@", stringFileName, stringBuildType];
        
    }
    
    return stringFileName;
    
}

@end
