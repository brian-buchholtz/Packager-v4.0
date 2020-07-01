//
//  FileSize.m
//  Packager
//
//  Created by Brian Buchholtz on 12/20/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FileSize.h"
#import "Logger.h"

@implementation FileSize {
    
}

+ (NSNumber *)getFileSize:(NSString *)stringFileName FilePath:(NSString *)stringFilePath {
    
    // File name and path
    NSString *stringFile = [NSString stringWithFormat:@"%@/%@", stringFilePath, stringFileName];
    
    // Get file size
    unsigned long long longFileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:stringFile error:nil] fileSize];
    NSNumber *numberFileSize = @(longFileSize / 1024);
    
    NSString *stringFileSize = [numberFileSize stringValue];
    [Logger setLogEvent:stringFileName, @" size: ", stringFileSize, nil];
    
    return numberFileSize;

}

@end
