//
//  GeneratePlist.m
//  Packager
//
//  Created by Brian Buchholtz on 12/17/19.
//
//  Contributed by Paul Evans on 9/16/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "GeneratePlist.h"
#import "Permissions.h"
#import "SourceItem.h"
#import "PlistWrapper.h"
#import "Logger.h"

@implementation GeneratePlist {
    
}

+ (void)writePlist:(NSString *)stringBuildType ApplicationName:(NSString *)stringApplicationName ApplicationVersion:(NSString *)stringApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions ProjectRoot:(NSString *)stringProjectRoot ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget PayloadSize:(NSNumber *)numberPayloadSize PackageSize:(NSNumber *)numberPackageSize PackageHash:(NSString *)stringPackageHash ProjectIsSigned:(NSString *)stringProjectIsSigned {
    
    // Tokenize values
    NSArray *arrayProjectOwner = [stringProjectOwner componentsSeparatedByString: @" "];
    stringProjectOwner = [arrayProjectOwner objectAtIndex:0];
    
    NSArray *arrayProjectGroup = [stringProjectGroup componentsSeparatedByString: @" "];
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
    
    // Plist variables
    NSString *stringPackageFile;
    NSString *stringPlistFile;
    
    // Package is signed state
    if ([stringProjectIsSigned isEqualToString: @"TRUE"]) {
        
        stringPackageFile = [NSString stringWithFormat:@"%@-%@_signed.%@", stringProjectName, stringProjectVersion, stringBuildType];
        stringPlistFile = [NSString stringWithFormat:@"%@/%@-%@_signed.plist", stringProjectTarget, stringProjectName, stringProjectVersion];
        
    }
    
    else if ([stringProjectIsSigned isEqualToString: @"FALSE"]) {
        
        stringPackageFile = [NSString stringWithFormat:@"%@-%@.%@", stringProjectName, stringProjectVersion, stringBuildType];
        stringPlistFile = [NSString stringWithFormat:@"%@/%@-%@.plist", stringProjectTarget, stringProjectName, stringProjectVersion];
        
    }
    
    // Get date and time
    NSDate *date = [NSDate date];
    
    // Plist document elements
    NSDictionary *dictPlist = [NSMutableDictionary new];
    
    NSMutableDictionary *dictMetadata =[NSMutableDictionary new];
    [dictMetadata setValue:[NSString stringWithFormat:@"%@ %@", stringApplicationName, stringApplicationVersion] forKey:@"created_by"];
    [dictMetadata setValue:date forKey:@"creation_date"];
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
    
    if ([stringBuildType isEqualToString: @"pkg"]) {
        
        stringMinimum_os_version = @"10.5.0";
        
    }
    
    else if ([stringBuildType isEqualToString: @"dmg"]) {
        
        stringMinimum_os_version = @"10.7.5";
        
    }
    
    NSString *stringName = stringProjectName;
    
    NSMutableDictionary *dictReceipts =[NSMutableDictionary new];
    
    [dictReceipts setValue:numberPayloadSize forKey:@"installed_size"];
    [dictReceipts setValue:stringProjectIdentifier forKey:@"packageid"];
    [dictReceipts setValue:stringProjectVersion forKey:@"version"];
    
    NSArray *arrayReceipts = [NSArray arrayWithObjects:dictReceipts, nil];
    
    NSString *stringLastChar = [stringProjectRoot substringFromIndex:[stringProjectRoot length] - 1];
    
    if (![stringLastChar isEqualToString: @"/"]) {
        
        stringProjectRoot = [NSString stringWithFormat:@"%@/", stringProjectRoot];
        
    }
    
    NSString *stringTargetPermissions;
    
    NSString *stringScriptPrefix = @"#!/bin/sh\r\n\r\n";
    NSString *stringScriptChown;
    NSString *stringScriptChmod;
    NSString *stringScriptSuffix = @"# Insert your script here\"\r\n";
    
    // Validate owner and group
    if ((stringProjectOwner.length) && (stringProjectGroup.length)) {
        
        stringScriptChown = [NSString stringWithFormat:@"# Set Ownership\r\n#/usr/sbin/chown -R %@:%@ \"%@YOUR_FILES\"\r\n\r\n", stringProjectOwner, stringProjectGroup, stringProjectRoot];
        
    }
    
    // Validate permissions
    if (![stringProjectPermissions isEqualToString: @"000"]) {
        
        stringScriptChmod = @"# Set Permissions\r\n#/bin/chmod -R ";
        
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
        
        stringScriptChmod = [NSString stringWithFormat:@"%@ \"%@YOUR_FILES\"\r\n\r\n", stringScriptChmod, stringProjectRoot];
    
    }
    
    NSString *stringPostinstall_script;
    
    // Concatenate post install script
    if ([stringBuildType isEqualToString: @"pkg"]) {
        
        stringPostinstall_script = [NSString stringWithFormat:@"%@%@%@%@", stringScriptPrefix, stringScriptChown, stringScriptChmod, stringScriptSuffix];
        
    }
    
    else if ([stringBuildType isEqualToString: @"dmg"]) {
        
        stringPostinstall_script = [NSString stringWithFormat:@"%@%@", stringScriptPrefix, stringScriptSuffix];
        
    }
    
    NSNumber *boolUnattended_install = [NSNumber numberWithBool:FALSE];
    NSNumber *boolUnattended_uninstall = [NSNumber numberWithBool:FALSE];
    
    NSString *stringUninstall_method;
    
    if ([stringBuildType isEqualToString: @"pkg"]) {
        
        stringUninstall_method = @"removepackages";
        
    }
    
    else if ([stringBuildType isEqualToString: @"dmg"]) {
        
        stringUninstall_method = @"remove_copied_items";
        
    }
    
    NSNumber *boolUninstallable = [NSNumber numberWithBool:TRUE];
    NSString *stringVersion = stringProjectVersion;
    
    // Create sourceitem class
    SourceItem *sourceItem = [[SourceItem alloc] init];
    NSArray *arraySourceItem = [sourceItem getSourceItem:stringProjectSource];
    
    // Installs
    NSMutableArray *arrayInstalls = [[NSMutableArray alloc] init];
    
    for (id idSourceItem in arraySourceItem) {
        
        NSMutableDictionary *dictInstalls =[NSMutableDictionary new];
        
        [dictInstalls setValue:stringProjectIdentifier forKey:@"CFBundleIdentifier"];
        [dictInstalls setValue:stringProjectName forKey:@"CFBundleName"];
        [dictInstalls setValue:stringProjectVersion forKey:@"CFBundleShortVersionString"];
        [dictInstalls setValue:stringProjectVersion forKey:@"CFBundleVersion"];
        [dictInstalls setValue:@"10.7.5" forKey:@"minosversion"];
        [dictInstalls setValue:[NSString stringWithFormat:@"%@%@", stringProjectRoot, idSourceItem] forKey:@"path"];
        
        NSLog(@"Installs: %@", [NSString stringWithFormat:@"%@%@", stringProjectRoot, idSourceItem]);
        
        [dictInstalls setValue:@"application" forKey:@"type"];
        [dictInstalls setValue:@"CFBundleShortVersionString" forKey:@"version_comparison_key"];
        
        [arrayInstalls addObject: dictInstalls];
        
        NSLog(@"ARRAY: %@", idSourceItem);
        
    }
    
    // Items to copy
    NSMutableArray *arrayItems_To_Copy = [[NSMutableArray alloc] init];
    
    for (id idSourceItem in arraySourceItem) {
        
        NSMutableDictionary *dictItems_To_Copy =[NSMutableDictionary new];
        
        [dictItems_To_Copy setValue:stringProjectRoot forKey:@"destination_path"];
        
        if (stringProjectGroup.length) {
            
            [dictItems_To_Copy setValue:stringProjectGroup forKey:@"group"];
            
        }
        
        if (![stringProjectPermissions isEqualToString: @"000"]) {
            
            [dictItems_To_Copy setValue:stringTargetPermissions forKey:@"mode"];
            
        }
        
        [dictItems_To_Copy setValue:idSourceItem forKey:@"source_item"];
        
        if (stringProjectOwner.length) {
            
            [dictItems_To_Copy setValue:stringProjectOwner forKey:@"user"];
            
        }
        
        [arrayItems_To_Copy addObject: dictItems_To_Copy];
        
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
    
    if ([stringBuildType isEqualToString: @"dmg"]) {
        
        [dictPlist setValue:@"copy_from_dmg" forKey:@"installer_type"];
        
    }
    
    [dictPlist setValue:stringMinimum_os_version forKey:@"minimum_os_version"];
    [dictPlist setValue:stringName forKey:@"name"];
    
    if ([stringBuildType isEqualToString: @"pkg"]) {
        
        [dictPlist setValue:arrayReceipts forKey:@"receipts"];
        
    }
    
    else if ([stringBuildType isEqualToString: @"dmg"]) {
        
        [dictPlist setValue:arrayInstalls forKey:@"installs"];
        [dictPlist setValue:arrayItems_To_Copy forKey:@"items_to_copy"];
        
    }
    
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
