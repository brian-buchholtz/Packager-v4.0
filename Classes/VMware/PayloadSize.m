//
//  PayloadSize.m
//  Packager
//
//  Created by Brian Buchholtz on 1/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "PayloadSize.h"
#import "Logger.h"

@implementation PayloadSize {
    
}

+ (NSNumber *)getFolderSize:(NSArray *)arrayProjectManifest {
    
    // Initialize folder size
    unsigned long long int intFolderSize = 0;
    
    for (id idProjectManifest in arrayProjectManifest) {
        
        NSDictionary *dictProjectManifest = idProjectManifest;
        
        NSString *stringProjectSourcePath = dictProjectManifest[@"source_path"];
        
        NSLog(@"stringProjectSourcePath %@", stringProjectSourcePath);
        
        NSDictionary *dictProjectItem = [[NSFileManager defaultManager] attributesOfItemAtPath:stringProjectSourcePath error:nil];
        
        intFolderSize += [[dictProjectItem objectForKey:NSFileSize] intValue];
        
    }
    
    NSNumber *numberFolderSize = @(intFolderSize / 1024);
    NSString *stringFolderSize = [numberFolderSize stringValue];
    
    [Logger setLogEvent:@"Payload size: ", stringFolderSize, nil];
    
    return numberFolderSize;
    
}

@end
