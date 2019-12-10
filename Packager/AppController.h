//
//  AppController.h
//  Packager
//
//  Created by Brian Buchholtz on 11/7/19.
//  Copyright © 2019 VMware. All rights reserved.
//

@import Cocoa;
#import "FileSystemNode.h"
#import "FileSystemBrowserCell.h"
#import "PreviewViewController.h"

@interface AppController : NSObject {
    
    // Packager metadata
    NSString *stringSettingsFile;
    //NSString *stringLogFile;
    
    NSString *stringApplicationName;
    NSString *stringAppVersion;
    
    // Project metadata
    NSString *stringProjectFile;
    
    NSString *stringProjectName;
    NSString *stringProjectVersion;
    NSString *stringProjectHome;
    
    int intProjectOwner;
    int intProjectGroup;
    int intProjectPermissions;
    
}

// Menu
- (IBAction)menuNewProject:(id)sender;
- (IBAction)menuOpenProject:(id)sender;
- (IBAction)menuSaveProject:(id)sender;

- (IBAction)menuBuildPKG:(id)sender;
- (IBAction)menuBuildDMG:(id)sender;

// UI controls
@property (strong) IBOutlet NSTextField *labelName;
@property (strong) IBOutlet NSTextField *labelVersion;
@property (strong) IBOutlet NSTextField *labelHome;
@property (weak) IBOutlet NSBrowser *browser;
@property (strong) FileSystemNode *rootNode;
@property NSInteger draggedColumnIndex;
@property (strong) PreviewViewController *sharedPreviewController;
@property (weak) IBOutlet NSWindow *windowMain;

- (IBAction)buttonNewProject:(NSButton *)sender;
- (IBAction)buttonOpenProject:(NSButton *)sender;
- (IBAction)buttonSaveProject:(NSButton *)sender;
- (IBAction)buttonBuildPKG:(NSButton *)sender;
- (IBAction)buttonBuildDMG:(NSButton *)sender;
- (IBAction)buttonBrowse:(NSButton *)sender;
- (IBAction)comboboxOwner:(NSComboBox *)sender;
- (IBAction)comboboxGroup:(NSComboBox *)sender;
- (IBAction)checkboxOwnerRead:(NSButton *)sender;
- (IBAction)checkboxOwnerWrite:(NSButton *)sender;
- (IBAction)checkboxOwnerExecute:(NSButton *)sender;
- (IBAction)checkboxGroupRead:(NSButton *)sender;
- (IBAction)checkboxGroupWrite:(NSButton *)sender;
- (IBAction)checkboxGroupExecute:(NSButton *)sender;
- (IBAction)checkboxEveryoneRead:(NSButton *)sender;
- (IBAction)checkboxEveryoneWrite:(NSButton *)sender;
- (IBAction)checkboxEveryoneExecute:(NSButton *)sender;

// Main functions
- (void)NewProject;
- (void)OpenProject;
- (void)SaveProject;
- (void)BuildPKG;
- (void)BuildDMG;
- (void)Browse;

@end
