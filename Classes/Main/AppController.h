//
//  AppController.h
//  Packager
//
//  Created by Brian Buchholtz on 11/7/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

@import Cocoa;
#import "PreferencesViewController.h"
#import "FileSystemNode.h"
#import "FileSystemBrowserCell.h"
#import "PreviewViewController.h"

@interface AppController:NSObject {
    
    // Packager metadata
    NSString *stringSettingsFile;
    NSString *stringSettingsApplicationName;
    NSString *stringSettingsApplicationVersion;
    NSString *stringSettingsPreferencesLanguage;
    NSString *stringSettingsPreferencesLogPath;
    NSString *stringSettingsPreferencesComparisonKey;
    NSString *stringSettingsPreferencesType;
    NSString *stringSettingsPreferencesReceipt;
    NSString *stringSettingsPreferencesDevCert;
    NSString *stringSettingsPreferencesIsSigned;
    NSString *stringSettingsPreferencesDevId;
    NSString *stringSettingsPreferencesIsNotarized;
    NSString *stringSettingsPreferencesOwner;
    NSString *stringSettingsPreferencesGroup;
    NSString *stringSettingsPreferencesPermissions;
    NSString *stringSettingsPreferencesVersionPackageName;
    NSString *stringSettingsPreferencesVersionPlistName;
    NSString *stringSettingsPreferencesDateTimePackageName;
    NSString *stringSettingsPreferencesDateTimePlistName;
    NSString *stringSettingsPreferencesPackageTypePlistName;
    NSString *stringSettingsPreferencesOpenLastProject;
    NSString *stringSettingsPreferencesLastProjectFile;
    
    // Project status
    BOOL boolProjectOpened;
    BOOL boolProjectChanged;
    
    // Project metadata
    NSString *stringProjectFile;
    NSString *stringProjectApplicationName;
    NSString *stringProjectApplicationVersion;
    NSString *stringProjectMetadataName;
    NSString *stringProjectMetadataIdentifier;
    NSString *stringProjectMetadataVersion;
    NSString *stringProjectMetadataShortVersion;
    NSString *stringProjectMetadataComparisonKey;
    NSString *stringProjectMetadataType;
    NSString *stringProjectMetadataReceipt;
    NSString *stringProjectMetadataInstall;
    NSString *stringProjectMetadataScripts;
    NSString *stringProjectMetadataOwner;
    NSString *stringProjectMetadataGroup;
    NSString *stringProjectMetadataPermissions;
    NSString *stringProjectMetadataDevCert;
    NSString *stringProjectMetadataDevId;
    NSString *stringProjectMetadataSource;
    NSString *stringProjectMetadataTarget;
    NSString *stringProjectMetadataRunScripts;
    NSString *stringProjectMetadataIsSigned;
    NSString *stringProjectMetadataIsNotarized;
    
    // Project permissions
    NSInteger intPermissionsOwner;
    NSInteger intPermissionsGroup;
    NSInteger intPermissionsEveryone;
    
    // View variables
    NSString *stringRequestUuid;
    NSString *stringPackageSource;
    NSString *stringPackageTarget;
    NSString *stringExpandMode;
    
}

// Control outlets
@property (weak) IBOutlet NSWindow *windowMainOutlet;

@property (strong) IBOutlet NSTextField *textboxProjectNameOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectIdentifierOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectVersionOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectShortVersionOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectInstallOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectScriptsOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectDevIdOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectSourceOutlet;
@property (strong) IBOutlet NSTextField *textboxProjectTargetOutlet;
@property (strong) IBOutlet NSTextField *textboxStatusOutlet;

@property (strong) IBOutlet NSComboBox *comboboxProjectComparisonKeyOutlet;
@property (strong) IBOutlet NSComboBox *comboboxProjectTypeOutlet;
@property (strong) IBOutlet NSComboBox *comboboxProjectOwnerOutlet;
@property (strong) IBOutlet NSComboBox *comboboxProjectGroupOutlet;
@property (strong) IBOutlet NSComboBox *comboboxProjectDevCertOutlet;
@property (strong) IBOutlet NSComboBox *comboboxProjectReceiptOutlet;

@property (strong) IBOutlet NSButton *checkboxProjectOwnerReadOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectOwnerWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectOwnerExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectGroupReadOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectGroupWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectGroupExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectEveryoneReadOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectEveryoneWriteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectEveryoneExecuteOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectRunScriptsOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectIsSignedOutlet;
@property (strong) IBOutlet NSButton *checkboxProjectIsNotarizedOutlet;

@property (weak) IBOutlet NSBrowser *browserSourceOutlet;

// Control properties
@property (strong) FileSystemNode *rootNodeSource;
@property NSInteger draggedColumnIndexSource;
@property (strong) PreviewViewController *sharedPreviewControllerSource;

// Control actions
- (IBAction)menuPreferencesAction:(id)sender;
- (IBAction)menuNewProjectAction:(id)sender;
- (IBAction)menuOpenProjectAction:(id)sender;
- (IBAction)menuSaveProjectAction:(id)sender;
- (IBAction)menuBuildPKGAction:(id)sender;
- (IBAction)menuBuildDMGAction:(id)sender;
- (IBAction)menuExtractPKGAction:(id)sender;
- (IBAction)menuExtractDMGAction:(id)sender;
- (IBAction)menuShowHelp:(id)sender;
- (IBAction)menuNewFolder:(id)sender;
- (IBAction)menuRename:(id)sender;
- (IBAction)menuDelete:(id)sender;
- (IBAction)menuRefresh:(id)sender;

- (IBAction)buttonNewProjectAction:(NSButton *)sender;
- (IBAction)buttonOpenProjectAction:(NSButton *)sender;
- (IBAction)buttonSaveProjectAction:(NSButton *)sender;
- (IBAction)buttonBuildPKGAction:(NSButton *)sender;
- (IBAction)buttonBuildDMGAction:(NSButton *)sender;
- (IBAction)buttonBrowseInstallAction:(NSButton *)sender;
- (IBAction)buttonBrowseScriptsAction:(NSButton *)sender;
- (IBAction)buttonBrowseSourceAction:(NSButton *)sender;
- (IBAction)buttonBrowseTargetAction:(NSButton *)sender;

- (IBAction)comboboxProjectComparisonKeyAction:(NSComboBox *)sender;
- (IBAction)comboboxProjectTypeAction:(NSComboBox *)sender;
- (IBAction)comboboxProjectOwnerAction:(NSComboBox *)sender;
- (IBAction)comboboxProjectGroupAction:(NSComboBox *)sender;
- (IBAction)comboboxProjectDevCertAction:(NSComboBox *)sender;
- (IBAction)comboboxProjectReceiptAction:(NSComboBox *)sender;

- (IBAction)checkboxProjectOwnerReadAction:(NSButton *)sender;
- (IBAction)checkboxProjectOwnerWriteAction:(NSButton *)sender;
- (IBAction)checkboxProjectOwnerExecuteAction:(NSButton *)sender;
- (IBAction)checkboxProjectGroupReadAction:(NSButton *)sender;
- (IBAction)checkboxProjectGroupWriteAction:(NSButton *)sender;
- (IBAction)checkboxProjectGroupExecuteAction:(NSButton *)sender;
- (IBAction)checkboxProjectEveryoneReadAction:(NSButton *)sender;
- (IBAction)checkboxProjectEveryoneWriteAction:(NSButton *)sender;
- (IBAction)checkboxProjectEveryoneExecuteAction:(NSButton *)sender;
- (IBAction)checkboxProjectRunScriptsAction:(NSButton *)sender;
- (IBAction)checkboxProjectIsSignedAction:(NSButton *)sender;
- (IBAction)checkboxProjectIsNotarizedAction:(NSButton *)sender;

- (IBAction)textboxProjectNameAction:(NSTextField *)sender;
- (IBAction)textboxProjectIdentifierAction:(NSTextField *)sender;
- (IBAction)textboxProjectVersionAction:(NSTextField *)sender;
- (IBAction)textboxProjectShortVersionAction:(NSTextField *)sender;
- (IBAction)textboxProjectInstallAction:(NSTextField *)sender;
- (IBAction)textboxProjectScriptsAction:(NSTextField *)sender;
- (IBAction)textboxProjectDevIdAction:(NSTextField *)sender;

// Main functions
- (void)readSettings;
- (void)saveSettings;
- (void)loadSettings;
- (void)updateTitle;
- (void)updateStatus:(NSString *)stringStatus;
- (void)setPreferences;
- (void)newProject;
- (void)openProject;
- (BOOL)projectChanged;
- (void)saveProject;
- (void)openLastProject;
- (void)clearProject;
- (void)buildPKG;
- (void)buildDMG;
- (void)extractPKG;
- (void)extractDMG;
- (void)browseInstall;
- (void)browseScripts;
- (void)browseSource;
- (void)browseTarget;
- (void)showHelp;
- (void)newFolder;
- (void)renameItem;
- (void)deleteItem;
- (void)readUsers;
- (void)readGroups;
- (void)readIdentities;
- (void)getControls;
- (void)setControls;
- (BOOL)validateControls;
- (void)changeRoot;
- (void)reloadBrowser;

@end
