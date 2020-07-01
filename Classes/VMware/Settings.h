//
//  Settings.h
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef Settings_h
#define Settings_h

#import <Foundation/Foundation.h>

@interface Settings:NSObject {
    
}

+ (void)writeSettings:(NSString *)stringSettingsFile SettingsApplicationName:(NSString *)stringSettingsApplicationName SettingsApplicationVersion:(NSString *)stringSettingsApplicationVersion SettingsPreferencesLanguage:(NSString *)stringSettingsPreferencesLanguage SettingsPreferencesLogPath:(NSString *)stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:(NSString *)stringSettingsPreferencesComparisonKey SettingsPreferencesType:(NSString *)stringSettingsPreferencesType SettingsPreferencesReceipt:(NSString *)stringSettingsPreferencesReceipt SettingsPreferencesDevCert:(NSString *)stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:(NSString *)stringSettingsPreferencesIsSigned SettingsPreferencesDevId:(NSString *)stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:(NSString *)stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:(NSString *)stringSettingsPreferencesOwner SettingsPreferencesGroup:(NSString *)stringSettingsPreferencesGroup SettingsPreferencesPermissions:(NSString *)stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:(NSString *)stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:(NSString *)stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:(NSString *)stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:(NSString *)stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:(NSString *)stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:(NSString *)stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:(NSString *)stringSettingsPreferencesLastProjectFile;
- (NSDictionary *)readSettings:(NSString *)stringSettingsFile;

@end

#endif /* Settings_h */
