//
//  AppController.h
//  Packager
//
//  Created by Brian Buchholtz on 11/7/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
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
    NSString *stringProjectIdentifier;
    
    NSString *stringProjectSource;
    NSString *stringProjectTarget;
    
    NSString *stringProjectOwner;
    NSString *stringProjectGroup;
    NSString *stringProjectPermissions;
    
    NSString *stringProjectRoot;
    NSString *stringProjectSign;
    NSString *stringProjectIsSigned;
    
    // Control variables
    NSInteger intPermissionsOwner;
    NSInteger intPermissionsGroup;
    NSInteger intPermissionsEveryone;
    
}

// Control outlets
@property (weak) IBOutlet NSWindow *windowMainOutlet;

@property (strong) IBOutlet NSTextField *textboxNameOutlet;
@property (strong) IBOutlet NSTextField *textboxVersionOutlet;
@property (strong) IBOutlet NSTextField *textboxIdentifierOutlet;
@property (strong) IBOutlet NSTextField *textboxRootOutlet;
@property (strong) IBOutlet NSTextField *textboxSourceOutlet;
@property (strong) IBOutlet NSTextField *textboxTargetOutlet;

@property (strong) IBOutlet NSComboBox *comboboxOwnerOutlet;
@property (strong) IBOutlet NSComboBox *comboboxGroupOutlet;
@property (strong) IBOutlet NSComboBox *comboboxSignOutlet;

@property (strong) IBOutlet NSButton *checkboxOwnerReadOutlet;
@property (strong) IBOutlet NSButton *checkboxOwnerWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxOwnerExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxGroupReadOutlet;
@property (strong) IBOutlet NSButton *checkboxGroupWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxGroupExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxEveryoneReadOutlet;
@property (strong) IBOutlet NSButton *checkboxEveryoneWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxEveryoneExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectIsSignedOutlet;

@property (weak) IBOutlet NSBrowser *browserSourceOutlet;

// Control properties
@property (strong) FileSystemNode *rootNodeSource;
@property NSInteger draggedColumnIndexSource;
@property (strong) PreviewViewController *sharedPreviewControllerSource;

// Control actions
- (IBAction)menuNewProjectAction:(id)sender;
- (IBAction)menuOpenProjectAction:(id)sender;
- (IBAction)menuSaveProjectAction:(id)sender;

- (IBAction)menuBuildPKGAction:(id)sender;
- (IBAction)menuBuildDMGAction:(id)sender;

- (IBAction)menuShowHelp:(id)sender;

- (IBAction)buttonNewProjectAction:(NSButton *)sender;
- (IBAction)buttonOpenProjectAction:(NSButton *)sender;
- (IBAction)buttonSaveProjectAction:(NSButton *)sender;
- (IBAction)buttonBuildPKGAction:(NSButton *)sender;
- (IBAction)buttonBuildDMGAction:(NSButton *)sender;

- (IBAction)buttonBrowseSourceAction:(NSButton *)sender;
- (IBAction)buttonBrowseTargetAction:(NSButton *)sender;
- (IBAction)buttonBrowseRootAction:(NSButton *)sender;

- (IBAction)comboboxOwnerAction:(NSComboBox *)sender;
- (IBAction)comboboxGroupAction:(NSComboBox *)sender;
- (IBAction)comboboxSignAction:(NSComboBox *)sender;

- (IBAction)checkboxOwnerReadAction:(NSButton *)sender;
- (IBAction)checkboxOwnerWriteAction:(NSButton *)sender;
- (IBAction)checkboxOwnerExecuteAction:(NSButton *)sender;
- (IBAction)checkboxGroupReadAction:(NSButton *)sender;
- (IBAction)checkboxGroupWriteAction:(NSButton *)sender;
- (IBAction)checkboxGroupExecuteAction:(NSButton *)sender;
- (IBAction)checkboxEveryoneReadAction:(NSButton *)sender;
- (IBAction)checkboxEveryoneWriteAction:(NSButton *)sender;
- (IBAction)checkboxEveryoneExecuteAction:(NSButton *)sender;
- (IBAction)checkboxProjectIsSignedAction:(NSButton *)sender;

// Main functions
- (void)newProject;
- (void)openProject;
- (void)saveProject;
- (void)buildPKG;
- (void)buildDMG;
- (void)browseRoot;
- (void)browseSource;
- (void)browseTarget;
- (void)readUsers;
- (void)readGroups;
- (void)readIdentities;
- (void)getControls;
- (void)setControls;
- (BOOL)validateControls;
- (void)changeRoot;

@end
