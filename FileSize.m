//
//  FileSize.m
//  Packager
//
//  Created by Brian Buchholtz on 12/20/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FileSize.h"
#import "Logger.h"

@implementation FileSize {
    
}

+ (NSNumber *)getFileSize:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    NSString *stringPackageFile;
    
    // Package is signed state
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        stringPackageFile = [NSString stringWithFormat:@"%@/%@-%@_signed.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
        
    }
    
    else if ([stringProjectIsSigned isEqualToString: @"FALSE"]) {
        
        stringPackageFile = [NSString stringWithFormat:@"%@/%@-%@.%@", stringProjectTarget, stringProjectName, stringProjectVersion, stringBuildType];
        
    }
    
    // Get package file size
    unsigned long long longPackageSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:stringPackageFile error:nil] fileSize];
    NSNumber *numberPackageSize = @(longPackageSize / 1024);
    
    NSString *stringPackageSize = [numberPackageSize stringValue];
    [Logger setLogEvent:@"Package file size: ", stringPackageSize, nil];
    
    return numberPackageSize;

}

@end
