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
    NSString *stringApplicationVersion;
    
    // Project metadata
    NSString *stringProjectFile;
    
    NSString *stringProjectApplicationName;
    NSString *stringProjectApplicationVersion;
    
    NSString *stringProjectName;
    NSString *stringProjectVersion;
    NSString *stringProjectHome;
    
    NSString *stringProjectOwner;
    NSString *stringProjectGroup;
    NSString *stringProjectPermissions;
    
    // Control variables
    NSInteger intPermissionsOwner;
    NSInteger intPermissionsGroup;
    NSInteger intPermissionsEveryone;
    
}

// Menu
- (IBAction)menuNewProject:(id)sender;
- (IBAction)menuOpenProject:(id)sender;
- (IBAction)menuSaveProject:(id)sender;

- (IBAction)menuBuildPKG:(id)sender;
- (IBAction)menuBuildDMG:(id)sender;

// Control outlets
@property (weak) IBOutlet NSWindow *windowMain;

@property (strong) IBOutlet NSTextField *labelName;
@property (strong) IBOutlet NSTextField *labelVersion;
@property (strong) IBOutlet NSTextField *labelHome;

@property (strong) IBOutlet NSComboBox *comboboxOwner;
@property (strong) IBOutlet NSComboBox *comboboxGroup;

@property (strong) IBOutlet NSComboBoxCell *comboboxcellGroup;
@property (strong) IBOutlet NSComboBoxCell *comboboxcellOwner;

@property (strong) IBOutlet NSButton *checkboxOwnerRead;
@property (strong) IBOutlet NSButton *checkboxOwnerWrite;
@property (strong) IBOutlet NSButton *checkboxOwnerExecute;
@property (strong) IBOutlet NSButton *checkboxGroupRead;
@property (strong) IBOutlet NSButton *checkboxGroupWrite;
@property (strong) IBOutlet NSButton *checkboxGroupExecute;
@property (strong) IBOutlet NSButton *checkboxEveryoneRead;
@property (strong) IBOutlet NSButton *checkboxEveryoneWrite;
@property (strong) IBOutlet NSButton *checkboxEveryoneExecute;
@property (weak) IBOutlet NSBrowser *browser;

// Control properties
@property (strong) FileSystemNode *rootNode;
@property NSInteger draggedColumnIndex;
@property (strong) PreviewViewController *sharedPreviewController;

// Control actions
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
- (void)ReadUsers;
- (void)ReadGroups;
- (void)GetControls;
- (void)SetControls;
- (void)ValidateControls;
- (void)ChangeRoot;

@end
