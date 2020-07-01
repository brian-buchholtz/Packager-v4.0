//
//  NotarizeResponse.m
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "NotarizeResponse.h"
#import "PlistWrapper.h"
#import "Logger.h"

@implementation NotarizeResponse {
    
}

- (NSDictionary *)readNotarizeResponse:(NSData *)dataNotarizeResponse {
    
    // Convert data to dictionary
    NSDictionary *dictPlist = [PlistWrapper plistToObjectFromData:dataNotarizeResponse];
    
    NSString *stringMessage;
    NSString *stringResult;
    NSString *stringStatus;
    
    if (dictPlist[@"product-errors"]) {
        
        NSArray *arrayError = dictPlist[@"product-errors"];
        NSDictionary *dictMessage = arrayError[0];
        stringMessage = dictMessage[@"message"];
        
        stringStatus = @"Failure";
        
        [Logger setLogEvent:@"Notarization error: ", stringMessage, nil];
        
        if ([stringMessage rangeOfString:@"The archive is invalid"].location != NSNotFound) {
         
            stringResult = @"bad package";
            
        }
        
        else if ([stringMessage rangeOfString:@"is not a member of the provider"].location != NSNotFound) {
            
            stringResult = @"bad user";
            
        }
        
        else if ([stringMessage rangeOfString:@"Your account information was entered incorrectly"].location != NSNotFound) {
            
            stringResult = @"bad user";
            
        }
        
        else if ([stringMessage rangeOfString:@"Sign in with the app-specific password you generated"].location != NSNotFound) {
            
            stringResult = @"bad password";
            
        }
        
        else {
            
            stringResult = @"unexpected";
            
        }
        
    }
    
    else if (dictPlist[@"notarization-upload"]) {
        
        stringStatus = @"Success";
        
        NSDictionary *dictSuccess = dictPlist[@"notarization-upload"];
        stringResult = dictSuccess[@"RequestUUID"];
        
        [Logger setLogEvent:@"Request UUID: ", stringResult, nil];
        
    }
    
    else {
        
        stringStatus = @"Failure";
        stringResult = @"unexpected";
        
        [Logger setLogEvent:@"Unexpected notarization error", nil];
        
    }
    
    // Notarize response dictionary
    return @{@"Status":stringStatus,
             @"Result":stringResult};
    
}

@end
