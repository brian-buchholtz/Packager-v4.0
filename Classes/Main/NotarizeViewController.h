//
//  NotarizeViewController.h
//  Packager
//
//  Created by Brian Buchholtz on 4/24/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

@import Cocoa;

@interface NotarizeViewController:NSObject {
    
    // Control outlets
    IBOutlet NSView *viewNotarizeOutlet;
    IBOutlet NSProgressIndicator *progressNotarizeOutlet;
    IBOutlet NSTextField *textboxFileOutlet;
    IBOutlet NSTextField *textboxSizeOutlet;
    IBOutlet NSTextField *textboxTimeOutlet;
    IBOutlet NSTextField *textboxStatusOutlet;
    
    // Variables
    NSAlert *alertNotarize;
    
    NSTimer *timerNotarize;
    
    int intSeconds;
    int intMinutes;
    int intHours;
    
    BOOL boolStartXcrunAltool;
    
    NSString *stringStatus;
    NSString *stringResult;
    
    NSString *stringViewFileName;
    NSString *stringViewFilePath;
    NSString *stringViewProjectIdentifier;
    NSString *stringViewProjectDevId;
    NSString *stringViewProjectDevPassword;
    
}

// Main functions
- (NSString *)viewNotarize:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectSize:(NSNumber *)numberProjectSize ProjectDevId:(NSString *)stringProjectDevId ProjectDevPassword:(NSString *)stringProjectDevPassword;
- (void)startXcrunAltool;
- (void)spawnXcrunAltool;

@end
