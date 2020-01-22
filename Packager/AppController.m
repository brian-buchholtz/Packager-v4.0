//
//  AppController.m
//  Packager
//
//  Created by Brian Buchholtz on 11/7/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import "AppController.h"
#import "FilePicker.h"
#import "SaveAs.h"
#import "Project.h"
#import "BrowsePath.h"
#import "UserGroup.h"
#import "Identities.h"
#import "FileSystemNode.h"
#import "FileSystemBrowserCell.h"
#import "PreviewViewController.h"
#import "BuildPackage.h"
#import "SignPackage.h"
#import "PayloadSize.h"
#import "FileSize.h"
#import "ShaSum.h"
#import "GeneratePlist.h"
#import "Logger.h"

@interface AppController ()

@end

@implementation AppController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main application initialization

- (void) applicationWillFinishLaunching: (NSNotification *) not {
    
    // Set application metadata
    stringApplicationName = @"VMware Packager";
    stringApplicationVersion = @"2.6";
    
    // Settings path and file
    NSURL *urlSettingsPath = [[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent];
    NSString *stringSettingsPath = urlSettingsPath.path;
    stringSettingsFile = [NSString stringWithFormat:@"%@/%@", stringSettingsPath, @"Packager.settings"];
    
    // Update application window title
    NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, @"(Empty Project)"];
    [self.windowMainOutlet setTitle:stringApplicationTitle];
    
    // Load comboboxes
    [self readUsers];
    [self readGroups];
    [self readIdentities];
    
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
    
    // Add right click support
    // Create new folder
    
}

- (id)rootItemForBrowser:(NSBrowser *)browserSourceOutlet {
    
    if (self.rootNodeSource == nil) {
        
        _rootNodeSource = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:NSOpenStepRootDirectory()]];
        
    }
    
    return self.rootNodeSource;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Menu

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

- (IBAction)menuShowHelp:(id)sender {
    
    // Display help page
    NSURL * urlHelpFile = [[NSBundle mainBundle] URLForResource:@"Help" withExtension:@"html"];
    [[NSWorkspace sharedWorkspace] openURL:urlHelpFile];
    
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

- (IBAction)buttonBrowseRootAction:(NSButton *)sender {
    
    // Browse project root
    [self browseRoot];
    
}

- (IBAction)buttonBrowseSourceAction:(NSButton *)sender {
    
    // Browse project source
    [self browseSource];
    
}

- (IBAction)buttonBrowseTargetAction:(NSButton *)sender {
    
    // Browse project target
    [self browseTarget];
    
}

- (IBAction)comboboxOwnerAction:(NSComboBox *)sender {
    
    // Not yet implemented
    
}

- (IBAction)comboboxGroupAction:(NSComboBox *)sender {
    
    // Not yet implemented
    
}

- (IBAction)comboboxSignAction:(NSComboBox *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerReadAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerWriteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerExecuteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupReadAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupWriteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupExecuteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneReadAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneWriteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneExecuteAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxProjectIsSignedAction:(NSButton *)sender {
    
    // Not yet implemented
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions

- (void)newProject {
    
    // Browse for new project file
    SaveAs *newFile = [[SaveAs alloc] init];
    NSString *stringNewFile = [newFile newFile];
    
    if (stringNewFile) {
        
        stringProjectFile = stringNewFile;
        
        // Update application window title
        NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, stringProjectFile];
        [self.windowMainOutlet setTitle:stringApplicationTitle];
        
        [Logger setLogEvent:@"New file open successful", nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"New file open aborted", nil];
        
    }
    
}

- (void)openProject {
    
    // Browse for existing project file
    FilePicker *pickFile = [[FilePicker alloc] init];
    stringProjectFile = [pickFile getFile];
    
    if (stringProjectFile) {
        
        // Create project class
        Project *openProject = [[Project alloc] init];
        NSDictionary *dictProject = [openProject readProject:stringProjectFile];
        
        // Application metadata
        stringProjectApplicationName = dictProject[@"ApplicationName"];
        stringProjectApplicationVersion = dictProject[@"ApplicationVersion"];
        
        // Project metadata
        stringProjectName = dictProject[@"ProjectName"];
        stringProjectVersion = dictProject[@"ProjectVersion"];
        stringProjectIdentifier = dictProject[@"ProjectIdentifier"];
        stringProjectRoot = dictProject[@"ProjectRoot"];
        stringProjectSource = dictProject[@"ProjectSource"];
        stringProjectTarget = dictProject[@"ProjectTarget"];
        stringProjectSign = dictProject[@"ProjectSign"];
        stringProjectIsSigned = dictProject[@"ProjectIsSigned"];
        stringProjectOwner = dictProject[@"ProjectOwner"];
        stringProjectGroup = dictProject[@"ProjectGroup"];
        stringProjectPermissions = dictProject[@"ProjectPermissions"];
        
        // Update application window title
        NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, stringProjectFile];
        [self.windowMainOutlet setTitle:stringApplicationTitle];
        
        // Parse permissions
        NSString *stringTemp;
        
        stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(0, 1)];
        NSLog(@"Owner: %@", stringTemp);
        intPermissionsOwner = [stringTemp integerValue];
        
        stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(1, 1)];
        NSLog(@"Group: %@", stringTemp);
        intPermissionsGroup = [stringTemp integerValue];
        
        stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(2, 1)];
        NSLog(@"Everyone: %@", stringTemp);
        intPermissionsEveryone = [stringTemp integerValue];
        
        // Update controls
        [self setControls];
        
        // Update browser
        [self changeRoot];
        
        [Logger setLogEvent:@"Existing file open successful", nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Existing file open aborted", nil];
        
    }
    
}

- (void)saveProject {
    
    // Verify open project
    if (stringProjectFile) {
        
        // Read control values
        [self getControls];
        
        // Write project file
        [Project writeProject:stringProjectFile ApplicationName:stringApplicationName ApplicationVersion:stringApplicationVersion ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectIdentifier:stringProjectIdentifier ProjectRoot:stringProjectRoot ProjectSource:stringProjectSource ProjectTarget:stringProjectTarget ProjectSign:stringProjectSign ProjectIsSigned:stringProjectIsSigned ProjectOwner:stringProjectOwner ProjectGroup:stringProjectGroup ProjectPermissions:stringProjectPermissions];
        
    }
    
    else {
        
        // Add alert
        [Logger setLogEvent:@"Saving project file: Cancelled - Empty Project", nil];
        
    }
    
}

- (void)buildPKG {
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    // Validate control values
    BOOL boolValidateControls = [self validateControls];
    
    if (boolValidateControls) {
    
        if ([fileManager fileExistsAtPath:stringProjectTarget] == YES) {
            
            // pkgbuild
            [BuildPackage pkgBuild:@"pkg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectIdentifier:stringProjectIdentifier ProjectRoot:stringProjectRoot ProjectSource:stringProjectSource ProjectTarget:stringProjectTarget];
            
            // productsign
            [SignPackage productSign:@"pkg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectSign:stringProjectSign ProjectIsSigned:stringProjectIsSigned];
            
            // Get package payload size
            NSNumber *numberPayloadSize = [PayloadSize getFolderSize:stringProjectSource];
        
            // Get package file size
            NSNumber *numberPackageSize = [FileSize getFileSize:@"pkg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectIsSigned:stringProjectIsSigned];
            
            // Generate shasum
            NSString *stringPackageHash = [ShaSum getShaSum:@"pkg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectIsSigned:stringProjectIsSigned];
            
            // Generate plist
            [GeneratePlist writePlist:@"pkg" ApplicationName:stringApplicationName ApplicationVersion:stringApplicationVersion ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectIdentifier:stringProjectIdentifier ProjectOwner:stringProjectOwner ProjectGroup:stringProjectGroup ProjectPermissions:stringProjectPermissions ProjectRoot:stringProjectRoot ProjectSource:stringProjectSource ProjectTarget:stringProjectTarget PayloadSize:numberPayloadSize PackageSize:numberPackageSize PackageHash:stringPackageHash ProjectIsSigned:stringProjectIsSigned];
            
            [Logger setLogEvent:@"Building package in: ", stringProjectTarget, nil];
            
        }
        
        else {
            
            // Add alert for project target
        
            [Logger setLogEvent:@"Project target path doesn't exist - PKG not created", nil];
        
        }
        
    }
    
}

- (void)buildDMG {
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    // Validate control values
    BOOL boolValidateControls = [self validateControls];
    
    if (boolValidateControls) {
        
        if ([fileManager fileExistsAtPath:stringProjectTarget] == YES) {
            
            // hdiutil
            [BuildPackage hdiUtil:@"dmg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectSource:stringProjectSource ProjectTarget:stringProjectTarget];
            
            // productsign
            [SignPackage productSign:@"dmg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectSign:stringProjectSign ProjectIsSigned:stringProjectIsSigned];
            
            // Get package payload size
            NSNumber *numberPayloadSize = [PayloadSize getFolderSize:stringProjectSource];
            
            // Get package file size
            NSNumber *numberPackageSize = [FileSize getFileSize:@"dmg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectIsSigned:stringProjectIsSigned];
            
            // Generate shasum
            NSString *stringPackageHash = [ShaSum getShaSum:@"dmg" ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectTarget:stringProjectTarget ProjectIsSigned:stringProjectIsSigned];
            
            // Generate plist
            [GeneratePlist writePlist:@"dmg" ApplicationName:stringApplicationName ApplicationVersion:stringApplicationVersion ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectIdentifier:stringProjectIdentifier ProjectOwner:stringProjectOwner ProjectGroup:stringProjectGroup ProjectPermissions:stringProjectPermissions ProjectRoot:stringProjectRoot ProjectSource:stringProjectSource ProjectTarget:stringProjectTarget PayloadSize:numberPayloadSize PackageSize:numberPackageSize PackageHash:stringPackageHash ProjectIsSigned:stringProjectIsSigned];
            
            [Logger setLogEvent:@"Building package in: ", stringProjectTarget, nil];
            
        }
        
        else {
            
            // Add alert for project target
            
            [Logger setLogEvent:@"Project target path doesn't exist - DMG not created", nil];
        
        }
        
    }
    
}

- (void)browseRoot {
    
    // Browse for project root
    BrowsePath *projectRoot = [[BrowsePath alloc] init];
    stringProjectRoot = [projectRoot getPath];
    
    // Handle project root browse cancel
    if (stringProjectRoot) {
        
        [self.textboxRootOutlet setStringValue:stringProjectRoot];
        [Logger setLogEvent:@"Project root: ", stringProjectRoot, nil];
        
    }
    
    else {
        
        stringProjectRoot = self.textboxRootOutlet.stringValue;
        [Logger setLogEvent:@"Browse project root aborted", nil];
        
    }
    
}

- (void)browseSource {
    
    // Browse for project source
    BrowsePath *projectSource = [[BrowsePath alloc] init];
    stringProjectSource = [projectSource getPath];
    
    // Handle project source browse cancel
    if (stringProjectSource) {
        
        [self.textboxSourceOutlet setStringValue:stringProjectSource];
        [Logger setLogEvent:@"Project source: ", stringProjectSource, nil];
        
        // Update source browser
        [self changeRoot];
        
    }
    
    else {
        
        stringProjectSource = self.textboxSourceOutlet.stringValue;
        [Logger setLogEvent:@"Browse project source aborted", nil];
        
    }
    
}

- (void)browseTarget {
    
    // Browse for project target
    BrowsePath *projectTarget = [[BrowsePath alloc] init];
    stringProjectTarget = [projectTarget getPath];
    
    // Handle project target browse cancel
    if (stringProjectTarget) {
        
        [self.textboxTargetOutlet setStringValue:stringProjectTarget];
        [Logger setLogEvent:@"Project target: ", stringProjectTarget, nil];
        
    }
    
    else {
        
        stringProjectTarget = self.textboxTargetOutlet.stringValue;
        [Logger setLogEvent:@"Browse project target aborted", nil];
        
    }
    
}

- (void)readUsers {
    
    // Create usergroup class
    UserGroup *readUsers = [[UserGroup alloc] init];
    NSArray *arrayUsers = [readUsers getUserGroup:@"user"];
    
    for (id idUser in arrayUsers) {
        
        [self.comboboxOwnerOutlet addItemWithObjectValue:idUser];
        
    }
    
    [Logger setLogEvent:@"Reading users", nil];
    
}

- (void)readGroups {
    
    // Create usergroup class
    UserGroup *readGroups = [[UserGroup alloc] init];
    NSArray *arrayGroups = [readGroups getUserGroup:@"group"];
    
    for (id idGroup in arrayGroups) {
        
        [self.comboboxGroupOutlet addItemWithObjectValue:idGroup];
        
    }
    
    [Logger setLogEvent:@"Reading groups", nil];
    
}

- (void)readIdentities {
    
    // Create identities class
    Identities *readIdentities = [[Identities alloc] init];
    NSArray *arrayIdentities = [readIdentities getIdentities];
    
    for (id idIdentity in arrayIdentities) {
        
        [self.comboboxSignOutlet addItemWithObjectValue:idIdentity];
        
    }
    
    [Logger setLogEvent:@"Reading identities", nil];
    
}

- (void)getControls {
    
    // Textboxes
    stringProjectName = [self.textboxNameOutlet stringValue];
    stringProjectVersion = [self.textboxVersionOutlet stringValue];
    stringProjectIdentifier = [self.textboxIdentifierOutlet stringValue];
    stringProjectRoot = [self.textboxRootOutlet stringValue];
    stringProjectSource = [self.textboxSourceOutlet stringValue];
    stringProjectTarget = [self.textboxTargetOutlet stringValue];
    
    // Comboboxes
    stringProjectOwner = [self.comboboxOwnerOutlet objectValueOfSelectedItem];
    stringProjectGroup = [self.comboboxGroupOutlet objectValueOfSelectedItem];
    stringProjectSign = [self.comboboxSignOutlet objectValueOfSelectedItem];
    
    // Reset permissions values
    intPermissionsOwner = 0;
    intPermissionsGroup = 0;
    intPermissionsEveryone = 0;
    
    // Checkboxes
    if ([self.checkboxOwnerReadOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 4;
        
    }
    
    if ([self.checkboxOwnerWriteOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 2;
        
    }
    
    if ([self.checkboxOwnerExecuteOutlet state] == NSOnState) {
        
        intPermissionsOwner = intPermissionsOwner + 1;
        
    }
    
    if ([self.checkboxGroupReadOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 4;
        
    }
    
    if ([self.checkboxGroupWriteOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 2;
        
    }
    
    if ([self.checkboxGroupExecuteOutlet state] == NSOnState) {
        
        intPermissionsGroup = intPermissionsGroup + 1;
        
    }
    
    if ([self.checkboxEveryoneReadOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 4;
        
    }
    
    if ([self.checkboxEveryoneWriteOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 2;
        
    }
    
    if ([self.checkboxEveryoneExecuteOutlet state] == NSOnState) {
        
        intPermissionsEveryone = intPermissionsEveryone + 1;
        
    }
    
    if ([self.checkboxProjectIsSignedOutlet state] == NSOnState) {
        
        stringProjectIsSigned = @"TRUE";
        
    }
    
    else {
        
        stringProjectIsSigned = @"FALSE";
        
    }
    
    NSString *stringTemp;
    
    stringTemp = [@(intPermissionsOwner) stringValue];
    NSLog(@"Owner: %@", stringTemp);
    
    stringTemp = [@(intPermissionsGroup) stringValue];
    NSLog(@"Group: %@", stringTemp);
    
    stringTemp = [@(intPermissionsEveryone) stringValue];
    NSLog(@"Everyone: %@", stringTemp);
    
    // Concatenate permissions
    stringProjectPermissions = [NSString stringWithFormat:@"%@%@%@", [@(intPermissionsOwner) stringValue], [@(intPermissionsGroup) stringValue], [@(intPermissionsEveryone) stringValue]];
    
    [Logger setLogEvent:@"Getting control values", nil];
    
}

- (void)setControls {
    
    // Textboxes
    [self.textboxNameOutlet setStringValue:stringProjectName];
    [self.textboxVersionOutlet setStringValue:stringProjectVersion];
    [self.textboxIdentifierOutlet setStringValue:stringProjectIdentifier];
    [self.textboxRootOutlet setStringValue:stringProjectRoot];
    [self.textboxSourceOutlet setStringValue:stringProjectSource];
    [self.textboxTargetOutlet setStringValue:stringProjectTarget];
    
    // Comboboxes
    [self.comboboxOwnerOutlet selectItemWithObjectValue:stringProjectOwner];
    [self.comboboxGroupOutlet selectItemWithObjectValue:stringProjectGroup];
    [self.comboboxSignOutlet selectItemWithObjectValue:stringProjectSign];
    
    // Owner checkboxes
    if (intPermissionsOwner >= 4) {
        
        [self.checkboxOwnerReadOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 4;
        
    }
    
    else {
        
        [self.checkboxOwnerReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 2) {
        
        [self.checkboxOwnerWriteOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 2;
        
    }
    
    else {
        
        [self.checkboxOwnerWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 1) {
        
        [self.checkboxOwnerExecuteOutlet setState:NSOnState];
        //intPermissionsOwner = intPermissionsOwner - 1;
        
    }
    
    else {
        
        [self.checkboxOwnerExecuteOutlet setState:NSOffState];
        
    }
    
    // Group checkboxes
    if (intPermissionsGroup >= 4) {
        
        [self.checkboxGroupReadOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 4;
        
    }
    
    else {
        
        [self.checkboxGroupReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 2) {
        
        [self.checkboxGroupWriteOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 2;
        
    }
    
    else {
        
        [self.checkboxGroupWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 1) {
        
        [self.checkboxGroupExecuteOutlet setState:NSOnState];
        //intPermissionsGroup = intPermissionsGroup - 1;
        
    }
    
    else {
        
        [self.checkboxGroupExecuteOutlet setState:NSOffState];
        
    }

    // Everyone checkboxes
    if (intPermissionsEveryone >= 4) {
        
        [self.checkboxEveryoneReadOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 4;
        
    }
    
    else {
        
        [self.checkboxEveryoneReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 2) {
        
        [self.checkboxEveryoneWriteOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 2;
        
    }
    
    else {
        
        [self.checkboxEveryoneWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 1) {
        
        [self.checkboxEveryoneExecuteOutlet setState:NSOnState];
        //intPermissionsEveryone = intPermissionsEveryone - 1;
        
    }
    
    else {
        
        [self.checkboxEveryoneExecuteOutlet setState:NSOffState];
        
    }
    
    // Project Is Signed checkbox
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        [self.checkboxProjectIsSignedOutlet setState:NSOnState];
        
    }
    
    else {
        
        [self.checkboxProjectIsSignedOutlet setState:NSOffState];
        
    }
    
    [Logger setLogEvent:@"Setting control values", nil];
    
}

- (BOOL)validateControls {
    
    // Read control values
    [self getControls];
    
    // Initialize variables
    BOOL boolValidated = 1;
    NSString *stringAlert;
    
    // IsSigned
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        if (!stringProjectSign.length) {
            
            stringAlert = @"Sign";
            boolValidated = 0;
            
        }
    
    }
    
    // Textboxes
    if (!stringProjectTarget.length) {
        
        stringAlert = @"Target";
        boolValidated = 0;
        
    }
    
    if (!stringProjectSource.length) {
        
        stringAlert = @"Source";
        boolValidated = 0;
        
    }
    
    if (!stringProjectRoot.length) {
        
        stringAlert = @"Root";
        boolValidated = 0;
        
    }
    
    if (!stringProjectIdentifier.length) {
        
        stringAlert = @"Identifier";
        boolValidated = 0;
        
    }
    
    if (!stringProjectVersion.length) {
        
        stringAlert = @"Version";
        boolValidated = 0;
        
    }
    
    if (!stringProjectName.length) {
        
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
    
    if ([fileManager fileExistsAtPath:stringProjectSource ] == YES) {
    
        _rootNodeSource = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:stringProjectSource]];
        [self.browserSourceOutlet loadColumnZero];
        
        [Logger setLogEvent:@"Setting browser root to: ", stringProjectSource, nil];
        
    }
    
    else {
        
        // Add alert for project source
        
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
        
        NSDictionary *attrs = @{NSShadowAttributeName: shadow,
                                NSForegroundColorAttributeName: [NSColor whiteColor]};
        
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
        NSAlert *warningAlert = [[NSAlert alloc] init];
        warningAlert.messageText = @"Verify file move";
        warningAlert.informativeText = [NSString stringWithFormat:@"Are you sure you want to move '%@' to '%@'?", prettyNames, targetFolder];
        [warningAlert addButtonWithTitle:@"Yes"];
        [warningAlert addButtonWithTitle:@"No"];
        
        [warningAlert beginSheetModalForWindow:self.windowMainOutlet completionHandler:^(NSInteger result) {
            
            if (result == NSAlertFirstButtonReturn) {
                
                // Do the actual moving of the files.
                for (NSUInteger i = 0; i < filenames.count; i++) {
                    
                    NSString *filename = filenames[i];
                    NSString *targetPath = [targetFolder stringByAppendingPathComponent:filename.lastPathComponent];
                    
                    // Normally, you should check the result of movePath to see if it worked or not.
                    NSError *error = nil;
                    
                    if (![[NSFileManager defaultManager] moveItemAtPath:filename toPath:targetPath error:&error] && error) {
                        
                        [NSApp presentError:error];
                        break;
                        
                    }
                    
                }
                
                // It would be more efficient to invalidate the children of the "from" and "to" nodes and then
                // call -reloadColumn: on each of the corresponding columns. However, we just reload every column
                //
                [self.rootNodeSource invalidateChildren];
                
                for (NSInteger col = self.browserSourceOutlet.lastColumn; col >= 0; col--) {
                    
                    [self.browserSourceOutlet reloadColumn:col];
                    
                }
                
            }
            
        }];
        
        return YES;
        
    }
    
    return NO;
    
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
