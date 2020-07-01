//
//  GeneratePlist.m
//  Packager
//
//  Created by Brian Buchholtz on 12/17/2019.
//
//  Contributed by Paul Evans on 9/16/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "GeneratePlist.h"
#import "Permissions.h"
#import "PlistWrapper.h"
#import "Logger.h"

@implementation GeneratePlist {
    
}

+ (void)writePlist:(NSString *)stringPlistFileName BuildType:(NSString *)stringBuildType CurrentDate:(NSDate *)dateCurrent SettingsApplicationName:(NSString *)stringSettingsApplicationName SettingsApplicationVersion:(NSString *)stringSettingsApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectShortVersion:(NSString *)stringProjectShortVersion ProjectComparisonKey:(NSString *)stringProjectComparisonKey ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions ProjectType:(NSString *)stringProjectType ProjectInstall:(NSString *)stringProjectInstall ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget ProjectManifest:(NSArray *)arrayProjectManifest PayloadSize:(NSNumber *)numberPayloadSize PackageFileName:(NSString *)stringPackageFileName PackageSize:(NSNumber *)numberPackageSize PackageHash:(NSString *)stringPackageHash ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    // Tokenize values
    NSArray *arrayProjectOwner = [stringProjectOwner componentsSeparatedByString:@" "];
    stringProjectOwner = [arrayProjectOwner objectAtIndex:0];
    
    NSArray *arrayProjectGroup = [stringProjectGroup componentsSeparatedByString:@" "];
    stringProjectGroup = [arrayProjectGroup objectAtIndex:0];
    
    // Parse permissions
    NSString *stringTemp;
    
    stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(0, 1)];
    NSLog(@"Owner: %@", stringTemp);
    int intPermissionsOwner = [stringTemp integerValue];
    
    stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(1, 1)];
    NSLog(@"Group: %@", stringTemp);
    int intPermissionsGroup = [stringTemp integerValue];
    
    stringTemp = [stringProjectPermissions substringWithRange:NSMakeRange(2, 1)];
    NSLog(@"Everyone: %@", stringTemp);
    int intPermissionsEveryone = [stringTemp integerValue];
    
    // Convert permissions
    NSString *stringProjectPermissionsOwner = [Permissions convertPermissions:intPermissionsOwner];
    NSString *stringProjectPermissionsGroup = [Permissions convertPermissions:intPermissionsGroup];
    NSString *stringProjectPermissionsEveryone = [Permissions convertPermissions:intPermissionsEveryone];
    
    NSLog(@"Owner: %@", stringProjectOwner);
    NSLog(@"Group: %@", stringProjectGroup);
    NSLog(@"Permissions Owner: %@", stringProjectPermissionsOwner);
    NSLog(@"Permissions Group: %@", stringProjectPermissionsGroup);
    NSLog(@"Permissions Everyone: %@", stringProjectPermissionsEveryone);
    
    // Package file
    NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringPackageFileName];
    
    // Plist file
    NSString *stringPlistFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringPlistFileName];
    
    // Plist document elements
    NSDictionary *dictPlist = [NSMutableDictionary new];
    
    NSMutableDictionary *dictMetadata = [NSMutableDictionary new];
    [dictMetadata setValue:[NSString stringWithFormat:@"%@ %@", stringSettingsApplicationName, stringSettingsApplicationVersion] forKey:@"created_by"];
    [dictMetadata setValue:dateCurrent forKey:@"creation_date"];
    [dictMetadata setValue:@"3.0.0.3335" forKey:@"munki_version"];
    [dictMetadata setValue:@"10.13.4" forKey:@"os_version"];
    
    NSNumber *boolAutoremove = [NSNumber numberWithBool:FALSE];
    NSArray *arrayCatalogs = [NSArray arrayWithObjects:@"testing", nil];
    NSString *stringCategory = @"Software";
    NSString *stringDescription = @"";
    NSString *stringDeveloper = @"";
    NSString *stringDisplay_name = stringProjectName;
    NSString *stringInstaller_item_hash = stringPackageHash;
    NSString *stringInstaller_item_location = stringPackageFile;
    NSNumber *intInstaller_item_size = numberPackageSize;
    
    NSString *stringMinimum_os_version;
    
    if ([stringBuildType isEqualToString:@"pkg"]) {
        
        stringMinimum_os_version = @"10.5.0";
        
    }
    
    else if ([stringBuildType isEqualToString:@"dmg"]) {
        
        stringMinimum_os_version = @"10.7.5";
        
    }
    
    NSString *stringName = stringProjectName;
    
    NSMutableDictionary *dictReceipts = [NSMutableDictionary new];
    
    [dictReceipts setValue:numberPayloadSize forKey:@"installed_size"];
    [dictReceipts setValue:stringProjectIdentifier forKey:@"packageid"];
    [dictReceipts setValue:stringProjectVersion forKey:@"version"];
    
    NSArray *arrayReceipts = [NSArray arrayWithObjects:dictReceipts, nil];
    
    NSString *stringLastChar = [stringProjectInstall substringFromIndex:[stringProjectInstall length] - 1];
    
    if (![stringLastChar isEqualToString:@"/"]) {
        
        stringProjectInstall = [NSString stringWithFormat:@"%@/", stringProjectInstall];
        
    }
    
    NSString *stringTargetPermissions;
    
    NSString *stringScriptPrefix = @"#!/bin/sh\n\n";
    NSString *stringScriptChown;
    NSString *stringScriptChmod;
    NSString *stringScriptSuffix = @"# Insert your script here\n";
    
    // Validate owner and group
    if ((stringProjectOwner.length) && (stringProjectGroup.length)) {
        
        stringScriptChown = [NSString stringWithFormat:@"# Set Ownership\n#/usr/sbin/chown -R %@:%@ \"%@YOUR_FILES\"\n\n", stringProjectOwner, stringProjectGroup, stringProjectInstall];
        
    }
    
    else if ((stringProjectOwner.length) && (!stringProjectGroup.length)) {
        
        stringScriptChown = [NSString stringWithFormat:@"# Set Ownership\n#/usr/sbin/chown -R %@ \"%@YOUR_FILES\"\n\n", stringProjectOwner, stringProjectInstall];
        
    }
    
    else {
        
        stringScriptChown = @"# Set Ownership\n#\n\n";
        
    }
    
    // Validate permissions
    if (![stringProjectPermissions isEqualToString:@"000"]) {
        
        stringScriptChmod = @"# Set Permissions\n#/bin/chmod -R ";
        
        if (intPermissionsOwner > 0) {
            
            stringTargetPermissions = [NSString stringWithFormat:@"u+%@", stringProjectPermissionsOwner];
            
        }
        
        if (intPermissionsGroup > 0) {
            
            if (intPermissionsOwner > 0) {
                
                stringTargetPermissions = [NSString stringWithFormat:@"%@,", stringTargetPermissions];
                
            }
            
            stringTargetPermissions = [NSString stringWithFormat:@"%@g+%@", stringTargetPermissions, stringProjectPermissionsGroup];
            
        }
        
        if (intPermissionsEveryone > 0) {
            
            if ((intPermissionsOwner > 0) || (intPermissionsGroup > 0)) {
                
                stringTargetPermissions = [NSString stringWithFormat:@"%@,", stringTargetPermissions];
                
            }
            
            stringTargetPermissions = [NSString stringWithFormat:@"%@o+%@", stringTargetPermissions, stringProjectPermissionsEveryone];
            
        }
        
        stringScriptChmod = [NSString stringWithFormat:@"%@%@", stringScriptChmod, stringTargetPermissions];
        
        NSLog(@"Script Chmod: %@", stringScriptChmod);
        
        stringScriptChmod = [NSString stringWithFormat:@"%@ \"%@YOUR_FILES\"\n\n", stringScriptChmod, stringProjectInstall];
    
    }
    
    else {
        
        stringScriptChmod = @"# Set Permissions\n#\n\n";
        
    }
    
    NSString *stringPostinstall_script;
    
    // Concatenate post install script
    if ([stringBuildType isEqualToString:@"pkg"]) {
        
        stringPostinstall_script = [NSString stringWithFormat:@"%@%@%@%@", stringScriptPrefix, stringScriptChown, stringScriptChmod, stringScriptSuffix];
        
    }
    
    else if ([stringBuildType isEqualToString:@"dmg"]) {
        
        stringPostinstall_script = [NSString stringWithFormat:@"%@%@", stringScriptPrefix, stringScriptSuffix];
        
    }
    
    NSNumber *boolUnattended_install = [NSNumber numberWithBool:FALSE];
    NSNumber *boolUnattended_uninstall = [NSNumber numberWithBool:FALSE];
    
    NSString *stringUninstall_method;
    
    if ([stringBuildType isEqualToString:@"pkg"]) {
        
        stringUninstall_method = @"removepackages";
        
    }
    
    else if ([stringBuildType isEqualToString:@"dmg"]) {
        
        stringUninstall_method = @"remove_copied_items";
        
    }
    
    NSNumber *boolUninstallable = [NSNumber numberWithBool:TRUE];
    NSString *stringVersion = stringProjectVersion;
    
    // Installs
    NSMutableArray *arrayInstalls = [[NSMutableArray alloc] init];
    
    for (id idProjectManifest in arrayProjectManifest) {
        
        NSDictionary *dictProjectManifest = idProjectManifest;
        
        NSString *stringPath = dictProjectManifest[@"path"];
        NSString *stringMd5Checksum = dictProjectManifest[@"md5checksum"];
        
        NSMutableDictionary *dictInstalls = [NSMutableDictionary new];
        
        [dictInstalls setValue:stringProjectIdentifier forKey:@"CFBundleIdentifier"];
        [dictInstalls setValue:stringProjectName forKey:@"CFBundleName"];
        [dictInstalls setValue:stringProjectShortVersion forKey:@"CFBundleShortVersionString"];
        [dictInstalls setValue:stringProjectVersion forKey:@"CFBundleVersion"];
        [dictInstalls setValue:stringMd5Checksum forKey:@"md5checksum"];
        [dictInstalls setValue:@"10.7.5" forKey:@"minosversion"];
        [dictInstalls setValue:stringPath forKey:@"path"];
        [dictInstalls setValue:stringProjectType forKey:@"type"];
        [dictInstalls setValue:stringProjectComparisonKey forKey:@"version_comparison_key"];
        
        [arrayInstalls addObject:dictInstalls];
        
    }
    
    // Items to copy
    NSMutableArray *arrayItems_To_Copy = [[NSMutableArray alloc] init];
    
    for (id idProjectManifest in arrayProjectManifest) {
        
        NSMutableDictionary *dictItems_To_Copy = [NSMutableDictionary new];
        
        NSDictionary *dictProjectManifest = idProjectManifest;
        
        NSString *stringDestinationPath = dictProjectManifest[@"destination_path"];
        NSString *stringSourceItem = dictProjectManifest[@"source_item"];
        
        [dictItems_To_Copy setValue:stringDestinationPath forKey:@"destination_path"];
        
        if (stringProjectGroup.length) {
            
            [dictItems_To_Copy setValue:stringProjectGroup forKey:@"group"];
            
        }
        
        if (![stringProjectPermissions isEqualToString:@"000"]) {
            
            [dictItems_To_Copy setValue:stringTargetPermissions forKey:@"mode"];
            
        }
        
        [dictItems_To_Copy setValue:stringSourceItem forKey:@"source_item"];
        
        if (stringProjectOwner.length) {
            
            [dictItems_To_Copy setValue:stringProjectOwner forKey:@"user"];
            
        }
        
        [arrayItems_To_Copy addObject:dictItems_To_Copy];
        
    }
    
    // Plist document
    [dictPlist setValue:dictMetadata forKey:@"_metadata"];
    [dictPlist setValue:boolAutoremove forKey:@"autoremove"];
    [dictPlist setValue:arrayCatalogs forKey:@"catalogs"];
    [dictPlist setValue:stringCategory forKey:@"category"];
    [dictPlist setValue:stringDescription forKey:@"description"];
    [dictPlist setValue:stringDeveloper forKey:@"developer"];
    [dictPlist setValue:stringDisplay_name forKey:@"display_name"];
    [dictPlist setValue:stringInstaller_item_hash forKey:@"installer_item_hash"];
    [dictPlist setValue:stringInstaller_item_location forKey:@"installer_item_location"];
    [dictPlist setValue:intInstaller_item_size forKey:@"installer_item_size"];
    
    if ([stringBuildType isEqualToString:@"dmg"]) {
        
        [dictPlist setValue:@"copy_from_dmg" forKey:@"installer_type"];
        
    }
    
    [dictPlist setValue:stringMinimum_os_version forKey:@"minimum_os_version"];
    [dictPlist setValue:stringName forKey:@"name"];
    
    if ([stringBuildType isEqualToString:@"pkg"]) {
        
        [dictPlist setValue:arrayReceipts forKey:@"receipts"];
        
    }
    
    else if ([stringBuildType isEqualToString:@"dmg"]) {
        
        [dictPlist setValue:arrayItems_To_Copy forKey:@"items_to_copy"];
        
    }
    
    [dictPlist setValue:arrayInstalls forKey:@"installs"];
    [dictPlist setValue:stringPostinstall_script forKey:@"postinstall_script"];
    [dictPlist setValue:boolUnattended_install forKey:@"unattended_install"];
    [dictPlist setValue:boolUnattended_uninstall forKey:@"unattended_uninstall"];
    [dictPlist setValue:stringUninstall_method forKey:@"uninstall_method"];
    [dictPlist setValue:boolUninstallable forKey:@"uninstallable"];
    [dictPlist setValue:stringVersion forKey:@"version"];
    
    // Convert dictionary to string
    NSString *stringPlist = [PlistWrapper objToPlistAsString:dictPlist];
    
    NSLog(@"Plist Document:\n%@", stringPlist);
    
    // Write plist to file
    NSData* dataPlist = [stringPlist dataUsingEncoding:NSUTF8StringEncoding];
    [dataPlist writeToFile:stringPlistFile atomically:YES];
    
    [Logger setLogEvent:@"Saving plist file: ", stringPlistFile, nil];
    
}

@end
