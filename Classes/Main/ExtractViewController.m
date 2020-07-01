//
//  ExtractViewController.m
//  Packager
//
//  Created by Brian Buchholtz on 5/1/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ExtractViewController.h"
#import "FilePicker.h"
#import "BrowsePath.h"
#import "Logger.h"

@implementation ExtractViewController


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controls

- (IBAction)buttonBrowsePackageAction:(NSButton *)sender {
    
    // Browse package file
    [self browsePackage];
    
}

- (IBAction)buttonBrowseExtractToAction:(NSButton *)sender {
    
    // Browse extract to path
    [self browseExtractTo];
    
}

- (IBAction)radioGroupExpandAction:(NSButton *)sender {
    
    // Group radio expand controls
    if ([radioExpandNormalOutlet state] == NSOnState) {
        
        stringExpandMode = @"NORMAL";
        
    }
    
    else if ([radioExpandFullOutlet state] == NSOnState) {
        
        stringExpandMode = @"FULL";
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions

- (NSDictionary *)viewExtract:(NSString *)stringBuildType ProjectSource:(NSString *)stringProjectSource {
    
    // Set view variables
    stringViewBuildType = stringBuildType;
    stringViewProjectSource = stringProjectSource;
    
    // Initialize variables
    stringPackageSource = @"";
    stringPackageTarget = @"";
    stringExpandMode = @"";
    
    // Load custom alert
    NSAlert *alertExtract = [[NSAlert alloc] init];
    
    [NSBundle.mainBundle loadNibNamed:@"ExtractView" owner:self topLevelObjects:nil];
    
    // Set controls
    [textboxExtractToOutlet setStringValue:stringViewProjectSource];
    [radioExpandNormalOutlet setState:NSOnState];
    
    alertExtract.accessoryView = viewExtractOutlet;
    [alertExtract setMessageText:@"Extract Package"];
    [alertExtract addButtonWithTitle:@"Extract"];
    [alertExtract addButtonWithTitle:@"Cancel"];
    
    NSInteger intButton = [alertExtract runModal];
    
    if (intButton == NSAlertFirstButtonReturn) {
        
        stringPackageSource = [textboxPackageOutlet stringValue];
        stringPackageTarget = [textboxExtractToOutlet stringValue];
        
        if ([radioExpandNormalOutlet state] == NSOnState) {
            
            stringExpandMode = @"NORMAL";
            
        }
        
        else if ([radioExpandFullOutlet state] == NSOnState) {
            
            stringExpandMode = @"FULL";
            
        }
        
        [Logger setLogEvent:@"Extract package: Successful", nil];
        
    }
    
    else if (intButton == NSAlertSecondButtonReturn) {
        
        [Logger setLogEvent:@"Extract package: Cancelled - User initiated", nil];
        
    }
    
    return @{@"PackageSource":stringPackageSource,
             @"PackageTarget":stringPackageTarget,
             @"ExpandMode":stringExpandMode};
    
}

- (void)browsePackage {
    
    // Determine package type
    if ([stringViewBuildType isEqualToString:@"pkg"]) {
        
        // Set array of file types
        NSArray<NSString *> *arrayFileTypes = @[@"pkg", @"Pkg", @"PKG"];
        
        // Browse for existing project file
        FilePicker *pickFile = [[FilePicker alloc] init];
        stringPackageSource = [pickFile getFile:arrayFileTypes];
    
    }
    
    else if ([stringViewBuildType isEqualToString:@"dmg"]) {
        
        // Set array of file types
        NSArray<NSString *> *arrayFileTypes = @[@"dmg", @"Dmg", @"DMG"];
        
        // Browse for existing project file
        FilePicker *pickFile = [[FilePicker alloc] init];
        stringPackageSource = [pickFile getFile:arrayFileTypes];
        
    }
    
    // Handle package source browse cancel
    if (stringPackageSource) {
        
        [textboxPackageOutlet setStringValue:stringPackageSource];
        [Logger setLogEvent:@"Package source: ", stringPackageSource, nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Package source selection aborted", nil];
        
    }
    
}

- (void)browseExtractTo {
    
    // Browse for extract path
    BrowsePath *packageTarget = [[BrowsePath alloc] init];
    stringPackageTarget = [packageTarget getPath:stringViewProjectSource];
    
    // Handle package extract target browse cancel
    if (stringPackageTarget) {
        
        [textboxExtractToOutlet setStringValue:stringPackageTarget];
        [Logger setLogEvent:@"Package target: ", stringPackageTarget, nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Package target selection aborted", nil];
        
    }
    
}

@end
