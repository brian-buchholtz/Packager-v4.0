//
//  NotarizePackage.m
//  Packager
//
//  Created by Brian Buchholtz on 4/20/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "NotarizePackage.h"
#import "NotarizeViewController.h"
#import "Logger.h"

@implementation NotarizePackage {
    
}

+ (NSString *)notarizePackage:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectSize:(NSNumber *)numberProjectSize ProjectIsNotarized:(NSString *)stringProjectIsNotarized ProjectDevId:(NSString *)stringProjectDevId {
    
    NSString *stringRequestUuid;
    
    // Check to see if notarizing
    if ([stringProjectIsNotarized isEqualToString:@"TRUE"]) {
        
        NSString *stringProjectDevPassword;
        
        // Load custom alert for password
        NSAlert *alertPassword = [[NSAlert alloc] init];
        [alertPassword setMessageText:@"Enter Developer ID Password"];
        [alertPassword addButtonWithTitle:@"Ok"];
        [alertPassword addButtonWithTitle:@"Cancel"];
        
        NSSecureTextField *textboxPassword = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 296, 22)];
        
        [textboxPassword setStringValue:@""];
        
        [alertPassword setAccessoryView:textboxPassword];
        
        NSInteger intButton = [alertPassword runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            stringProjectDevPassword = [textboxPassword stringValue];
            
            // Load custom alert for notarize
            NotarizeViewController *notarizeViewController = [[NotarizeViewController alloc] init];
            
            stringRequestUuid = [notarizeViewController viewNotarize:stringFileName FilePath:stringFilePath ProjectIdentifier:stringProjectIdentifier ProjectSize:numberProjectSize ProjectDevId:stringProjectDevId ProjectDevPassword:stringProjectDevPassword];
            
            [Logger setLogEvent:@"Request UUID: ", stringRequestUuid, nil];
            
        }
        
        else if (intButton == NSAlertSecondButtonReturn) {
            
            // Do not notarize
            [Logger setLogEvent:@"Authentication: Cancelled - User initiated", nil];
            
            stringRequestUuid = @"";
            
        }
        
    }
    
    else {
        
        [Logger setLogEvent:@"Notarization: Disabled", nil];
        
        // Do not notarize
        stringRequestUuid = @"";
        
    }
    
    return stringRequestUuid;
     
}

@end
