//
//  Logger.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Logger.h"
#import "AppendFile.h"

@implementation Logger {
        
}

+ (void)setLogEvent:(id) first, ... {
    
    NSString *stringLogEvent = @"";
    id eachArg;
    va_list alist;
    
    if(first) {
        
        stringLogEvent = [stringLogEvent stringByAppendingString:first];
        va_start(alist, first);
        
        while ((eachArg = va_arg(alist, id))) {
            
            stringLogEvent = [stringLogEvent stringByAppendingString:eachArg];
        
        }
        
        va_end(alist);
    
    }
    
    // Output to console logger
    NSLog(@"%@", stringLogEvent);
    
    // Get log path
    NSString *stringLogPath;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        
        stringLogPath = [standardUserDefaults objectForKey:@"keyLogPath"];
        
    }
    
    // Write to log file
    [AppendFile appendToFile:stringLogPath LogEvent:stringLogEvent];
    
}

@end
