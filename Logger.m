//
//  Logger.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Logger.h"
#import "AppendFile.h"

@implementation Logger {
        
}

- (NSString *)setLogFile {
    
    return 0;
    
}

+ (void)setLogEvent:(id) first, ... {
    
    NSString *stringResult = @"";
    id eachArg;
    va_list alist;
    
    if(first) {
        
        stringResult = [stringResult stringByAppendingString:first];
        va_start(alist, first);
        
        while ((eachArg = va_arg(alist, id))) {
            
            stringResult = [stringResult stringByAppendingString:eachArg];
        
        }
        
        va_end(alist);
    
    }
    
    // Output to console logger
    NSLog(@"%@", stringResult);
    
    // Write to log file    
    [AppendFile appendToFile:stringResult];
    
}

@end
