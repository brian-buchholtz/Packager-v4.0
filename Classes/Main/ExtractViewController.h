//
//  ExtractViewController.h
//  Packager
//
//  Created by Brian Buchholtz on 5/1/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

@import Cocoa;

@interface ExtractViewController:NSObject {
    
    // Control outlets
    IBOutlet NSView *viewExtractOutlet;
    IBOutlet NSTextField *textboxPackageOutlet;
    IBOutlet NSTextField *textboxExtractToOutlet;
    IBOutlet NSButton *radioExpandNormalOutlet;
    IBOutlet NSButton *radioExpandFullOutlet;
    
    // Variables
    NSString *stringViewBuildType;
    NSString *stringViewProjectSource;
    
    NSString *stringPackageSource;
    NSString *stringPackageTarget;
    NSString *stringExpandMode;
    
}

// Control actions
- (IBAction)buttonBrowsePackageAction:(NSButton *)sender;
- (IBAction)buttonBrowseExtractToAction:(NSButton *)sender;
- (IBAction)radioGroupExpandAction:(NSButton *)sender;


// Main functions
- (NSDictionary *)viewExtract:(NSString *)stringBuildType ProjectSource:(NSString *)stringProjectSource;
- (void)browsePackage;
- (void)browseExtractTo;

@end
