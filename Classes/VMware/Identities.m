//
//  Identities.m
//  Packager
//
//  Created by Brian Buchholtz on 1/16/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Identities.h"
#import "Logger.h"

@implementation Identities {
    
}

- (NSArray *)getIdentities {
    
    // security parameters
    NSString *stringSecurityParam1 = @"find-identity";
    NSString *stringSecurityParam2 = @"-v";
    
    // Launch security
    int pidSecurity = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeSecurity = [NSPipe pipe];
    NSFileHandle *fileSecurity = pipeSecurity.fileHandleForReading;
    
    NSTask *taskSecurity = [[NSTask alloc] init];
    taskSecurity.launchPath = @"/usr/bin/security";
    taskSecurity.arguments = @[stringSecurityParam1, stringSecurityParam2];
    taskSecurity.standardOutput = pipeSecurity;
    
    [taskSecurity launch];
    
    [Logger setLogEvent:@"security PID: ", [NSString stringWithFormat:@"%d", pidSecurity], nil];
    
    NSData *dataSecurity = [fileSecurity readDataToEndOfFile];
    [fileSecurity closeFile];
    
    NSString *stringSecurity = [[NSString alloc] initWithData:dataSecurity encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"security messages:\n", stringSecurity, nil];
    
    NSMutableArray *arraySecurity = [[NSMutableArray alloc] init];
    NSArray *arraySecurity1 = [stringSecurity componentsSeparatedByString:@"\n"];
    
    for (NSString *stringArraySecurity1 in arraySecurity1) {
        
        if ([stringArraySecurity1 rangeOfString:@")"].location == NSNotFound) {
            
            NSLog(@"Identity not found in item");
            
        }
        
        else {
            
            //NSLog(@"Identity 1: %@", stringArraySecurity1);
            
            NSArray *arraySecurity2 = [stringArraySecurity1 componentsSeparatedByString:@") "];
            NSString *stringArraySecurity2 = [arraySecurity2 objectAtIndex:1];
            
            //NSLog(@"Identity 2: %@", stringArraySecurity2);
            
            NSArray *arraySecurity3 = [stringArraySecurity2 componentsSeparatedByString:@"\""];
            NSString *stringArraySecurity3 = [arraySecurity3 objectAtIndex:1];
            
            //NSLog(@"Identity 3: %@", stringArraySecurity3);
            
            [arraySecurity addObject:stringArraySecurity3];
            
        }
        
    }
    
    [Logger setLogEvent:@"Parsing identities", nil];
    
    return arraySecurity;
    
}

@end
