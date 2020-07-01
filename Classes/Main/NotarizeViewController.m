//
//  NotarizeViewController.m
//  Packager
//
//  Created by Brian Buchholtz on 4/24/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "NotarizeViewController.h"
#import "XcrunAltool.h"
#import "Logger.h"

@implementation NotarizeViewController


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controls



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions

- (NSString *)viewNotarize:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectSize:(NSNumber *)numberProjectSize ProjectDevId:(NSString *)stringProjectDevId ProjectDevPassword:(NSString *)stringProjectDevPassword {
    
    boolStartXcrunAltool = YES;
    
    // Load custom alert
    alertNotarize = [[NSAlert alloc] init];
    
    [NSBundle.mainBundle loadNibNamed:@"NotarizeView" owner:self topLevelObjects:nil];
    
    // File and path
    NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringFilePath, stringFileName];
    
    // Concatenate package size
    NSString *stringPackageSize = [NSString stringWithFormat:@"%@%@", numberProjectSize.stringValue, @" KiB"];
    
    // Set controls
    [textboxFileOutlet setStringValue:stringPackageFile];
    [textboxSizeOutlet setStringValue:stringPackageSize];
    
    alertNotarize.accessoryView = viewNotarizeOutlet;
    [alertNotarize setMessageText:@"Notarize"];
    [alertNotarize addButtonWithTitle:@"Abort"];
    
    // Initialize time status
    intSeconds = 0;
    intMinutes = 0;
    intHours = 0;
    
    // Initialize status
    stringStatus = @"Uploading";
    
    timerNotarize = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timerNotarize forMode:NSModalPanelRunLoopMode];
    
    // Need better way to wait for view to load
    stringViewFileName = stringFileName;
    stringViewFilePath = stringFilePath;
    stringViewProjectIdentifier = stringProjectIdentifier;
    stringViewProjectDevId = stringProjectDevId;
    stringViewProjectDevPassword = stringProjectDevPassword;
    
    NSInteger intButton = [alertNotarize runModal];
    
    if (intButton == NSAlertFirstButtonReturn) {
        
    }
    
    NSString *stringNotarizeResult = @"";
    
    if ([stringStatus isEqualToString:@"Success"]) {
     
        stringNotarizeResult = stringResult;
        
    }
    
    return stringNotarizeResult;
    
}

- (void)updateTime:(NSTimer *)timerUpdateTime {
    
    if (boolStartXcrunAltool) {
        
        boolStartXcrunAltool = NO;
        
        [self spawnXcrunAltool];
        
    }
    
    if (intSeconds == 59) {
        
        intMinutes += 1 ;
        intSeconds = 0;
        
        stringStatus = [NSString stringWithFormat:@"%@%@", stringStatus, @"."];
        
        if (intMinutes == 59) {
            
            intHours += 1 ;
            intMinutes = 0;
            
        }
        
    }
    
    else if (intSeconds < 59) {
        
        intSeconds += 1;
        
    }
    
    NSString *stringTimeStatus = [NSString stringWithFormat:@"%02d%@%02d%@%02d", intHours, @":", intMinutes, @":", intSeconds];
    
    id sender = self;
    
    [progressNotarizeOutlet startAnimation:sender];
    [textboxTimeOutlet setStringValue:stringTimeStatus];
    [textboxStatusOutlet setStringValue:stringStatus];
    
    if (stringResult.length) {
        
        [self stopTime];
        
        // Load alert
        NSAlert *alertStatus = [[NSAlert alloc] init];
        
        [alertStatus setMessageText:[NSString stringWithFormat:@"Notarize %@!", stringStatus]];
        [alertStatus setInformativeText:[NSString stringWithFormat:@"Result: %@", stringResult]];
        [alertStatus setAlertStyle:NSCriticalAlertStyle];
        [alertStatus addButtonWithTitle:@"Ok"];
        
        NSInteger intButton = [alertStatus runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            
            
        }
        
        // Automatically close alert
        NSArray *arrayButton = [alertNotarize buttons];
        NSButton *buttonAlert = [arrayButton objectAtIndex:0];
        [buttonAlert performClick:alertNotarize];
        
    }
    
}

- (void)stopTime {
    
    [timerNotarize invalidate];
    timerNotarize = nil;
    
}

- (void)startXcrunAltool {
    
    // XcrunAltool
    NSDictionary *dictXcrunAltool = [XcrunAltool xcrunAltool:stringViewFileName FilePath:stringViewFilePath ProjectIdentifier:stringViewProjectIdentifier ProjectDevId:stringViewProjectDevId ProjectDevPassword:stringViewProjectDevPassword];
    
    // Parse dictionary
    stringStatus = dictXcrunAltool[@"Status"];
    stringResult = dictXcrunAltool[@"Result"];
    
}

- (void)spawnXcrunAltool {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        
        // Lauch xcrun in the background
        [self startXcrunAltool];
        
    });
    
}

@end
