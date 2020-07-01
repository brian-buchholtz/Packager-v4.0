//
//  UserGroup.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "UserGroup.h"
#import "DDFileReader.h"
#import "Logger.h"

@implementation UserGroup {
    
}

- (NSArray *)getUserGroup:(NSString *)stringUserGroup {
    
    NSString *stringFilePath;
    
    if ([stringUserGroup isEqualToString:@"user"]) {
        
        stringFilePath = @"/etc/passwd";
        
    }
    
    else if ([stringUserGroup isEqualToString:@"group"]) {
        
        stringFilePath = @"/etc/group";
        
    }
    
    NSMutableArray *arrayUserGroup = [[NSMutableArray alloc] init];
    DDFileReader *readerFilePath = [[DDFileReader alloc] initWithFilePath:stringFilePath];
    
    [readerFilePath enumerateLinesUsingBlock:^(NSString *stringLine, BOOL *boolStop) {
        
        unichar unicharFirst = [stringLine characterAtIndex:0];
        
        if (unicharFirst == '#') {
            
            // Ignore line
            
        }
        
        else {
            
            NSArray *arrayLine = [stringLine componentsSeparatedByString:@":"];
            NSString *stringObject = [arrayLine objectAtIndex:0];
            NSString *stringID = [arrayLine objectAtIndex:2];
            NSString *stringFormattedLine = [NSString stringWithFormat:@"%@ (%@)", stringObject, stringID];
            
            [arrayUserGroup addObject:stringFormattedLine];
            
        }
        
    }];
    
    [Logger setLogEvent:@"Parsing ", stringUserGroup, @"s", nil];
    
    return arrayUserGroup;
    
}

@end
