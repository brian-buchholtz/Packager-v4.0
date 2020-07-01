//
//  PreferencesViewController.h
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

@import Cocoa;

@interface PreferencesViewController:NSObject {
    
    // Control outlets
    IBOutlet NSView *viewPreferencesOutlet;
    
    IBOutlet NSTextField *textboxPreferencesDevIdOutlet;
    IBOutlet NSTextField *textboxPreferencesLogPathOutlet;
    
    IBOutlet NSComboBox *comboboxPreferencesComparisonKeyOutlet;
    IBOutlet NSComboBox *comboboxPreferencesTypeOutlet;
    IBOutlet NSComboBox *comboboxPreferencesReceiptOutlet;
    IBOutlet NSComboBox *comboboxPreferencesOwnerOutlet;
    IBOutlet NSComboBox *comboboxPreferencesGroupOutlet;
    IBOutlet NSComboBox *comboboxPreferencesDevCertOutlet;
    
    IBOutlet NSButton *checkboxPreferencesOwnerReadOutlet;
    IBOutlet NSButton *checkboxPreferencesOwnerWriteOutlet;
    IBOutlet NSButton *checkboxPreferencesOwnerExecuteOutlet;
    IBOutlet NSButton *checkboxPreferencesGroupReadOutlet;
    IBOutlet NSButton *checkboxPreferencesGroupWriteOutlet;
    IBOutlet NSButton *checkboxPreferencesGroupExecuteOutlet;
    IBOutlet NSButton *checkboxPreferencesEveryoneReadOutlet;
    IBOutlet NSButton *checkboxPreferencesEveryoneWriteOutlet;
    IBOutlet NSButton *checkboxPreferencesEveryoneExecuteOutlet;
    IBOutlet NSButton *checkboxPreferencesIsSignedOutlet;
    IBOutlet NSButton *checkboxPreferencesIsNotarizedOutlet;
    IBOutlet NSButton *checkboxPreferencesVersionPackageNameOutlet;
    IBOutlet NSButton *checkboxPreferencesVersionPlistNameOutlet;
    IBOutlet NSButton *checkboxPreferencesPackageTypePlistNameOutlet;
    IBOutlet NSButton *checkboxPreferencesDateTimePackageNameOutlet;
    IBOutlet NSButton *checkboxPreferencesDateTimePlistNameOutlet;
    IBOutlet NSButton *checkboxPreferencesOpenLastProjectOutlet;
    
}

// Control actions
- (IBAction)buttonBrowseLogAction:(NSButton *)sender;

// Main functions
- (NSDictionary *)viewPreferences:(NSString *)stringSettingsPreferencesLanguage SettingsPreferencesLogPath:(NSString *)stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:(NSString *)stringSettingsPreferencesComparisonKey SettingsPreferencesType:(NSString *)stringSettingsPreferencesType SettingsPreferencesReceipt:(NSString *)stringSettingsPreferencesReceipt SettingsPreferencesDevCert:(NSString *)stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:(NSString *)stringSettingsPreferencesIsSigned SettingsPreferencesDevId:(NSString *)stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:(NSString *)stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:(NSString *)stringSettingsPreferencesOwner SettingsPreferencesGroup:(NSString *)stringSettingsPreferencesGroup SettingsPreferencesPermissions:(NSString *)stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:(NSString *)stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:(NSString *)stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:(NSString *)stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:(NSString *)stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:(NSString *)stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:(NSString *)stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:(NSString *)stringSettingsPreferencesLastProjectFile;
- (void)readUsers;
- (void)readGroups;
- (void)readIdentities;
- (void)browseLog;

@end
