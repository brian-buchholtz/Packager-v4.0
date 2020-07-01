//
//  PreferencesViewController.m
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "PreferencesViewController.h"
#import "UserGroup.h"
#import "Identities.h"
#import "BrowsePath.h"
#import "Logger.h"

@implementation PreferencesViewController


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controls

- (IBAction)buttonBrowseLogAction:(NSButton *)sender {
    
    // Browse log path
    [self browseLog];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions
    
- (NSDictionary *)viewPreferences:(NSString *)stringSettingsPreferencesLanguage SettingsPreferencesLogPath:(NSString *)stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:(NSString *)stringSettingsPreferencesComparisonKey SettingsPreferencesType:(NSString *)stringSettingsPreferencesType SettingsPreferencesReceipt:(NSString *)stringSettingsPreferencesReceipt SettingsPreferencesDevCert:(NSString *)stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:(NSString *)stringSettingsPreferencesIsSigned SettingsPreferencesDevId:(NSString *)stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:(NSString *)stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:(NSString *)stringSettingsPreferencesOwner SettingsPreferencesGroup:(NSString *)stringSettingsPreferencesGroup SettingsPreferencesPermissions:(NSString *)stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:(NSString *)stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:(NSString *)stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:(NSString *)stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:(NSString *)stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:(NSString *)stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:(NSString *)stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:(NSString *)stringSettingsPreferencesLastProjectFile {
    
    // Initialize variables
    NSString *stringSettingsPreferencesLoad = @"";
    NSString *stringTemp = @"";
    
    int intPermissionsOwner;
    int intPermissionsGroup;
    int intPermissionsEveryone;
    
    // Load custom alert
    NSAlert *alertPreferences = [[NSAlert alloc] init];
    
    [NSBundle.mainBundle loadNibNamed:@"PreferencesView" owner:self topLevelObjects:nil];
    
    // Load combobox contents
    [self readUsers];
    [self readGroups];
    [self readIdentities];
    
    // Textboxes
    [textboxPreferencesLogPathOutlet setStringValue:stringSettingsPreferencesLogPath];
    [textboxPreferencesDevIdOutlet setStringValue:stringSettingsPreferencesDevId];
    
    // Comboboxes
    [comboboxPreferencesComparisonKeyOutlet selectItemWithObjectValue:stringSettingsPreferencesComparisonKey];
    [comboboxPreferencesTypeOutlet selectItemWithObjectValue:stringSettingsPreferencesType];
    [comboboxPreferencesReceiptOutlet selectItemWithObjectValue:stringSettingsPreferencesReceipt];
    [comboboxPreferencesOwnerOutlet selectItemWithObjectValue:stringSettingsPreferencesOwner];
    [comboboxPreferencesGroupOutlet selectItemWithObjectValue:stringSettingsPreferencesGroup];
    [comboboxPreferencesDevCertOutlet selectItemWithObjectValue:stringSettingsPreferencesDevCert];
    
    // Parse permissions
    stringTemp = [stringSettingsPreferencesPermissions substringWithRange:NSMakeRange(0, 1)];
    NSLog(@"Owner: %@", stringTemp);
    intPermissionsOwner = [stringTemp integerValue];
    
    stringTemp = [stringSettingsPreferencesPermissions substringWithRange:NSMakeRange(1, 1)];
    NSLog(@"Group: %@", stringTemp);
    intPermissionsGroup = [stringTemp integerValue];
    
    stringTemp = [stringSettingsPreferencesPermissions substringWithRange:NSMakeRange(2, 1)];
    NSLog(@"Everyone: %@", stringTemp);
    intPermissionsEveryone = [stringTemp integerValue];
    
    // Owner checkboxes
    if (intPermissionsOwner >= 4) {
        
        [checkboxPreferencesOwnerReadOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 4;
        
    }
    
    else {
        
        [checkboxPreferencesOwnerReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 2) {
        
        [checkboxPreferencesOwnerWriteOutlet setState:NSOnState];
        intPermissionsOwner = intPermissionsOwner - 2;
        
    }
    
    else {
        
        [checkboxPreferencesOwnerWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsOwner >= 1) {
        
        [checkboxPreferencesOwnerExecuteOutlet setState:NSOnState];
        //intPermissionsOwner = intPermissionsOwner - 1;
        
    }
    
    else {
        
        [checkboxPreferencesOwnerExecuteOutlet setState:NSOffState];
        
    }
    
    // Group checkboxes
    if (intPermissionsGroup >= 4) {
        
        [checkboxPreferencesGroupReadOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 4;
        
    }
    
    else {
        
        [checkboxPreferencesGroupReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 2) {
        
        [checkboxPreferencesGroupWriteOutlet setState:NSOnState];
        intPermissionsGroup = intPermissionsGroup - 2;
        
    }
    
    else {
        
        [checkboxPreferencesGroupWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsGroup >= 1) {
        
        [checkboxPreferencesGroupExecuteOutlet setState:NSOnState];
        //intPermissionsGroup = intPermissionsGroup - 1;
        
    }
    
    else {
        
        [checkboxPreferencesGroupExecuteOutlet setState:NSOffState];
        
    }
    
    // Everyone checkboxes
    if (intPermissionsEveryone >= 4) {
        
        [checkboxPreferencesEveryoneReadOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 4;
        
    }
    
    else {
        
        [checkboxPreferencesEveryoneReadOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 2) {
        
        [checkboxPreferencesEveryoneWriteOutlet setState:NSOnState];
        intPermissionsEveryone = intPermissionsEveryone - 2;
        
    }
    
    else {
        
        [checkboxPreferencesEveryoneWriteOutlet setState:NSOffState];
        
    }
    
    if (intPermissionsEveryone >= 1) {
        
        [checkboxPreferencesEveryoneExecuteOutlet setState:NSOnState];
        //intPermissionsEveryone = intPermissionsEveryone - 1;
        
    }
    
    else {
        
        [checkboxPreferencesEveryoneExecuteOutlet setState:NSOffState];
        
    }
    
    // Project Is Signed checkbox
    if ([stringSettingsPreferencesIsSigned isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesIsSignedOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesIsSignedOutlet setState:NSOffState];
        
    }
    
    // Project Is Notarized checkbox
    if ([stringSettingsPreferencesIsNotarized isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesIsNotarizedOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesIsNotarizedOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesVersionPackageName isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesVersionPackageNameOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesVersionPackageNameOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesVersionPlistName isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesVersionPlistNameOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesVersionPlistNameOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesDateTimePackageName isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesDateTimePackageNameOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesDateTimePackageNameOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesDateTimePlistName isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesDateTimePlistNameOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesDateTimePlistNameOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesPackageTypePlistName isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesPackageTypePlistNameOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesPackageTypePlistNameOutlet setState:NSOffState];
        
    }
    
    if ([stringSettingsPreferencesOpenLastProject isEqualToString:@"TRUE"]) {
        
        [checkboxPreferencesOpenLastProjectOutlet setState:NSOnState];
        
    }
    
    else {
        
        [checkboxPreferencesOpenLastProjectOutlet setState:NSOffState];
        
    }
    
    alertPreferences.accessoryView = viewPreferencesOutlet;
    [alertPreferences setMessageText:@"Preferences"];
    [alertPreferences addButtonWithTitle:@"Save"];
    [alertPreferences addButtonWithTitle:@"Cancel"];
    
    NSInteger intButton = [alertPreferences runModal];
    
    if (intButton == NSAlertFirstButtonReturn) {
        
        // Textboxes
        stringSettingsPreferencesLogPath = [textboxPreferencesLogPathOutlet stringValue];
        stringSettingsPreferencesDevId = [textboxPreferencesDevIdOutlet stringValue];
        
        // Comboboxes
        stringSettingsPreferencesComparisonKey = [comboboxPreferencesComparisonKeyOutlet stringValue];
        stringSettingsPreferencesType = [comboboxPreferencesTypeOutlet stringValue];
        stringSettingsPreferencesReceipt = [comboboxPreferencesReceiptOutlet stringValue];
        stringSettingsPreferencesOwner = [comboboxPreferencesOwnerOutlet stringValue];
        stringSettingsPreferencesGroup = [comboboxPreferencesGroupOutlet stringValue];
        stringSettingsPreferencesDevCert = [comboboxPreferencesDevCertOutlet stringValue];
        
        // Reset permissions values
        intPermissionsOwner = 0;
        intPermissionsGroup = 0;
        intPermissionsEveryone = 0;
        
        // Checkboxes
        if ([checkboxPreferencesOwnerReadOutlet state] == NSOnState) {
            
            intPermissionsOwner = intPermissionsOwner + 4;
            
        }
        
        if ([checkboxPreferencesOwnerWriteOutlet state] == NSOnState) {
            
            intPermissionsOwner = intPermissionsOwner + 2;
            
        }
        
        if ([checkboxPreferencesOwnerExecuteOutlet state] == NSOnState) {
            
            intPermissionsOwner = intPermissionsOwner + 1;
            
        }
        
        if ([checkboxPreferencesGroupReadOutlet state] == NSOnState) {
            
            intPermissionsGroup = intPermissionsGroup + 4;
            
        }
        
        if ([checkboxPreferencesGroupWriteOutlet state] == NSOnState) {
            
            intPermissionsGroup = intPermissionsGroup + 2;
            
        }
        
        if ([checkboxPreferencesGroupExecuteOutlet state] == NSOnState) {
            
            intPermissionsGroup = intPermissionsGroup + 1;
            
        }
        
        if ([checkboxPreferencesEveryoneReadOutlet state] == NSOnState) {
            
            intPermissionsEveryone = intPermissionsEveryone + 4;
            
        }
        
        if ([checkboxPreferencesEveryoneWriteOutlet state] == NSOnState) {
            
            intPermissionsEveryone = intPermissionsEveryone + 2;
            
        }
        
        if ([checkboxPreferencesEveryoneExecuteOutlet state] == NSOnState) {
            
            intPermissionsEveryone = intPermissionsEveryone + 1;
            
        }
        
        if ([checkboxPreferencesIsSignedOutlet state] == NSOnState) {
            
            stringSettingsPreferencesIsSigned = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesIsSigned = @"FALSE";
            
        }
        
        if ([checkboxPreferencesIsNotarizedOutlet state] == NSOnState) {
            
            stringSettingsPreferencesIsNotarized = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesIsNotarized = @"FALSE";
            
        }
        
        stringTemp = [@(intPermissionsOwner) stringValue];
        NSLog(@"Owner: %@", stringTemp);
        
        stringTemp = [@(intPermissionsGroup) stringValue];
        NSLog(@"Group: %@", stringTemp);
        
        stringTemp = [@(intPermissionsEveryone) stringValue];
        NSLog(@"Everyone: %@", stringTemp);
        
        // Concatenate permissions
        stringSettingsPreferencesPermissions = [NSString stringWithFormat:@"%@%@%@", [@(intPermissionsOwner) stringValue], [@(intPermissionsGroup) stringValue], [@(intPermissionsEveryone) stringValue]];
        
        if ([checkboxPreferencesVersionPackageNameOutlet state] == NSOnState) {
            
            stringSettingsPreferencesVersionPackageName = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesVersionPackageName = @"FALSE";
            
        }
        
        if ([checkboxPreferencesVersionPlistNameOutlet state] == NSOnState) {
            
            stringSettingsPreferencesVersionPlistName = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesVersionPlistName = @"FALSE";
            
        }
        
        if ([checkboxPreferencesDateTimePackageNameOutlet state] == NSOnState) {
            
            stringSettingsPreferencesDateTimePackageName = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesDateTimePackageName = @"FALSE";
            
        }
        
        if ([checkboxPreferencesDateTimePlistNameOutlet state] == NSOnState) {
            
            stringSettingsPreferencesDateTimePlistName = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesDateTimePlistName = @"FALSE";
            
        }
        
        if ([checkboxPreferencesPackageTypePlistNameOutlet state] == NSOnState) {
            
            stringSettingsPreferencesPackageTypePlistName = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesPackageTypePlistName = @"FALSE";
            
        }
        
        if ([checkboxPreferencesOpenLastProjectOutlet state] == NSOnState) {
            
            stringSettingsPreferencesOpenLastProject = @"TRUE";
            
        }
        
        else {
            
            stringSettingsPreferencesOpenLastProject = @"FALSE";
            
        }
        
        // Update settings
        stringSettingsPreferencesLoad = @"TRUE";
        
        [Logger setLogEvent:@"Save preferences: Successful", nil];
    
    }
    
    else if (intButton == NSAlertSecondButtonReturn) {
        
        // Revert to current project settings
        stringSettingsPreferencesLoad = @"FALSE";
        
        [Logger setLogEvent:@"Save preferences: Cancelled - User initiated", nil];
    
    }
    
    return @{@"SettingsPreferencesLoad":stringSettingsPreferencesLoad,
             @"SettingsPreferencesLanguage":stringSettingsPreferencesLanguage,
             @"SettingsPreferencesLogPath":stringSettingsPreferencesLogPath,
             @"SettingsPreferencesComparisonKey":stringSettingsPreferencesComparisonKey,
             @"SettingsPreferencesType":stringSettingsPreferencesType,
             @"SettingsPreferencesReceipt":stringSettingsPreferencesReceipt,
             @"SettingsPreferencesDevCert":stringSettingsPreferencesDevCert,
             @"SettingsPreferencesIsSigned":stringSettingsPreferencesIsSigned,
             @"SettingsPreferencesDevId":stringSettingsPreferencesDevId,
             @"SettingsPreferencesIsNotarized":stringSettingsPreferencesIsNotarized,
             @"SettingsPreferencesOwner":stringSettingsPreferencesOwner,
             @"SettingsPreferencesGroup":stringSettingsPreferencesGroup,
             @"SettingsPreferencesPermissions":stringSettingsPreferencesPermissions,
             @"SettingsPreferencesVersionPackageName":stringSettingsPreferencesVersionPackageName,
             @"SettingsPreferencesVersionPlistName":stringSettingsPreferencesVersionPlistName,
             @"SettingsPreferencesDateTimePackageName":stringSettingsPreferencesDateTimePackageName,
             @"SettingsPreferencesDateTimePlistName":stringSettingsPreferencesDateTimePlistName,
             @"SettingsPreferencesPackageTypePlistName":stringSettingsPreferencesPackageTypePlistName,
             @"SettingsPreferencesOpenLastProject":stringSettingsPreferencesOpenLastProject,
             @"SettingsPreferencesLastProjectFile":stringSettingsPreferencesLastProjectFile};

}

- (void)readUsers {
    
    // Create usergroup class
    UserGroup *readUsers = [[UserGroup alloc] init];
    NSArray *arrayUsers = [readUsers getUserGroup:@"user"];
    
    for (id idUser in arrayUsers) {
        
        [comboboxPreferencesOwnerOutlet addItemWithObjectValue:idUser];
        
    }
    
    [Logger setLogEvent:@"Reading users", nil];
    
}

- (void)readGroups {
    
    // Create usergroup class
    UserGroup *readGroups = [[UserGroup alloc] init];
    NSArray *arrayGroups = [readGroups getUserGroup:@"group"];
    
    for (id idGroup in arrayGroups) {
        
        [comboboxPreferencesGroupOutlet addItemWithObjectValue:idGroup];
        
    }
    
    [Logger setLogEvent:@"Reading groups", nil];
    
}

- (void)readIdentities {
    
    // Create identities class
    Identities *readIdentities = [[Identities alloc] init];
    NSArray *arrayIdentities = [readIdentities getIdentities];
    
    for (id idIdentity in arrayIdentities) {
        
        [comboboxPreferencesDevCertOutlet addItemWithObjectValue:idIdentity];
        
    }
    
    [Logger setLogEvent:@"Reading identities", nil];
    
}

- (void)browseLog {
    
    // Browse for log path
    BrowsePath *logPath = [[BrowsePath alloc] init];
    NSString *stringLogPath = [logPath getPath:@"/"];
    
    // Handle log path browse cancel
    if (stringLogPath) {
        
        [textboxPreferencesLogPathOutlet setStringValue:stringLogPath];
        [Logger setLogEvent:@"Log path: ", stringLogPath, nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Browse log path aborted", nil];
        
    }
    
}

@end
