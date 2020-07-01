//
//  AppController.m
//  Packager
//
//  Created by Brian Buchholtz on 11/7/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "AppController.h"
#import "PreferencesViewController.h"
#import "ExtractViewController.h"
#import "PreviewViewController.h"
#import "Settings.h"
#import "FilePicker.h"
#import "SaveAs.h"
#import "Project.h"
#import "BrowsePath.h"
#import "UserGroup.h"
#import "Identities.h"
#import "FileSystemNode.h"
#import "FileSystemBrowserCell.h"
#import "FileName.h"
#import "BuildPackage.h"
#import "SignPackage.h"
#import "ValidateXcode.h"
#import "NotarizePackage.h"
#import "StaplePackage.h"
#import "ProjectManifest.h"
#import "PayloadSize.h"
#import "FileSize.h"
#import "ShaSum.h"
#import "GeneratePlist.h"
#import "ExtractPackage.h"
#import "Logger.h"

@interface AppController ()

@end

@implementation AppController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main application initialization

- (void)applicationWillFinishLaunching:(NSNotification *)not {
    
    // Set application metadata
    stringSettingsApplicationName = @"VMware Workspace ONE Packager";
    stringSettingsApplicationVersion = @"4.0";
    
    // Settings path and file
    NSURL *urlAppPath = [[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent];
    NSString *stringSettingsPath = urlAppPath.path;
    stringSettingsFile = [NSString stringWithFormat:@"%@/%@", stringSettingsPath, @"Packager.settings"];
    
    // Check for presence of settings file
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringSettingsFile] == YES) {
        
        // Settings file exists, read preferences
        [self readSettings];
        
    }
    
    else {
        
        // No settings file exists, create one based on default values
        stringSettingsPreferencesLanguage = @"en-us";
        stringSettingsPreferencesLogPath = @"";
        stringSettingsPreferencesComparisonKey = @"CFBundleVersion";
        stringSettingsPreferencesType = @"file";
        stringSettingsPreferencesReceipt = @"installs";
        stringSettingsPreferencesDevCert = @"";
        stringSettingsPreferencesIsSigned = @"FALSE";
        stringSettingsPreferencesDevId = @"";
        stringSettingsPreferencesIsNotarized = @"FALSE";
        stringSettingsPreferencesOwner = @"";
        stringSettingsPreferencesGroup = @"";
        stringSettingsPreferencesPermissions = @"775";
        stringSettingsPreferencesVersionPackageName = @"TRUE";
        stringSettingsPreferencesVersionPlistName = @"TRUE";
        stringSettingsPreferencesDateTimePackageName = @"TRUE";
        stringSettingsPreferencesDateTimePlistName = @"TRUE";
        stringSettingsPreferencesPackageTypePlistName = @"TRUE";
        stringSettingsPreferencesOpenLastProject = @"FALSE";
        stringSettingsPreferencesLastProjectFile = @"";
        
        [self saveSettings];
        
    }
    
    // Log initialization
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        
        [standardUserDefaults setObject:stringSettingsPreferencesLogPath forKey:@"keyLogPath"];
        [standardUserDefaults synchronize];
        
    }
    
    [Logger setLogEvent:@"Application: ", stringSettingsApplicationName, nil];
    [Logger setLogEvent:@"Version: ", stringSettingsApplicationVersion, nil];
    
    // Track project opened
    boolProjectOpened = NO;
    
    // Track project changes
    boolProjectChanged = NO;
    
    // Update application window title
    [self updateTitle];
    
    // Load settings
    [self loadSettings];
    
    // Initialize project variables
    stringProjectFile = @"";
    stringProjectApplicationName = stringSettingsApplicationName;
    stringProjectApplicationVersion = stringSettingsApplicationVersion;
    stringProjectMetadataName = @"";
    stringProjectMetadataIdentifier = @"";
    stringProjectMetadataVersion = @"";
    stringProjectMetadataShortVersion = @"";
    stringProjectMetadataInstall = @"";
    stringProjectMetadataScripts = @"";
    stringProjectMetadataSource = @"";
    stringProjectMetadataTarget = @"";
    stringProjectMetadataRunScripts = @"FALSE";
    
    // Check to open last project
    if ([stringSettingsPreferencesOpenLastProject isEqualToString:@"TRUE"]) {
        
        // Open last project
        [self openLastProject];
        
    }
    
    else {
        
        // Set controls
        [self setControls];
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser initialization
//
// Please note bug #24527817
// NSBrowser column titles draw sporadic when navigating back with left arrow key (10.11)
//

- (void)awakeFromNib {
    
    // use a custom cell class for each browser item
    [self.browserSourceOutlet setCellClass:[FileSystemBrowserCell class]];
    
    // Drag and drop support
    [self.browserSourceOutlet registerForDraggedTypes:@[NSFilenamesPboardType]];
    [self.browserSourceOutlet setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    [self.browserSourceOutlet setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
    
    // if you want to change the background color of NSBrowser use this:
    //self.browser.backgroundColor = [NSColor controlBackgroundColor];
    
    // Double click support
    self.browserSourceOutlet.target = self;
    self.browserSourceOutlet.doubleAction = @selector(browserDoubleClick:);
    
    [self reloadBrowser];
    
}

- (id)rootItemForBrowser:(NSBrowser *)browserSourceOutlet {
    
    if (self.rootNodeSource == nil) {
        
        _rootNodeSource = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:NSOpenStepRootDirectory()]];
        
    }
    
    return self.rootNodeSource;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Menu

- (IBAction)menuPreferencesAction:(id)sender {
    
    // Set preferences
    [self setPreferences];
    
}

- (IBAction)menuNewProjectAction:(id)sender {
    
    // New project
    [self newProject];
    
}

- (IBAction)menuOpenProjectAction:(id)sender {
    
    // Open project
    [self openProject];
    
}

- (IBAction)menuSaveProjectAction:(id)sender {
    
    // Save project
    [self saveProject];
    
}

- (IBAction)menuBuildPKGAction:(id)sender {
    
    // Build PKG
    [self buildPKG];
    
}

- (IBAction)menuBuildDMGAction:(id)sender {
    
    // Build DMG
    [self buildDMG];
    
}

- (IBAction)menuExtractPKGAction:(id)sender {
    
    // Build PKG
    [self extractPKG];
    
}

- (IBAction)menuExtractDMGAction:(id)sender {
    
    // Build DMG
    [self extractDMG];
    
}

- (IBAction)menuShowHelp:(id)sender {
    
    // Display help page
    [self showHelp];
    
}

- (IBAction)menuNewFolder:(id)sender {
    
    // New folder
    [self newFolder];
    
}

- (IBAction)menuRename:(id)sender {
    
    // Rename file or folder
    [self renameItem];
    
}

- (IBAction)menuDelete:(id)sender {
    
    // Moves file or folder to trash
    [self deleteItem];
    
}

- (IBAction)menuRefresh:(id)sender {
    
    // Refresh browser contents
    [self reloadBrowser];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controls

- (IBAction)buttonNewProjectAction:(NSButton *)sender {
    
    // New project
    [self newProject];
    
}

- (IBAction)buttonOpenProjectAction:(NSButton *)sender {
    
    // Open project
    [self openProject];
    
}

- (IBAction)buttonSaveProjectAction:(NSButton *)sender {
    
    // Save project
    [self saveProject];
    
}

- (IBAction)buttonBuildPKGAction:(NSButton *)sender {
    
    // Build PKG
    [self buildPKG];
    
}

- (IBAction)buttonBuildDMGAction:(NSButton *)sender {
    
    // Build DMG
    [self buildDMG];
    
}

- (IBAction)buttonBrowseInstallAction:(NSButton *)sender {
    
    // Browse project install
    [self browseInstall];
    
}

- (IBAction)buttonBrowseScriptsAction:(NSButton *)sender {
    
    // Browse project scripts
    [self browseScripts];
    
}

- (IBAction)buttonBrowseSourceAction:(NSButton *)sender {
    
    // Browse project source
    [self browseSource];
    
}

- (IBAction)buttonBrowseTargetAction:(NSButton *)sender {
    
    // Browse project target
    [self browseTarget];
    
}

- (IBAction)comboboxProjectComparisonKeyAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataComparisonKey isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)comboboxProjectTypeAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataType isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)comboboxProjectOwnerAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataOwner isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)comboboxProjectGroupAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataGroup isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)comboboxProjectDevCertAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataDevCert isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)comboboxProjectReceiptAction:(NSComboBox *)sender {
    
    if (![stringProjectMetadataReceipt isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)checkboxProjectOwnerReadAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectOwnerWriteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectOwnerExecuteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectGroupReadAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectGroupWriteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectGroupExecuteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectEveryoneReadAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectEveryoneWriteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectEveryoneExecuteAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectRunScriptsAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectIsSignedAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)checkboxProjectIsNotarizedAction:(NSButton *)sender {
    
    // Track project changes
    boolProjectChanged = YES;
    
    // Update application window title
    [self updateTitle];
    
}

- (IBAction)textboxProjectNameAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataName isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectShortVersionAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataShortVersion isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectVersionAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataVersion isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectIdentifierAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataIdentifier isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectInstallAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataInstall isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectScriptsAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataScripts isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

- (IBAction)textboxProjectDevIdAction:(NSTextField *)sender {
    
    if (![stringProjectMetadataDevId isEqualToString:[sender stringValue]]) {
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions

- (void)readSettings {
    
    // Create settings class
    Settings *openSettings = [[Settings alloc] init];
    NSDictionary *dictSettings = [openSettings readSettings:stringSettingsFile];
    
    // Application metadata
    // Maybe be useful in future versions
    //stringProjectApplicationName = dictSettings[@"SettingsApplicationName"];
    //stringProjectApplicationVersion = dictSettings[@"SettingsApplicationVersion"];
    
    // Application preferences
    stringSettingsPreferencesLanguage = dictSettings[@"SettingsPreferencesLanguage"];
    stringSettingsPreferencesLogPath = dictSettings[@"SettingsPreferencesLogPath"];
    stringSettingsPreferencesComparisonKey = dictSettings[@"SettingsPreferencesComparisonKey"];
    stringSettingsPreferencesType = dictSettings[@"SettingsPreferencesType"];
    stringSettingsPreferencesReceipt = dictSettings[@"SettingsPreferencesReceipt"];
    stringSettingsPreferencesDevCert = dictSettings[@"SettingsPreferencesDevCert"];
    stringSettingsPreferencesIsSigned = dictSettings[@"SettingsPreferencesIsSigned"];
    stringSettingsPreferencesDevId = dictSettings[@"SettingsPreferencesDevId"];
    stringSettingsPreferencesIsNotarized = dictSettings[@"SettingsPreferencesIsNotarized"];
    stringSettingsPreferencesOwner = dictSettings[@"SettingsPreferencesOwner"];
    stringSettingsPreferencesGroup = dictSettings[@"SettingsPreferencesGroup"];
    stringSettingsPreferencesPermissions = dictSettings[@"SettingsPreferencesPermissions"];
    stringSettingsPreferencesVersionPackageName = dictSettings[@"SettingsPreferencesVersionPackageName"];
    stringSettingsPreferencesVersionPlistName = dictSettings[@"SettingsPreferencesVersionPlistName"];
    stringSettingsPreferencesDateTimePackageName = dictSettings[@"SettingsPreferencesDateTimePackageName"];
    stringSettingsPreferencesDateTimePlistName = dictSettings[@"SettingsPreferencesDateTimePlistName"];
    stringSettingsPreferencesPackageTypePlistName = dictSettings[@"SettingsPreferencesPackageTypePlistName"];
    stringSettingsPreferencesOpenLastProject = dictSettings[@"SettingsPreferencesOpenLastProject"];
    stringSettingsPreferencesLastProjectFile = dictSettings[@"SettingsPreferencesLastProjectFile"];
    
}

- (void)saveSettings {
    
    [Settings writeSettings:stringSettingsFile SettingsApplicationName:stringSettingsApplicationName SettingsApplicationVersion:stringSettingsApplicationVersion SettingsPreferencesLanguage:stringSettingsPreferencesLanguage SettingsPreferencesLogPath:stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:stringSettingsPreferencesComparisonKey SettingsPreferencesType:stringSettingsPreferencesType SettingsPreferencesReceipt:stringSettingsPreferencesReceipt SettingsPreferencesDevCert:stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:stringSettingsPreferencesIsSigned SettingsPreferencesDevId:stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:stringSettingsPreferencesOwner SettingsPreferencesGroup:stringSettingsPreferencesGroup SettingsPreferencesPermissions:stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:stringSettingsPreferencesLastProjectFile];
    
}

- (void)loadSettings {
    
    // Load default settings
    stringProjectMetadataComparisonKey = stringSettingsPreferencesComparisonKey;
    stringProjectMetadataType = stringSettingsPreferencesType;
    stringProjectMetadataReceipt = stringSettingsPreferencesReceipt;
    stringProjectMetadataDevCert = stringSettingsPreferencesDevCert;
    stringProjectMetadataIsSigned = stringSettingsPreferencesIsSigned;
    stringProjectMetadataDevId = stringSettingsPreferencesDevId;
    stringProjectMetadataIsNotarized = stringSettingsPreferencesIsNotarized;
    stringProjectMetadataOwner = stringSettingsPreferencesOwner;
    stringProjectMetadataGroup = stringSettingsPreferencesGroup;
    stringProjectMetadataPermissions = stringSettingsPreferencesPermissions;
    
    // Update control variables
    NSString *stringTemp;
    
    stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(0, 1)];
    NSLog(@"Owner: %@", stringTemp);
    intPermissionsOwner = [stringTemp integerValue];
    
    stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(1, 1)];
    NSLog(@"Group: %@", stringTemp);
    intPermissionsGroup = [stringTemp integerValue];
    
    stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(2, 1)];
    NSLog(@"Everyone: %@", stringTemp);
    intPermissionsEveryone = [stringTemp integerValue];
    
}

- (void)updateTitle {
    
    NSString *stringApplicationTitle = stringSettingsApplicationName;
    
    if (boolProjectOpened) {
        
        // Set project name
        stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationTitle, stringProjectFile];
        
    }
    
    else {
        
        // Empty project
        stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationTitle, @"(Empty Project)"];
        
    }
    
    if (boolProjectChanged) {
        
        // Project changed
        stringApplicationTitle = [NSString stringWithFormat:@"%@%@", stringApplicationTitle, @"*"];
        
    }
    
    [self.windowMainOutlet setTitle:stringApplicationTitle];
    
}

- (void)updateStatus:(NSString *)stringStatus {
    
    // Update status
    [self.textboxStatusOutlet setStringValue:stringStatus];
    
}

- (void)setPreferences {
    
    // Get controls
    [self getControls];
    
    // Load custom alert for preferences
    PreferencesViewController *preferencesViewController = [[PreferencesViewController alloc] init];
    NSDictionary *dictPreferences = [preferencesViewController viewPreferences:stringSettingsPreferencesLanguage SettingsPreferencesLogPath:stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:stringSettingsPreferencesComparisonKey SettingsPreferencesType:stringSettingsPreferencesType SettingsPreferencesReceipt:stringSettingsPreferencesReceipt SettingsPreferencesDevCert:stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:stringSettingsPreferencesIsSigned SettingsPreferencesDevId:stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:stringSettingsPreferencesOwner SettingsPreferencesGroup:stringSettingsPreferencesGroup SettingsPreferencesPermissions:stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:stringSettingsPreferencesLastProjectFile];
    
    // Application preferences
    NSString *stringSettingsPreferencesLoad = dictPreferences[@"SettingsPreferencesLoad"];
    
    // Load settings check
    if ([stringSettingsPreferencesLoad isEqualToString:@"TRUE"]) {
        
        // Read rest of dictionary
        stringSettingsPreferencesLanguage = dictPreferences[@"SettingsPreferencesLanguage"];
        stringSettingsPreferencesLogPath = dictPreferences[@"SettingsPreferencesLogPath"];
        stringSettingsPreferencesComparisonKey = dictPreferences[@"SettingsPreferencesComparisonKey"];
        stringSettingsPreferencesType = dictPreferences[@"SettingsPreferencesType"];
        stringSettingsPreferencesReceipt = dictPreferences[@"SettingsPreferencesReceipt"];
        stringSettingsPreferencesDevCert = dictPreferences[@"SettingsPreferencesDevCert"];
        stringSettingsPreferencesIsSigned = dictPreferences[@"SettingsPreferencesIsSigned"];
        stringSettingsPreferencesDevId = dictPreferences[@"SettingsPreferencesDevId"];
        stringSettingsPreferencesIsNotarized = dictPreferences[@"SettingsPreferencesIsNotarized"];
        stringSettingsPreferencesOwner = dictPreferences[@"SettingsPreferencesOwner"];
        stringSettingsPreferencesGroup = dictPreferences[@"SettingsPreferencesGroup"];
        stringSettingsPreferencesPermissions = dictPreferences[@"SettingsPreferencesPermissions"];
        stringSettingsPreferencesVersionPackageName = dictPreferences[@"SettingsPreferencesVersionPackageName"];
        stringSettingsPreferencesVersionPlistName = dictPreferences[@"SettingsPreferencesVersionPlistName"];
        stringSettingsPreferencesDateTimePackageName = dictPreferences[@"SettingsPreferencesDateTimePackageName"];
        stringSettingsPreferencesDateTimePlistName = dictPreferences[@"SettingsPreferencesDateTimePlistName"];
        stringSettingsPreferencesPackageTypePlistName = dictPreferences[@"SettingsPreferencesPackageTypePlistName"];
        stringSettingsPreferencesOpenLastProject = dictPreferences[@"SettingsPreferencesOpenLastProject"];
        stringSettingsPreferencesLastProjectFile = dictPreferences[@"SettingsPreferencesLastProjectFile"];
        
        // Log initialization
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (standardUserDefaults) {
            
            [standardUserDefaults setObject:stringSettingsPreferencesLogPath forKey:@"keyLogPath"];
            [standardUserDefaults synchronize];
            
        }
        
        // Save settings
        [self saveSettings];
        
        // Load settings
        [self loadSettings];
        
        // Set controls
        [self setControls];
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
        // Update status
        [self updateStatus:@"Preferences Saved"];
        
    }
    
}

- (void)newProject {
    
    // Browse for new project file
    SaveAs *newFile = [[SaveAs alloc] init];
    NSString *stringNewFile = [newFile newFile];
    
    if (stringNewFile) {
        
        stringProjectFile = stringNewFile;
        
        // Track project opened
        boolProjectOpened = YES;
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
        [Logger setLogEvent:@"New file open successful", nil];
        
        // Load alert
        NSAlert *alertClearProject = [[NSAlert alloc] init];
        
        [alertClearProject setMessageText:@"Clear Current Project?"];
        [alertClearProject setInformativeText:@"Clear all metadata for open project"];
        [alertClearProject setAlertStyle:NSWarningAlertStyle];
        [alertClearProject addButtonWithTitle:@"Yes"];
        [alertClearProject addButtonWithTitle:@"No"];
        
        NSInteger intButton = [alertClearProject runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            // Clear current project
            [self clearProject];
            
            // Read settings
            [self readSettings];
            
            // Load settings
            [self loadSettings];
            
            // Set controls
            [self setControls];
            
        }

        else if (intButton == NSAlertSecondButtonReturn) {
            
            // Keep current project settings
            [Logger setLogEvent:@"Preserving current project settings", nil];
            
        }
        
        // Update status
        [self updateStatus:@"New Project"];
        
    }
    
    else {
        
        [Logger setLogEvent:@"New file open aborted", nil];
        
    }
    
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    
    // Check for presence of project file
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filename] == YES) {
        
        stringSettingsPreferencesLastProjectFile = filename;
        
        [self openLastProject];
        
        return YES;
        
    }
    
    else {
        
        [self updateStatus:@"Project Not Found"];
        
        return NO;
        
    }
    
}

- (void)openProject {
    
    BOOL boolOpenProject;
    
    if (boolProjectChanged) {
     
        boolOpenProject = [self projectChanged];
        
    }
    
    else {
        
        boolOpenProject = YES;
        
    }
    
    if (boolOpenProject) {
        
        // Set array of file types
        NSArray<NSString *> *arrayFileTypes = @[@"packager", @"Packager", @"PACKAGER"];
        
        // Browse for existing project file
        FilePicker *pickFile = [[FilePicker alloc] init];
        stringProjectFile = [pickFile getFile:arrayFileTypes];
        
        if (stringProjectFile) {
            
            // Create project class
            Project *openProject = [[Project alloc] init];
            NSDictionary *dictProject = [openProject readProject:stringProjectFile];
            
            // Application metadata
            stringProjectApplicationName = dictProject[@"ProjectApplicationName"];
            stringProjectApplicationVersion = dictProject[@"ProjectApplicationVersion"];
            
            // Project metadata
            stringProjectMetadataName = dictProject[@"ProjectMetadataName"];
            stringProjectMetadataIdentifier = dictProject[@"ProjectMetadataIdentifier"];
            stringProjectMetadataVersion = dictProject[@"ProjectMetadataVersion"];
            stringProjectMetadataShortVersion = dictProject[@"ProjectMetadataShortVersion"];
            stringProjectMetadataComparisonKey = dictProject[@"ProjectMetadataComparisonKey"];
            stringProjectMetadataType = dictProject[@"ProjectMetadataType"];
            stringProjectMetadataReceipt = dictProject[@"ProjectMetadataReceipt"];
            stringProjectMetadataInstall = dictProject[@"ProjectMetadataInstall"];
            stringProjectMetadataScripts = dictProject[@"ProjectMetadataScripts"];
            stringProjectMetadataOwner = dictProject[@"ProjectMetadataOwner"];
            stringProjectMetadataGroup = dictProject[@"ProjectMetadataGroup"];
            stringProjectMetadataPermissions = dictProject[@"ProjectMetadataPermissions"];
            stringProjectMetadataDevCert = dictProject[@"ProjectMetadataDevCert"];
            stringProjectMetadataDevId = dictProject[@"ProjectMetadataDevId"];
            stringProjectMetadataSource = dictProject[@"ProjectMetadataSource"];
            stringProjectMetadataTarget = dictProject[@"ProjectMetadataTarget"];
            stringProjectMetadataRunScripts = dictProject[@"ProjectMetadataRunScripts"];
            stringProjectMetadataIsSigned = dictProject[@"ProjectMetadataIsSigned"];
            stringProjectMetadataIsNotarized = dictProject[@"ProjectMetadataIsNotarized"];
            
            // Track project opened
            boolProjectOpened = YES;
            
            // Track project changes
            boolProjectChanged = NO;
            
            // Update application window title
            [self updateTitle];
            
            // Parse permissions
            NSString *stringTemp;
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(0, 1)];
            NSLog(@"Owner: %@", stringTemp);
            intPermissionsOwner = [stringTemp integerValue];
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(1, 1)];
            NSLog(@"Group: %@", stringTemp);
            intPermissionsGroup = [stringTemp integerValue];
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(2, 1)];
            NSLog(@"Everyone: %@", stringTemp);
            intPermissionsEveryone = [stringTemp integerValue];
            
            // Update last project file
            stringSettingsPreferencesLastProjectFile = stringProjectFile;
            
            // Save settings
            [self saveSettings];
            
            // Update controls
            [self setControls];
            
            // Update browser
            [self changeRoot];
            
            // Add to open recent
            [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:stringProjectFile]];
            
            // Update status
            [self updateStatus:@"Project Opened"];
            
            [Logger setLogEvent:@"Successfully opened project: ", stringProjectFile, nil];
            
        }
        
        else {
            
            [Logger setLogEvent:@"File open: cancelled - User initiated", nil];
            
        }
        
    }
    
}

- (BOOL)projectChanged {
    
    BOOL boolOpenProject = NO;
    
    // Load alert
    NSAlert *alertUnsavedProject = [[NSAlert alloc] init];
    
    [alertUnsavedProject setMessageText:@"Continue Opening Project?"];
    [alertUnsavedProject setInformativeText:@"Current project has not been saved"];
    [alertUnsavedProject setAlertStyle:NSWarningAlertStyle];
    [alertUnsavedProject addButtonWithTitle:@"Yes"];
    [alertUnsavedProject addButtonWithTitle:@"No"];
    
    NSInteger intButton = [alertUnsavedProject runModal];
    
    if (intButton == NSAlertFirstButtonReturn) {
        
        // Open project
        boolOpenProject = YES;
    }
    
    else if (intButton == NSAlertSecondButtonReturn) {
        
        // Do not open project
        boolOpenProject = NO;
        
    }
        
    return boolOpenProject;
    
}

- (void)saveProject {
    
    // Verify open project
    if (stringProjectFile) {
        
        // Read control values
        [self getControls];
        
        // Read application settings
        stringProjectApplicationName = stringSettingsApplicationName;
        stringProjectApplicationVersion = stringSettingsApplicationVersion;
        
        // Write project file
        [Project writeProject:stringProjectFile ProjectApplicationName:stringProjectApplicationName ProjectApplicationVersion:stringProjectApplicationVersion ProjectMetadataName:stringProjectMetadataName ProjectMetadataIdentifier:stringProjectMetadataIdentifier ProjectMetadataVersion:stringProjectMetadataVersion ProjectMetadataShortVersion:stringProjectMetadataShortVersion ProjectMetadataComparisonKey:stringProjectMetadataComparisonKey ProjectMetadataType:stringProjectMetadataType ProjectMetadataReceipt:stringProjectMetadataReceipt ProjectMetadataInstall:stringProjectMetadataInstall ProjectMetadataScripts:stringProjectMetadataScripts ProjectMetadataOwner:stringProjectMetadataOwner ProjectMetadataGroup:stringProjectMetadataGroup ProjectMetadataPermissions:stringProjectMetadataPermissions ProjectMetadataDevCert:stringProjectMetadataDevCert ProjectMetadataDevId:stringProjectMetadataDevId ProjectMetadataSource:stringProjectMetadataSource ProjectMetadataTarget:stringProjectMetadataTarget ProjectMetadataRunScripts:stringProjectMetadataRunScripts ProjectMetadataIsSigned:stringProjectMetadataIsSigned ProjectMetadataIsNotarized:stringProjectMetadataIsNotarized];
        
        // Update last project file
        stringSettingsPreferencesLastProjectFile = stringProjectFile;
        
        // Save settings
        //[self saveSettings];
        
        // Track project opened
        boolProjectOpened = YES;
        
        // Track project changes
        boolProjectChanged = NO;
        
        // Update application window title
        [self updateTitle];
        
        // Add to open recent
        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:stringProjectFile]];
        
        // Update status
        [self updateStatus:@"Project Saved"];
        
        [Logger setLogEvent:@"Saving project file: ", stringProjectFile, nil];
        
    }
    
    else {
        
        // Load alert
        NSAlert *alertProject = [[NSAlert alloc] init];
        
        [alertProject setMessageText:@"Empty Project!"];
        [alertProject setInformativeText:@"Unable to save"];
        [alertProject setAlertStyle:NSCriticalAlertStyle];
        [alertProject addButtonWithTitle:@"Ok"];
        
        NSInteger intButton = [alertProject runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            
            
        }
        
        [Logger setLogEvent:@"Saving project file: Cancelled - Empty Project", nil];
        
    }
    
}

- (void)openLastProject {
    
    BOOL boolOpenProject;
    
    if (boolProjectChanged) {
        
        boolOpenProject = [self projectChanged];
        
    }
    
    else {
        
        boolOpenProject = YES;
        
    }
    
    if (boolOpenProject) {
     
        // Check for presence of project file
        NSFileManager *fileManager;
        fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:stringSettingsPreferencesLastProjectFile] == YES) {
            
            [Logger setLogEvent:@"Opening last project: ", stringSettingsPreferencesLastProjectFile, nil];
            
            // Set last profile file to current project file
            stringProjectFile = stringSettingsPreferencesLastProjectFile;
            
            // Create project class
            Project *openProject = [[Project alloc] init];
            NSDictionary *dictProject = [openProject readProject:stringProjectFile];
            
            // Application metadata
            stringProjectApplicationName = dictProject[@"ApplicationName"];
            stringProjectApplicationVersion = dictProject[@"ApplicationVersion"];
            
            // Project metadata
            stringProjectMetadataName = dictProject[@"ProjectMetadataName"];
            stringProjectMetadataIdentifier = dictProject[@"ProjectMetadataIdentifier"];
            stringProjectMetadataVersion = dictProject[@"ProjectMetadataVersion"];
            stringProjectMetadataShortVersion = dictProject[@"ProjectMetadataShortVersion"];
            stringProjectMetadataComparisonKey = dictProject[@"ProjectMetadataComparisonKey"];
            stringProjectMetadataType = dictProject[@"ProjectMetadataType"];
            stringProjectMetadataReceipt = dictProject[@"ProjectMetadataReceipt"];
            stringProjectMetadataInstall = dictProject[@"ProjectMetadataInstall"];
            stringProjectMetadataScripts = dictProject[@"ProjectMetadataScripts"];
            stringProjectMetadataOwner = dictProject[@"ProjectMetadataOwner"];
            stringProjectMetadataGroup = dictProject[@"ProjectMetadataGroup"];
            stringProjectMetadataPermissions = dictProject[@"ProjectMetadataPermissions"];
            stringProjectMetadataDevCert = dictProject[@"ProjectMetadataDevCert"];
            stringProjectMetadataDevId = dictProject[@"ProjectMetadataDevId"];
            stringProjectMetadataSource = dictProject[@"ProjectMetadataSource"];
            stringProjectMetadataTarget = dictProject[@"ProjectMetadataTarget"];
            stringProjectMetadataRunScripts = dictProject[@"ProjectMetadataRunScripts"];
            stringProjectMetadataIsSigned = dictProject[@"ProjectMetadataIsSigned"];
            stringProjectMetadataIsNotarized = dictProject[@"ProjectMetadataIsNotarized"];
            
            // Track project opened
            boolProjectOpened = YES;
            
            // Track project changes
            boolProjectChanged = NO;
            
            // Update application window title
            [self updateTitle];
            
            // Parse permissions
            NSString *stringTemp;
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(0, 1)];
            NSLog(@"Owner: %@", stringTemp);
            intPermissionsOwner = [stringTemp integerValue];
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(1, 1)];
            NSLog(@"Group: %@", stringTemp);
            intPermissionsGroup = [stringTemp integerValue];
            
            stringTemp = [stringProjectMetadataPermissions substringWithRange:NSMakeRange(2, 1)];
            NSLog(@"Everyone: %@", stringTemp);
            intPermissionsEveryone = [stringTemp integerValue];
            
            // Update last project file
            stringSettingsPreferencesLastProjectFile = stringProjectFile;
            
            // Save settings
            [self saveSettings];
            
            // Update controls
            [self setControls];
            
            // Update browser
            [self changeRoot];
            
            // Update status
            [self updateStatus:@"Project Opened"];
            
        }
        
        else {
            
            [Logger setLogEvent:@"Last profile file not found", nil];
            
            // Set controls
            [self setControls];
            
        }
        
    }
    
}

- (void)clearProject {
    
    // Clear variables
    stringProjectMetadataName = @"";
    stringProjectMetadataVersion = @"";
    stringProjectMetadataIdentifier = @"";
    stringProjectMetadataSource = @"";
    stringProjectMetadataTarget = @"";
    stringProjectMetadataOwner = @"";
    stringProjectMetadataGroup = @"";
    stringProjectMetadataPermissions = @"";
    stringProjectMetadataInstall = @"";
    stringProjectMetadataScripts = @"";
    stringProjectMetadataRunScripts = @"FALSE";
    stringProjectMetadataDevCert = @"";
    stringProjectMetadataIsSigned = @"";
    stringProjectMetadataIsNotarized = @"";
    
    intPermissionsOwner = 0;
    intPermissionsGroup = 0;
    intPermissionsEveryone = 0;
    
    [Logger setLogEvent:@"Clear project settings", nil];
    
}

- (void)buildPKG {
    
    // Update status
    [self updateStatus:@"Started Building PKG"];
    
    // Run thread in background
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        NSFileManager *fileManager;
        fileManager = [NSFileManager defaultManager];
        
        // Validate control values
        BOOL boolValidateControls = [self validateControls];
        
        if (boolValidateControls) {
            
            if ([fileManager fileExistsAtPath:self->stringProjectMetadataTarget] == YES) {
                
                // Set package type to pkg
                NSString *stringBuildType = @"pkg";
                
                // Get date and time
                NSDate *dateCurrent = [NSDate date];
                
                // Package file name
                NSString *stringPackageFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"FALSE" ProjectIsSigned:@"FALSE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // Signed package file name
                NSString *stringSignedPackageFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"FALSE" ProjectIsSigned:@"TRUE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // Plist file name
                NSString *stringPlistFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"TRUE" ProjectIsSigned:@"FALSE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // pkgbuild
                [BuildPackage pkgBuild:stringPackageFileName ProjectVersion:self->stringProjectMetadataVersion ProjectIdentifier:self->stringProjectMetadataIdentifier ProjectInstall:self->stringProjectMetadataInstall ProjectScripts:self->stringProjectMetadataScripts ProjectRunScripts:self->stringProjectMetadataRunScripts ProjectSource:self->stringProjectMetadataSource ProjectTarget:self->stringProjectMetadataTarget];
                
                // productsign
                [SignPackage productSign:stringSignedPackageFileName PackageFileName:stringPackageFileName BuildType:stringBuildType ProjectTarget:self->stringProjectMetadataTarget ProjectDevCert:self->stringProjectMetadataDevCert ProjectIsSigned:self->stringProjectMetadataIsSigned];
                
                // Create projectmanifest class
                ProjectManifest *projectManifest = [[ProjectManifest alloc] init];
                
                // Create projectmanifest array
                NSArray *arrayProjectManifest = [projectManifest getProjectManifest:self->stringProjectMetadataSource ProjectInstall:self->stringProjectMetadataInstall];
                
                // Get package payload size
                NSNumber *numberPayloadSize = [PayloadSize getFolderSize:arrayProjectManifest];
                
                NSNumber *numberPackageSize;
                NSString *stringPackageHash;
                NSString *stringOriginalPackageFileName;
                
                // Signed package size and shasum
                if ([self->stringProjectMetadataIsSigned isEqualToString:@"TRUE"]) {
                    
                    numberPackageSize = [FileSize getFileSize:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringPackageHash = [ShaSum getShaSum:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringOriginalPackageFileName = stringSignedPackageFileName;
                    
                }
                
                // Unsigned package size and shasum
                else if ([self->stringProjectMetadataIsSigned isEqualToString:@"FALSE"]) {
                    
                    numberPackageSize = [FileSize getFileSize:stringPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringPackageHash = [ShaSum getShaSum:stringPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringOriginalPackageFileName = stringPackageFileName;
                    
                }
                
                // Notarize
                BOOL boolValidateXcrun = [ValidateXcode validateXcrun];
                
                if (boolValidateXcrun) {
                    
                    BOOL boolValidateAltool = [ValidateXcode validateAltool];
                    
                    if (boolValidateAltool) {
                        
                        self->stringRequestUuid = [NotarizePackage notarizePackage:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget ProjectIdentifier:self->stringProjectMetadataIdentifier ProjectSize:numberPackageSize ProjectIsNotarized:self->stringProjectMetadataIsNotarized ProjectDevId:self->stringProjectMetadataDevId];
                        
                        [Logger setLogEvent:@"Request UUID: ", self->stringRequestUuid, nil];
                        
                    }
                    
                }
                
                // Generate plist
                [GeneratePlist writePlist:stringPlistFileName BuildType:stringBuildType CurrentDate:dateCurrent SettingsApplicationName:self->stringSettingsApplicationName SettingsApplicationVersion:self->stringSettingsApplicationVersion ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectShortVersion:self->stringProjectMetadataShortVersion ProjectComparisonKey:self->stringProjectMetadataComparisonKey ProjectIdentifier:self->stringProjectMetadataIdentifier ProjectOwner:self->stringProjectMetadataOwner ProjectGroup:self->stringProjectMetadataGroup ProjectPermissions:self->stringProjectMetadataPermissions ProjectType:self->stringProjectMetadataType ProjectReceipt:self->stringProjectMetadataReceipt ProjectInstall:self->stringProjectMetadataInstall ProjectSource:self->stringProjectMetadataSource ProjectTarget:self->stringProjectMetadataTarget ProjectManifest:arrayProjectManifest PayloadSize:(NSNumber *)numberPayloadSize PackageFileName:stringOriginalPackageFileName PackageSize:(NSNumber *)numberPackageSize PackageHash:stringPackageHash ProjectIsSigned:self->stringProjectMetadataIsSigned];
                
                // Generate staple script file
                if (self->stringRequestUuid.length) {
                    
                    [StaplePackage writeStapleScript:stringOriginalPackageFileName SettingsApplicationName:self->stringSettingsApplicationName SettingsApplicationVersion:self->stringSettingsApplicationVersion ProjectTarget:self->stringProjectMetadataTarget ProjectDevId:self->stringProjectMetadataDevId RequestUuid:self->stringRequestUuid];
                    
                }
                
                // Update status
                [self updateStatus:@"Finished Building PKG"];
                
                [Logger setLogEvent:@"Finished building PKG in: ", self->stringProjectMetadataTarget, nil];
                
            }
            
            else {
                
                // Load alert
                NSAlert *alertTarget = [[NSAlert alloc] init];
                
                [alertTarget setMessageText:@"Unable to Build PKG!"];
                [alertTarget setInformativeText:[NSString stringWithFormat:@"Cannot find: %@", self->stringProjectMetadataTarget]];
                [alertTarget setAlertStyle:NSCriticalAlertStyle];
                [alertTarget addButtonWithTitle:@"Ok"];
                
                NSInteger intButton = [alertTarget runModal];
                
                if (intButton == NSAlertFirstButtonReturn) {
                    
                    
                    
                }
                
                // Update status
                [self updateStatus:@"Failed Building PKG"];
                
                [Logger setLogEvent:@"Project target path doesn't exist - PKG not created", nil];
                
            }
            
        }
        
    });
    
}

- (void)buildDMG {
    
    // Update status
    [self updateStatus:@"Started Building DMG"];
    
    // Run thread in background
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        NSFileManager *fileManager;
        fileManager = [NSFileManager defaultManager];
        
        // Validate control values
        BOOL boolValidateControls = [self validateControls];
        
        if (boolValidateControls) {
            
            if ([fileManager fileExistsAtPath:self->stringProjectMetadataTarget] == YES) {
                
                // Set package type to dmg
                NSString *stringBuildType = @"dmg";
                
                // Get date and time
                NSDate *dateCurrent = [NSDate date];
                
                // Package file name
                NSString *stringPackageFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"FALSE" ProjectIsSigned:@"FALSE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // Signed package file name
                NSString *stringSignedPackageFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"FALSE" ProjectIsSigned:@"TRUE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // Plist file name
                NSString *stringPlistFileName = [FileName setFileName:stringBuildType CurrentDate:dateCurrent ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectType:self->stringProjectMetadataType ProjectIsPlist:@"TRUE" ProjectIsSigned:@"FALSE" VersionPackageName:self->stringSettingsPreferencesVersionPackageName VersionPlistName:self->stringSettingsPreferencesVersionPlistName DateTimePackageName:self->stringSettingsPreferencesDateTimePackageName DateTimePlistName:self->stringSettingsPreferencesDateTimePlistName PackageTypePlistName:self->stringSettingsPreferencesPackageTypePlistName];
                
                // hdiutil
                [BuildPackage hdiUtil:stringPackageFileName ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectSource:self->stringProjectMetadataSource ProjectTarget:self->stringProjectMetadataTarget];
                
                // productsign
                [SignPackage productSign:stringSignedPackageFileName PackageFileName:stringPackageFileName BuildType:stringBuildType ProjectTarget:self->stringProjectMetadataTarget ProjectDevCert:self->stringProjectMetadataDevCert ProjectIsSigned:self->stringProjectMetadataIsSigned];
                
                // Create projectmanifest class
                ProjectManifest *projectManifest = [[ProjectManifest alloc] init];
                
                // Create projectmanifest array
                NSArray *arrayProjectManifest = [projectManifest getProjectManifest:self->stringProjectMetadataSource ProjectInstall:self->stringProjectMetadataInstall];
                
                // Get package payload size
                NSNumber *numberPayloadSize = [PayloadSize getFolderSize:arrayProjectManifest];
                
                NSNumber *numberPackageSize;
                NSString *stringPackageHash;
                NSString *stringOriginalPackageFileName;
                
                // Signed package size and shasum
                if ([self->stringProjectMetadataIsSigned isEqualToString:@"TRUE"]) {
                    
                    numberPackageSize = [FileSize getFileSize:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringPackageHash = [ShaSum getShaSum:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringOriginalPackageFileName = stringSignedPackageFileName;
                    
                }
                
                // Unsigned package size and shasum
                else if ([self->stringProjectMetadataIsSigned isEqualToString:@"FALSE"]) {
                    
                    numberPackageSize = [FileSize getFileSize:stringPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringPackageHash = [ShaSum getShaSum:stringPackageFileName FilePath:self->stringProjectMetadataTarget];
                    stringOriginalPackageFileName = stringPackageFileName;
                    
                }
                
                // Notarize
                BOOL boolValidateXcrun = [ValidateXcode validateXcrun];
                
                if (boolValidateXcrun) {
                    
                    BOOL boolValidateAltool = [ValidateXcode validateAltool];
                    
                    if (boolValidateAltool) {
                        
                        self->stringRequestUuid = [NotarizePackage notarizePackage:stringSignedPackageFileName FilePath:self->stringProjectMetadataTarget ProjectIdentifier:self->stringProjectMetadataIdentifier ProjectSize:numberPackageSize ProjectIsNotarized:self->stringProjectMetadataIsNotarized ProjectDevId:self->stringProjectMetadataDevId];
                        
                        [Logger setLogEvent:@"Request UUID: ", self->stringRequestUuid, nil];
                        
                    }
                    
                }
                
                // Generate plist
                [GeneratePlist writePlist:stringPlistFileName BuildType:stringBuildType CurrentDate:dateCurrent SettingsApplicationName:self->stringSettingsApplicationName SettingsApplicationVersion:self->stringSettingsApplicationVersion ProjectName:self->stringProjectMetadataName ProjectVersion:self->stringProjectMetadataVersion ProjectShortVersion:self->stringProjectMetadataShortVersion ProjectComparisonKey:self->stringProjectMetadataComparisonKey ProjectIdentifier:self->stringProjectMetadataIdentifier ProjectOwner:self->stringProjectMetadataOwner ProjectGroup:self->stringProjectMetadataGroup ProjectPermissions:self->stringProjectMetadataPermissions ProjectType:self->stringProjectMetadataType ProjectReceipt:self->stringProjectMetadataReceipt ProjectInstall:self->stringProjectMetadataInstall ProjectSource:self->stringProjectMetadataSource ProjectTarget:self->stringProjectMetadataTarget ProjectManifest:arrayProjectManifest PayloadSize:(NSNumber *)numberPayloadSize PackageFileName:stringOriginalPackageFileName PackageSize:(NSNumber *)numberPackageSize PackageHash:stringPackageHash ProjectIsSigned:self->stringProjectMetadataIsSigned];
                
                // Generate staple script file
                if (self->stringRequestUuid.length) {
                    
                    [StaplePackage writeStapleScript:stringOriginalPackageFileName SettingsApplicationName:self->stringSettingsApplicationName SettingsApplicationVersion:self->stringSettingsApplicationVersion ProjectTarget:self->stringProjectMetadataTarget ProjectDevId:self->stringProjectMetadataDevId RequestUuid:self->stringRequestUuid];
                    
                }
                
                // Update status
                [self updateStatus:@"Finished Building DMG"];
                
                [Logger setLogEvent:@"Finished building DMG in: ", self->stringProjectMetadataTarget, nil];
                
            }
            
            else {
                
                // Load alert
                NSAlert *alertTarget = [[NSAlert alloc] init];
                
                [alertTarget setMessageText:@"Unable to Build DMG!"];
                [alertTarget setInformativeText:[NSString stringWithFormat:@"Cannot find: %@", self->stringProjectMetadataTarget]];
                [alertTarget setAlertStyle:NSCriticalAlertStyle];
                [alertTarget addButtonWithTitle:@"Ok"];
                
                NSInteger intButton = [alertTarget runModal];
                
                if (intButton == NSAlertFirstButtonReturn) {
                    
                    
                    
                }
                
                // Update status
                [self updateStatus:@"Failed Building DMG"];
                
                [Logger setLogEvent:@"Project target path doesn't exist - DMG not created", nil];
                
            }
            
        }
        
    });
    
}

- (void)extractPKG {
    
    // Load custom alert for extract PKG
    ExtractViewController *extractViewController = [[ExtractViewController alloc] init];
    NSDictionary *dictExtractPackage = [extractViewController viewExtract:@"pkg" ProjectSource:stringProjectMetadataSource];
    
    // Extract package attributes
    stringPackageSource = dictExtractPackage[@"PackageSource"];
    stringPackageTarget = dictExtractPackage[@"PackageTarget"];
    stringExpandMode = dictExtractPackage[@"ExpandMode"];
    
    // Validate package extract settings
    BOOL boolValidateExtract = [self validateExtract];
    
    if (boolValidateExtract) {
        
        // Update status
        [self updateStatus:@"Started Extracting PKG"];
        
        // Run thread in background
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            // Extract package
            [ExtractPackage extractPackage:@"pkg" PackageSource:self->stringPackageSource PackageTarget:self->stringPackageTarget ExpandMode:self->stringExpandMode];
            
            // Update status
            [self updateStatus:@"Finished Extracting PKG"];
            
            // Reload browser
            [self reloadBrowser];
            
            [Logger setLogEvent:@"Extracted package: ", self->stringPackageSource, nil];
            
        });
        
    }
    
    else {
        
        // Update status
        [self updateStatus:@"Failed Extracting PKG"];
        
        [Logger setLogEvent:@"Failed extracting package: ", stringPackageSource, nil];
        
    }
    
}

- (void)extractDMG {
    
    // Load custom alert for extract DMG
    ExtractViewController *extractViewController = [[ExtractViewController alloc] init];
    NSDictionary *dictExtractPackage = [extractViewController viewExtract:@"dmg" ProjectSource:stringProjectMetadataSource];
    
    // Extract package attributes
    stringPackageSource = dictExtractPackage[@"PackageSource"];
    stringPackageTarget = dictExtractPackage[@"PackageTarget"];
    stringExpandMode = dictExtractPackage[@"ExpandMode"];
    
    // Validate package extract settings
    BOOL boolValidateExtract = [self validateExtract];
    
    if (boolValidateExtract) {
        
        // Update status
        [self updateStatus:@"Started Extracting DMG"];
        
        // Run thread in background
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            // Extract package
            [ExtractPackage extractPackage:@"dmg" PackageSource:self->stringPackageSource PackageTarget:self->stringPackageTarget ExpandMode:self->stringExpandMode];
            
            // Update status
            [self updateStatus:@"Finished Extracting DMG"];
            
            // Reload browser
            [self reloadBrowser];
            
            [Logger setLogEvent:@"Extracted package: ", self->stringPackageSource, nil];
            
        });
        
    }
    
    else {
        
        // Update status
        [self updateStatus:@"Failed Extracting DMG"];
        
        [Logger setLogEvent:@"Failed extracting package: ", stringPackageSource, nil];
        
    }
    
}

- (BOOL)validateExtract {
    
    BOOL boolValidateExtract = YES;
    
    // Check for presence of settings file
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringPackageSource] == NO) {
        
        // Package source does not exist
        boolValidateExtract = NO;
        
    }
    
    if ([fileManager fileExistsAtPath:stringPackageTarget] == NO) {
        
        // Package target does not exist
        boolValidateExtract = NO;
        
    }
    
    if (!stringExpandMode.length) {
        
        // Expand mode not set
        boolValidateExtract = NO;
        
    }
    
    return boolValidateExtract;
    
}

- (void)browseInstall {
    
    // Browse for project install
    BrowsePath *projectInstall = [[BrowsePath alloc] init];
    stringProjectMetadataInstall = [projectInstall getPath:@"/"];
    
    // Handle project install browse cancel
    if (stringProjectMetadataInstall) {
        
        [self.textboxProjectInstallOutlet setStringValue:stringProjectMetadataInstall];
        [Logger setLogEvent:@"Project install: ", stringProjectMetadataInstall, nil];
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
        // Update status
        [self updateStatus:@"Install Changed"];
        
    }
    
    else {
        
        stringProjectMetadataInstall = self.textboxProjectInstallOutlet.stringValue;
        [Logger setLogEvent:@"Browse project install aborted", nil];
        
    }
    
}

- (void)browseScripts {
    
    // Browse for project scripts
    BrowsePath *projectScripts = [[BrowsePath alloc] init];
    stringProjectMetadataScripts = [projectScripts getPath:@"/"];
    
    // Handle project scripts browse cancel
    if (stringProjectMetadataScripts) {
        
        [self.textboxProjectScriptsOutlet setStringValue:stringProjectMetadataScripts];
        [Logger setLogEvent:@"Project scripts: ", stringProjectMetadataScripts, nil];
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
        // Update status
        [self updateStatus:@"Scripts Changed"];
        
    }
    
    else {
        
        stringProjectMetadataScripts = self.textboxProjectScriptsOutlet.stringValue;
        [Logger setLogEvent:@"Browse project scripts aborted", nil];
        
    }
    
}

- (void)browseSource {
    
    // Browse for project source
    BrowsePath *projectSource = [[BrowsePath alloc] init];
    stringProjectMetadataSource = [projectSource getPath:@"/"];
    
    // Handle project source browse cancel
    if (stringProjectMetadataSource) {
        
        [self.textboxProjectSourceOutlet setStringValue:stringProjectMetadataSource];
        [Logger setLogEvent:@"Project source: ", stringProjectMetadataSource, nil];
        
        // Update source browser
        [self changeRoot];
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
        // Update status
        [self updateStatus:@"Source Changed"];
        
    }
    
    else {
        
        stringProjectMetadataSource = self.textboxProjectSourceOutlet.stringValue;
        [Logger setLogEvent:@"Browse project source aborted", nil];
        
    }
    
}

- (void)browseTarget {
    
    // Browse for project target
    BrowsePath *projectTarget = [[BrowsePath alloc] init];
    stringProjectMetadataTarget = [projectTarget getPath:@"/"];
    
    // Handle project target browse cancel
    if (stringProjectMetadataTarget) {
        
        [self.textboxProjectTargetOutlet setStringValue:stringProjectMetadataTarget];
        [Logger setLogEvent:@"Project target: ", stringProjectMetadataTarget, nil];
        
        // Track project changes
        boolProjectChanged = YES;
        
        // Update application window title
        [self updateTitle];
        
    }
    
    else {
        
        stringProjectMetadataTarget = self.textboxProjectTargetOutlet.stringValue;
        [Logger setLogEvent:@"Browse project target aborted", nil];
        
    }
    
}

- (void)showHelp {
    
    // Display help page
    NSURL * urlHelpFile = [[NSBundle mainBundle] URLForResource:@"Help" withExtension:@"html"];
    [[NSWorkspace sharedWorkspace] openURL:urlHelpFile];
    
}

- (void)newFolder {
    
    // Find the clicked item and create new folder
    FileSystemNode *clickedNode = [self fileSystemNodeAtRow:self.browserSourceOutlet.clickedRow column:self.browserSourceOutlet.clickedColumn];
    FileSystemNode *parentNode = (FileSystemNode *)[self.browserSourceOutlet parentForItemsInColumn:self.browserSourceOutlet.clickedColumn];
    
    NSString *stringBasePath;
    
    if (parentNode != nil) {
        
        NSInteger intNodeColumn = self.browserSourceOutlet.lastColumn;

        if (parentNode.isDirectory) {
            
            NSLog(@"Clicked: %@", clickedNode.URL.path);
            NSLog(@"Parent: %@", parentNode.URL.path);
            
            // Node is directory
            stringBasePath = parentNode.URL.path;
            
            if ([parentNode.URL.path isEqualToString:clickedNode.URL.path]) {
             
                intNodeColumn = intNodeColumn - 1;
                
            }
            
        }
        
        else {

            // Remove file component from path
            stringBasePath = parentNode.URL.URLByDeletingLastPathComponent.path;
            
        }
        
        [Logger setLogEvent:@"Folder creation base path: ", stringBasePath, nil];
        
        NSString *stringFolder;
        
        NSAlert *alertNewFolder = [[NSAlert alloc] init];
        [alertNewFolder setMessageText:@"Create New Folder"];
        [alertNewFolder addButtonWithTitle:@"New Folder"];
        [alertNewFolder addButtonWithTitle:@"Cancel"];
        
        NSTextField *textboxFolder = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 296, 22)];
        [textboxFolder setStringValue:@""];
        
        [alertNewFolder setAccessoryView:textboxFolder];
        
        NSInteger intButton = [alertNewFolder runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            stringFolder = [textboxFolder stringValue];
            
            [Logger setLogEvent:@"New folder: ", stringFolder, nil];
            
            // Clean up root path
            if ([stringBasePath isEqualToString:@"/"]) {
                
                stringBasePath = @"";
                
            }
            
            NSString *stringFullPath = [NSString stringWithFormat:@"%@%@%@", stringBasePath, @"/", stringFolder];
            
            [Logger setLogEvent:@"Creating folder: ", stringFullPath, nil];
            
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:stringFullPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error != nil) {
                
                [Logger setLogEvent:@"Error creating directory: ", error, nil];
                
            }
            
            // Reload columns
            [self.rootNodeSource invalidateChildren];
            
            for (NSInteger intColumn = intNodeColumn; intColumn >= 0; intColumn--) {
                
                [self.browserSourceOutlet reloadColumn:intColumn];
                
            }
            
            // Bug fix for reloading browser
            NSString *stringBrowserPath = [self.browserSourceOutlet path];
            [self.browserSourceOutlet loadColumnZero];
            [self.browserSourceOutlet setPath:stringBrowserPath];
            
        }
        
        else if (intButton == NSAlertSecondButtonReturn) {
            
            [Logger setLogEvent:@"New folder: Cancelled - User initiated", nil];
            
        }
        
    }
    
}

- (void)renameItem {
    
    // Find the clicked item and rename
    FileSystemNode *clickedNode = [self fileSystemNodeAtRow:self.browserSourceOutlet.clickedRow column:self.browserSourceOutlet.clickedColumn];
    FileSystemNode *parentNode = (FileSystemNode *)[self.browserSourceOutlet parentForItemsInColumn:self.browserSourceOutlet.clickedColumn];
    
    NSLog(@"Clicked: %@", clickedNode.URL.path);
    NSLog(@"Parent: %@", parentNode.URL.path);
    
    if (parentNode != nil) {
        
        //NSInteger intNodeColumn = self.browserSourceOutlet.lastColumn;
        
        NSString *stringItemType;
        
        if ([parentNode.URL.path isEqualToString:clickedNode.URL.path]) {
            
            [Logger setLogEvent:@"Cannot rename this location", nil];
            
        }
        
        else {
            
            NSString *stringSourcePath = clickedNode.URL.path;
            NSString *stringSourceItem = clickedNode.URL.lastPathComponent;
            NSString *stringBasePath = clickedNode.URL.URLByDeletingLastPathComponent.path;
            
            if (clickedNode.isDirectory) {
                
                // Item is folder
                stringItemType = @"Folder";
                
            }
            
            else {
                
                // Item is file
                stringItemType = @"File";
                
            }
            
            [Logger setLogEvent:stringItemType, @" rename source: ", stringSourcePath, nil];
            
            NSString *stringTargetItem;
            
            NSAlert *alertRenameItem = [[NSAlert alloc] init];
            [alertRenameItem setMessageText:[NSString stringWithFormat:@"New %@ Name", stringItemType]];
            [alertRenameItem addButtonWithTitle:[NSString stringWithFormat:@"Rename %@", stringItemType]];
            [alertRenameItem addButtonWithTitle:@"Cancel"];
            
            NSTextField *textboxItem = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 296, 22)];
            [textboxItem setStringValue:stringSourceItem];
            
            [alertRenameItem setAccessoryView:textboxItem];
            
            NSInteger intButton = [alertRenameItem runModal];
            
            if (intButton == NSAlertFirstButtonReturn) {
                
                stringTargetItem = [textboxItem stringValue];
                
                [Logger setLogEvent:@"Target item: ", stringTargetItem, nil];
                
                // Clean up root path
                if ([stringBasePath isEqualToString:@"/"]) {
                    
                    stringBasePath = @"";
                    
                }
                
                NSString *stringTargetPath = [NSString stringWithFormat:@"%@%@%@", stringBasePath, @"/", stringTargetItem];
                
                [Logger setLogEvent:stringItemType, @" rename target: ", stringTargetPath, nil];
                
                NSError *error = nil;
                [[NSFileManager defaultManager] moveItemAtPath:stringSourcePath toPath:stringTargetPath error:&error];
                
                if (error != nil) {
                    
                    [Logger setLogEvent:@"Error renaming item: ", error, nil];
                    
                }
                
                [self reloadBrowser];
                
            }
            
            else if (intButton == NSAlertSecondButtonReturn) {
                
                [Logger setLogEvent:@"Rename item: Cancelled - User initiated", nil];
                
            }
            
        }
        
    }
    
}

- (void)deleteItem {
    
    // Find the clicked item and delete
    FileSystemNode *clickedNode = [self fileSystemNodeAtRow:self.browserSourceOutlet.clickedRow column:self.browserSourceOutlet.clickedColumn];
    FileSystemNode *parentNode = (FileSystemNode *)[self.browserSourceOutlet parentForItemsInColumn:self.browserSourceOutlet.clickedColumn];
    
    NSLog(@"Clicked: %@", clickedNode.URL.path);
    NSLog(@"Parent: %@", parentNode.URL.path);
    
    if (parentNode != nil) {
        
        //NSInteger intNodeColumn = self.browserSourceOutlet.lastColumn;
        
        NSString *stringItemType;
        
        if ([parentNode.URL.path isEqualToString:clickedNode.URL.path]) {
            
            [Logger setLogEvent:@"Cannot delete this location", nil];
            
        }
        
        else {
            
            NSString *stringSourcePath = clickedNode.URL.path;
            NSString *stringSourceItem = clickedNode.URL.lastPathComponent;
            
            if (clickedNode.isDirectory) {
                
                // Item is folder
                stringItemType = @"Folder";
                
            }
            
            else {
                
                // Item is file
                stringItemType = @"File";
                
            }
            
            [Logger setLogEvent:stringItemType, @" delete: ", stringSourcePath, nil];
            
            NSAlert *alertDeleteItem = [[NSAlert alloc] init];
            [alertDeleteItem setMessageText:[NSString stringWithFormat:@"Confirm %@ Delete", stringItemType]];
            [alertDeleteItem setInformativeText:stringSourceItem];
            [alertDeleteItem addButtonWithTitle:[NSString stringWithFormat:@"Delete %@", stringItemType]];
            [alertDeleteItem addButtonWithTitle:@"Cancel"];
            
            NSInteger intButton = [alertDeleteItem runModal];
            
            if (intButton == NSAlertFirstButtonReturn) {
                
                // Browser not playing nice with asynchronous item deletion
                /*
                
                NSURL *urlSourcePath = [NSURL fileURLWithPath:stringSourcePath];
                NSArray *arrayItems = [NSArray arrayWithObject:urlSourcePath];
                
                [[NSWorkspace sharedWorkspace] recycleURLs:arrayItems completionHandler:^(NSDictionary *newURLs, NSError *error) {
                    
                    if (error != nil) {
                        
                        // Error with deletion
                        [Logger setLogEvent:@"Error deleting item: ", error, nil];
                        
                    }
                    
                    for (NSString *stringFile in newURLs) {
                        
                        NSString *stringTrash = [newURLs objectForKey:stringFile];
                        
                        [Logger setLogEvent:@"Item ", stringFile, @"moved to ", stringTrash, nil];
                        
                    }
                    
                }];
                
                */
                
                NSURL *urlSourcePath = [NSURL fileURLWithPath:stringSourcePath];
                
                [Logger setLogEvent:@"Moving item to trash: ", stringSourcePath, nil];
                
                NSError *error = nil;
                
                [[[NSFileManager alloc] init] trashItemAtURL:urlSourcePath resultingItemURL:nil error:&error];
                
                if (error != nil) {
                    
                    [Logger setLogEvent:@"Error deleting item: ", error, nil];
                    
                }
                
                [self reloadBrowser];
                
            }
            
            else if (intButton == NSAlertSecondButtonReturn) {
                
                [Logger setLogEvent:@"Delete item: Cancelled - User initiated", nil];
                
            }
            
        }
        
    }
    
}

- (void)readUsers {
    
    // Clear all combobox items
    self.comboboxProjectOwnerOutlet.removeAllItems;
    
    // Create usergroup class
    UserGroup *readUsers = [[UserGroup alloc] init];
    NSArray *arrayUsers = [readUsers getUserGroup:@"user"];
    
    for (id idUser in arrayUsers) {
        
        [self.comboboxProjectOwnerOutlet addItemWithObjectValue:idUser];
        
    }
    
    [Logger setLogEvent:@"Reading users", nil];
    
}

- (void)readGroups {
    
    // Clear all combobox items
    self.comboboxProjectGroupOutlet.removeAllItems;
    
    // Create usergroup class
    UserGroup *readGroups = [[UserGroup alloc] init];
    NSArray *arrayGroups = [readGroups getUserGroup:@"group"];
    
    for (id idGroup in arrayGroups) {
        
        [self.comboboxProjectGroupOutlet addItemWithObjectValue:idGroup];
        
    }
    
    [Logger setLogEvent:@"Reading groups", nil];
    
}

- (void)readIdentities {
    
    // Clear all combobox items
    self.comboboxProjectDevCertOutlet.removeAllItems;
    
    // Create identities class
    Identities *readIdentities = [[Identities alloc] init];
    NSArray *arrayIdentities = [readIdentities getIdentities];
    
    for (id idIdentity in arrayIdentities) {
        
        [self.comboboxProjectDevCertOutlet addItemWithObjectValue:idIdentity];
        
    }
    
    [Logger setLogEvent:@"Reading identities", nil];
    
}

- (void)getControls {
    
    // Comboboxes
    stringProjectMetadataComparisonKey = [self.comboboxProjectComparisonKeyOutlet objectValueOfSelectedItem];
    stringProjectMetadataType = [self.comboboxProjectTypeOutlet objectValueOfSelectedItem];
    stringProjectMetadataReceipt = [self.comboboxProjectReceiptOutlet objectValueOfSelectedItem];
    stringProjectMetadataOwner = [self.comboboxProjectOwnerOutlet objectValueOfSelectedItem];
    stringProjectMetadataGroup = [self.comboboxProjectGroupOutlet objectValueOfSelectedItem];
    stringProjectMetadataDevCert = [self.comboboxProjectDevCertOutlet objectValueOfSelectedItem];
    
    // Textboxes
    stringProjectMetadataName = [self.textboxProjectNameOutlet stringValue];
    stringProjectMetadataIdentifier = [self.textboxProjectIdentifierOutlet stringValue];
    stringProjectMetadataVersion = [self.textboxProjectVersionOutlet stringValue];
    stringProjectMetadataShortVersion = [self.textboxProjectShortVersionOutlet stringValue];
    stringProjectMetadataInstall = [self.textboxProjectInstallOutlet stringValue];
    stringProjectMetadataScripts = [self.textboxProjectScriptsOutlet stringValue];
    stringProjectMetadataDevId = [self.textboxProjectDevIdOutlet stringValue];
    stringProjectMetadataSource = [self.textboxProjectSourceOutlet stringValue];
    stringProjectMetadataTarget = [self.textboxProjectTargetOutlet stringValue];
    
    // Reset permissions values
    intPermissionsOwner = 0;
    intPermissionsGroup = 0;
    intPermissionsEveryone = 0;
    
    // Checkboxes
    if ([self.checkboxProjectOwnerReadOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 4;
        
    }
    
    if ([self.checkboxProjectOwnerWriteOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 2;
        
    }
    
    if ([self.checkboxProjectOwnerExecuteOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 1;
        
    }
    
    if ([self.checkboxProjectGroupReadOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 4;
        
    }
    
    if ([self.checkboxProjectGroupWriteOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 2;
        
    }
    
    if ([self.checkboxProjectGroupExecuteOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 1;
        
    }
    
    if ([self.checkboxProjectEveryoneReadOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 4;
        
    }
    
    if ([self.checkboxProjectEveryoneWriteOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 2;
        
    }
    
    if ([self.checkboxProjectEveryoneExecuteOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 1;
        
    }
    
    if ([self.checkboxProjectRunScriptsOutlet state] == NSOnState) {
        
        stringProjectMetadataRunScripts = @"TRUE";
        
    }
    
    else {
        
        stringProjectMetadataRunScripts = @"FALSE";
        
    }
    
    if ([self.checkboxProjectIsSignedOutlet state] == NSOnState) {
        
        stringProjectMetadataIsSigned = @"TRUE";
        
    }
    
    else {
        
        stringProjectMetadataIsSigned = @"FALSE";
        
    }
    
    if ([self.checkboxProjectIsNotarizedOutlet state] == NSOnState) {
        
        stringProjectMetadataIsNotarized = @"TRUE";
        
    }
    
    else {
        
        stringProjectMetadataIsNotarized = @"FALSE";
        
    }
    
    NSString *stringTemp;
    
    stringTemp = [@(intPermissionsOwner) stringValue];
    NSLog(@"Owner: %@", stringTemp);
    
    stringTemp = [@(intPermissionsGroup) stringValue];
    NSLog(@"Group: %@", stringTemp);
    
    stringTemp = [@(intPermissionsEveryone) stringValue];
    NSLog(@"Everyone: %@", stringTemp);
    
    // Concatenate permissions
    stringProjectMetadataPermissions = [NSString stringWithFormat:@"%@%@%@", [@(intPermissionsOwner) stringValue], [@(intPermissionsGroup) stringValue], [@(intPermissionsEveryone) stringValue]];
    
    [Logger setLogEvent:@"Getting control values", nil];
    
}

- (void)setControls {
    
    // Comboboxes
    [self readUsers];
    [self readGroups];
    [self readIdentities];
    
    [self.comboboxProjectComparisonKeyOutlet selectItemWithObjectValue:stringProjectMetadataComparisonKey];
    [self.comboboxProjectTypeOutlet selectItemWithObjectValue:stringProjectMetadataType];
    [self.comboboxProjectReceiptOutlet selectItemWithObjectValue:stringProjectMetadataReceipt];
    [self.comboboxProjectOwnerOutlet selectItemWithObjectValue:stringProjectMetadataOwner];
    [self.comboboxProjectGroupOutlet selectItemWithObjectValue:stringProjectMetadataGroup];
    [self.comboboxProjectDevCertOutlet selectItemWithObjectValue:stringProjectMetadataDevCert];
    
    // Textboxes
    [self.textboxProjectNameOutlet setStringValue:stringProjectMetadataName];
    [self.textboxProjectIdentifierOutlet setStringValue:stringProjectMetadataIdentifier];
    [self.textboxProjectVersionOutlet setStringValue:stringProjectMetadataVersion];
    [self.textboxProjectShortVersionOutlet setStringValue:stringProjectMetadataShortVersion];
    [self.textboxProjectInstallOutlet setStringValue:stringProjectMetadataInstall];
    [self.textboxProjectScriptsOutlet setStringValue:stringProjectMetadataScripts];
    [self.textboxProjectDevIdOutlet setStringValue:stringProjectMetadataDevId];
    [self.textboxProjectSourceOutlet setStringValue:stringProjectMetadataSource];
    [self.textboxProjectTargetOutlet setStringValue:stringProjectMetadataTarget];
    
    // Owner checkboxes
    if (intPermissionsOwner >= 4) {
        
        [self.checkboxProjectOwnerReadOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 4;
        
    }
    
    else {
        
        [self.checkboxProjectOwnerReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 2) {
        
        [self.checkboxProjectOwnerWriteOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 2;
        
    }
    
    else {
        
        [self.checkboxProjectOwnerWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 1) {
        
        [self.checkboxProjectOwnerExecuteOutlet setState:NSOnState];
        //intPermissionsOwner = intPermissionsOwner - 1;
        
    }
    
    else {
        
        [self.checkboxProjectOwnerExecuteOutlet setState:NSOffState];
        
    }
    
    // Group checkboxes
    if (intPermissionsGroup >= 4) {
        
        [self.checkboxProjectGroupReadOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 4;
        
    }
    
    else {
        
        [self.checkboxProjectGroupReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 2) {
        
        [self.checkboxProjectGroupWriteOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 2;
        
    }
    
    else {
        
        [self.checkboxProjectGroupWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 1) {
        
        [self.checkboxProjectGroupExecuteOutlet setState:NSOnState];
        //intPermissionsGroup = intPermissionsGroup - 1;
        
    }
    
    else {
        
        [self.checkboxProjectGroupExecuteOutlet setState:NSOffState];
        
    }

    // Everyone checkboxes
    if (intPermissionsEveryone >= 4) {
        
        [self.checkboxProjectEveryoneReadOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 4;
        
    }
    
    else {
        
        [self.checkboxProjectEveryoneReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 2) {
        
        [self.checkboxProjectEveryoneWriteOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 2;
        
    }
    
    else {
        
        [self.checkboxProjectEveryoneWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 1) {
        
        [self.checkboxProjectEveryoneExecuteOutlet setState:NSOnState];
        //intPermissionsEveryone = intPermissionsEveryone - 1;
        
    }
    
    else {
        
        [self.checkboxProjectEveryoneExecuteOutlet setState:NSOffState];
        
    }
    
    // Project Run Scripts checkbox
    if ([stringProjectMetadataRunScripts isEqualToString:@"TRUE"]) {
        
        [self.checkboxProjectRunScriptsOutlet setState:NSOnState];
        
    }
    
    else {
        
        [self.checkboxProjectRunScriptsOutlet setState:NSOffState];
        
    }
    
    // Project Is Signed checkbox
    if ([stringProjectMetadataIsSigned isEqualToString:@"TRUE"]) {
        
        [self.checkboxProjectIsSignedOutlet setState:NSOnState];
        
    }
    
    else {
        
        [self.checkboxProjectIsSignedOutlet setState:NSOffState];
        
    }
    
    // Project Is Notarized checkbox
    if ([stringProjectMetadataIsNotarized isEqualToString:@"TRUE"]) {
        
        [self.checkboxProjectIsNotarizedOutlet setState:NSOnState];
        
    }
    
    else {
        
        [self.checkboxProjectIsNotarizedOutlet setState:NSOffState];
        
    }
    
    [Logger setLogEvent:@"Setting control values", nil];
    
}

- (BOOL)validateControls {
    
    // Read control values
    [self getControls];
    
    // Initialize variables
    BOOL boolValidated = 1;
    NSString *stringAlert;
    
    // Comboboxes
    if (stringProjectMetadataGroup.length) {
        
        if (!stringProjectMetadataOwner.length) {
        
            stringAlert = @"Owner";
            boolValidated = 0;
            
        }
        
    }
    
    //if (stringProjectOwner.length) {
        
        //if (!stringProjectGroup.length) {
            
            //stringAlert = @"Group";
            //boolValidated = 0;
            
        //}
        
    //}
    
    if ([stringProjectMetadataRunScripts isEqualToString:@"TRUE"]) {
        
        if (!stringProjectMetadataScripts.length) {
            
            stringAlert = @"Scripts";
            boolValidated = 0;
            
        }
        
    }
    
    if ([stringProjectMetadataIsNotarized isEqualToString:@"TRUE"]) {
        
        if (!stringProjectMetadataDevId.length) {
            
            stringAlert = @"Dev ID";
            boolValidated = 0;
            
        }
        
    }
    
    if ([stringProjectMetadataIsSigned isEqualToString:@"TRUE"]) {
        
        if (!stringProjectMetadataDevCert.length) {
            
            stringAlert = @"Dev Cert";
            boolValidated = 0;
            
        }
    
    }
    
    if (!stringProjectMetadataType.length) {
        
        stringAlert = @"Type";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataReceipt.length) {
        
        stringAlert = @"Receipt";
        boolValidated = 0;
        
    }
    
    // Textboxes
    if (!stringProjectMetadataTarget.length) {
        
        stringAlert = @"Target";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataSource.length) {
        
        stringAlert = @"Source";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataInstall.length) {
        
        stringAlert = @"Install";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataIdentifier.length) {
        
        stringAlert = @"Identifier";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataVersion.length) {
        
        stringAlert = @"Version";
        boolValidated = 0;
        
    }
    
    if (!stringProjectMetadataName.length) {
        
        stringAlert = @"Name";
        boolValidated = 0;
        
    }
    
    if (!boolValidated) {
        
        NSAlert *warningAlert = [[NSAlert alloc] init];
        warningAlert.messageText = @"Incomplete Project";
        warningAlert.informativeText = [NSString stringWithFormat:@"Please validate: %@", stringAlert];
        [warningAlert addButtonWithTitle:@"OK"];
        
        [warningAlert beginSheetModalForWindow:self.windowMainOutlet completionHandler:^(NSInteger result) {
            
        }];
        
    }
    
    [Logger setLogEvent:@"Validating control values", nil];
    
    return boolValidated;
    
}

- (void)changeRoot {
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringProjectMetadataSource] == YES) {
    
        _rootNodeSource = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:stringProjectMetadataSource]];
        [self.browserSourceOutlet loadColumnZero];
        
        [self reloadBrowser];
        
        [Logger setLogEvent:@"Setting browser root to: ", stringProjectMetadataSource, nil];
        
    }
    
    else {
        
        // Load alert
        NSAlert *alertSource = [[NSAlert alloc] init];
        
        [alertSource setMessageText:@"Cannot Open Project Source Path!"];
        [alertSource setInformativeText:[NSString stringWithFormat:@"Cannot find: %@", stringProjectMetadataSource]];
        [alertSource setAlertStyle:NSCriticalAlertStyle];
        [alertSource addButtonWithTitle:@"Ok"];
        
        NSInteger intButton = [alertSource runModal];
        
        if (intButton == NSAlertFirstButtonReturn) {
            
            
            
        }
        
        [Logger setLogEvent:@"Project source path doesn't exist - no change to root", nil];
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser required delegate methods

- (NSInteger)browser:(NSBrowser *)browserSourceOutlet numberOfChildrenOfItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return node.children.count;
    
}

- (id)browser:(NSBrowser *)browserSourceOutlet child:(NSInteger)index ofItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return (node.children)[index];
    
}

- (BOOL)browser:(NSBrowser *)browserSourceOutlet isLeafItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return !node.isDirectory || node.isPackage; // take into account packaged apps and documents
    
}

- (id)browser:(NSBrowser *)browserSourceOutlet objectValueForItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return node.displayName;
    
}

- (void)browser:(NSBrowser *)browserSourceOutlet willDisplayCell:(FileSystemBrowserCell *)cell atRow:(NSInteger)row column:(NSInteger)column {
    
    // Find the item and set the image.
    NSIndexPath *indexPath = [browserSourceOutlet indexPathForColumn:column];
    indexPath = [indexPath indexPathByAddingIndex:row];
    FileSystemNode *node = [browserSourceOutlet itemAtIndexPath:indexPath];
    cell.image = node.icon;
    cell.labelColor = node.labelColor;
    
}

- (NSViewController *)browser:(NSBrowser *)browserSourceOutlet previewViewControllerForLeafItem:(id)item {
    
    if (self.sharedPreviewControllerSource == nil) {
        
        _sharedPreviewControllerSource = [[PreviewViewController alloc] initWithNibName:@"PreviewView" bundle:[NSBundle bundleForClass:[self class]]];
        
    }
    
    return self.sharedPreviewControllerSource; // NSBrowser will set the representedObject for us
    
}

- (NSViewController *)browser:(NSBrowser *)browserSourceOutlet headerViewControllerForItem:(id)item {
    
    // Add a header for the first column, just as an example
    if (self.rootNodeSource == item) {
        
        return [[NSViewController alloc] initWithNibName:@"HeaderView" bundle:[NSBundle bundleForClass:[self class]]];
        
    }
    
    else {
        
        return nil;
        
    }
    
}

- (CGFloat)browser:(NSBrowser *)browserSourceOutlet shouldSizeColumn:(NSInteger)columnIndex forUserResize:(BOOL)forUserResize toWidth:(CGFloat)suggestedWidth  {
    
    if (!forUserResize) {
        
        id item = [browserSourceOutlet parentForItemsInColumn:columnIndex];
        
        if ([self browser:browserSourceOutlet isLeafItem:item]) {
            
            suggestedWidth = 200;
            
        }
        
    }
    
    return suggestedWidth;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser dragging Source

- (BOOL)browser:(NSBrowser *)browserSourceOutlet writeRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column toPasteboard:(NSPasteboard *)pasteboard {
    
    NSMutableArray *filenames = [NSMutableArray arrayWithCapacity:rowIndexes.count];
    NSIndexPath *baseIndexPath = [browserSourceOutlet indexPathForColumn:column];
    
    for (NSUInteger i = rowIndexes.firstIndex; i <= rowIndexes.lastIndex; i = [rowIndexes indexGreaterThanIndex:i]) {
        
        FileSystemNode *fileSystemNode = [browserSourceOutlet itemAtIndexPath:[baseIndexPath indexPathByAddingIndex:i]];
        [filenames addObject:(fileSystemNode.URL).path];
        
    }
    
    [pasteboard declareTypes:@[NSFilenamesPboardType] owner:self];
    [pasteboard setPropertyList:filenames forType:NSFilenamesPboardType];
    _draggedColumnIndexSource = column;
    return YES;
    
}

- (BOOL)browser:(NSBrowser *)browserSourceOutlet canDragRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column withEvent:(NSEvent *)event {
    
    // We will allow dragging any cell - even disabled ones. By default, NSBrowser will not let you drag a disabled cell
    return YES;
    
}

- (NSImage *)browser:(NSBrowser *)browserSourceOutlet draggingImageForRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset {
    
    NSImage *result = [browserSourceOutlet draggingImageForRowsWithIndexes:rowIndexes inColumn:column withEvent:event offset:dragImageOffset];
    
    // Create a custom drag image "badge" that displays the number of items being dragged
    if (rowIndexes.count > 1) {
        
        NSString *str = [NSString stringWithFormat:@"%ld items being dragged", (long)rowIndexes.count];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = NSMakeSize(0.5, 0.5);
        shadow.shadowBlurRadius = 5.0;
        shadow.shadowColor = [NSColor blackColor];
        
        NSDictionary *attrs = @{NSShadowAttributeName:shadow,
                                NSForegroundColorAttributeName:[NSColor whiteColor]};
        
        NSAttributedString *countString = [[NSAttributedString alloc] initWithString:str attributes:attrs];
        NSSize stringSize = [countString size];
        NSSize imageSize = result.size;
        imageSize.height += stringSize.height;
        imageSize.width = MAX(stringSize.width + 3, imageSize.width);
        
        NSImage *newResult = [[NSImage alloc] initWithSize:imageSize];
        
        [newResult lockFocus];
        
        [result drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        [countString drawAtPoint:NSMakePoint(0, imageSize.height - stringSize.height)];
        [newResult unlockFocus];
        
        dragImageOffset->y += (stringSize.height / 2.0);
        result = newResult;
        
    }
    
    return result;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser dragging Destination

- (FileSystemNode *)fileSystemNodeAtRow:(NSInteger)row column:(NSInteger)column {
    
    if (column >= 0) {
        
        NSIndexPath *indexPath = [self.browserSourceOutlet indexPathForColumn:column];
        
        if (row >= 0) {
            
            indexPath = [indexPath indexPathByAddingIndex:row];
            
        }
        
        id result = [self.browserSourceOutlet itemAtIndexPath:indexPath];
        return (FileSystemNode *)result;
        
    }
    
    else {
        
        return nil;
        
    }
    
}

- (NSDragOperation)browser:(NSBrowser *)browserSourceOutlet validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger *)row column:(NSInteger *)column dropOperation:(NSBrowserDropOperation *)dropOperation {
    
    NSDragOperation result = NSDragOperationNone;
    
    // We only accept file types
    if ([[info draggingPasteboard].types indexOfObject:NSFilenamesPboardType] > 0) {
        
        // For a between drop, we let the user drop "on" the parent item
        if (*dropOperation == NSBrowserDropAbove) {
            
            *row = -1;
            
        }
        
        // Only allow dropping in folders, but don't allow dragging from the same folder into itself, if we are the source
        if (*column != -1) {
            
            BOOL droppingFromSameFolder = ([info draggingSource] == browserSourceOutlet) && (*column == self.draggedColumnIndexSource);
            
            if (*row != -1) {
                
                // If we are dropping on a folder, then we will accept the drop at that row
                FileSystemNode *fileSystemNode = [self fileSystemNodeAtRow:*row column:*column];
                
                if (fileSystemNode.isDirectory) {
                    
                    // Yup, a good drop
                    result = NSDragOperationEvery;
                    
                }
                
                else {
                    
                    // Nope, we can't drop onto a file! We will retarget to the column, if it isn't the same folder.
                    if (!droppingFromSameFolder) {
                        
                        result = NSDragOperationEvery;
                        *row = -1;
                        *dropOperation = NSBrowserDropOn;
                        
                    }
                    
                }
                
            }
            
            else if (!droppingFromSameFolder) {
                
                result = NSDragOperationEvery;
                *row = -1;
                *dropOperation = NSBrowserDropOn;
                
            }
            
        }
        
    }
    
    return result;
    
}

- (BOOL)browser:(NSBrowser *)browserSourceOutlet acceptDrop:(id <NSDraggingInfo>)info atRow:(NSInteger)row column:(NSInteger)column dropOperation:(NSBrowserDropOperation)dropOperation {
    
    NSArray *filenames = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    // Find the target folder
    FileSystemNode *targetFileSystemNode = nil;
    
    if ((column != -1) && (filenames != nil)) {
        
        if (row != -1) {
            
            FileSystemNode *fileSystemNode = [self fileSystemNodeAtRow:row column:column];
            
            if (fileSystemNode.isDirectory) {
                
                targetFileSystemNode = fileSystemNode;
                
            }
            
        }
        
        else {
            
            // Grab the parent for the column, which should be a directory
            targetFileSystemNode = (FileSystemNode *)[browserSourceOutlet parentForItemsInColumn:column];
            
        }
        
    }
    
    // We now have the target folder, so move things around
    if (targetFileSystemNode != nil) {
        
        NSString *targetFolder = targetFileSystemNode.URL.path;
        NSMutableString *prettyNames = nil;
        
        // Create a display name of all the selected filenames that are moving
        for (NSUInteger i = 0; i < filenames.count; i++) {
            
            NSString *filename = [[NSFileManager defaultManager] displayNameAtPath:filenames[i]];
            
            if (prettyNames == nil) {
                
                prettyNames = [filename mutableCopy];
                
            }
            
            else {
                
                [prettyNames appendString:@", "];
                [prettyNames appendString:filename];
                
            }
            
        }
        
        // Ask the user if they really want to move those files
        //NSAlert *warningAlert = [[NSAlert alloc] init];
        //warningAlert.messageText = @"Verify file move";
        //warningAlert.informativeText = [NSString stringWithFormat:@"Are you sure you want to move '%@' to '%@'?", prettyNames, targetFolder];
        //[warningAlert addButtonWithTitle:@"Yes"];
        //[warningAlert addButtonWithTitle:@"No"];
        
        //[warningAlert beginSheetModalForWindow:self.windowMainOutlet completionHandler:^(NSInteger result) {
            
            //if (result == NSAlertFirstButtonReturn) {
                
                // Do the actual moving of the files.
                for (NSUInteger i = 0; i < filenames.count; i++) {
                    
                    NSString *filename = filenames[i];
                    NSString *targetPath = [targetFolder stringByAppendingPathComponent:filename.lastPathComponent];
                    
                    // Normally, you should check the result of movePath to see if it worked or not.
                    NSError *error = nil;
                    
                    //if (![[NSFileManager defaultManager] moveItemAtPath:filename toPath:targetPath error:&error] && error) {
                    if (![[NSFileManager defaultManager] copyItemAtPath:filename toPath:targetPath error:&error] && error) {
                        
                        [NSApp presentError:error];
                        break;
                        
                    }
                    
                }
        
                // It would be more efficient to invalidate the children of the "from" and "to" nodes and then
                // call -reloadColumn: on each of the corresponding columns. However, we just reload every column
                //
                //[self.rootNodeSource invalidateChildren];
                
                //for (NSInteger col = self.browserSourceOutlet.lastColumn; col >= 0; col--) {
                    
                    //[self.browserSourceOutlet reloadColumn:col];
                    
                //}
        
                // Bug fix for reloading browser
                //NSString *stringBrowserPath = [self.browserSourceOutlet path];
                //[self.browserSourceOutlet loadColumnZero];
                //[self.browserSourceOutlet setPath:stringBrowserPath];
        
                [self reloadBrowser];
        
            //}
            
        //}];
        
        //return YES;
        
    }
    
    //return NO;
    return YES;
    
}

- (void)reloadBrowser {
    
    // Reload columns
    [self.rootNodeSource invalidateChildren];
    
    for (NSInteger intColumn = self.browserSourceOutlet.lastColumn; intColumn >= 0; intColumn--) {
        
        [self.browserSourceOutlet reloadColumn:intColumn];
        
    }
    
    // Bug fix for reloading browser
    NSString *stringBrowserPath = [self.browserSourceOutlet path];
    [self.browserSourceOutlet loadColumnZero];
    [self.browserSourceOutlet setPath:stringBrowserPath];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser action

- (void)browserDoubleClick:(id)sender {
    
    // Find the clicked item and open it in Finder
    FileSystemNode *clickedNode = [self fileSystemNodeAtRow:self.browserSourceOutlet.clickedRow column:self.browserSourceOutlet.clickedColumn];
    
    if (clickedNode != nil) {
        
        [[NSWorkspace sharedWorkspace] openFile:clickedNode.URL.path];
        
    }
    
}

@end
