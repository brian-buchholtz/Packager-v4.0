//
//  Settings.m
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "Logger.h"

@implementation Settings {
    
}

+ (void)writeSettings:(NSString *)stringSettingsFile SettingsApplicationName:(NSString *)stringSettingsApplicationName SettingsApplicationVersion:(NSString *)stringSettingsApplicationVersion SettingsPreferencesLanguage:(NSString *)stringSettingsPreferencesLanguage SettingsPreferencesLogPath:(NSString *)stringSettingsPreferencesLogPath SettingsPreferencesComparisonKey:(NSString *)stringSettingsPreferencesComparisonKey SettingsPreferencesType:(NSString *)stringSettingsPreferencesType SettingsPreferencesReceipt:(NSString *)stringSettingsPreferencesReceipt SettingsPreferencesDevCert:(NSString *)stringSettingsPreferencesDevCert SettingsPreferencesIsSigned:(NSString *)stringSettingsPreferencesIsSigned SettingsPreferencesDevId:(NSString *)stringSettingsPreferencesDevId SettingsPreferencesIsNotarized:(NSString *)stringSettingsPreferencesIsNotarized SettingsPreferencesOwner:(NSString *)stringSettingsPreferencesOwner SettingsPreferencesGroup:(NSString *)stringSettingsPreferencesGroup SettingsPreferencesPermissions:(NSString *)stringSettingsPreferencesPermissions SettingsPreferencesVersionPackageName:(NSString *)stringSettingsPreferencesVersionPackageName SettingsPreferencesVersionPlistName:(NSString *)stringSettingsPreferencesVersionPlistName SettingsPreferencesDateTimePackageName:(NSString *)stringSettingsPreferencesDateTimePackageName SettingsPreferencesDateTimePlistName:(NSString *)stringSettingsPreferencesDateTimePlistName SettingsPreferencesPackageTypePlistName:(NSString *)stringSettingsPreferencesPackageTypePlistName SettingsPreferencesOpenLastProject:(NSString *)stringSettingsPreferencesOpenLastProject SettingsPreferencesLastProjectFile:(NSString *)stringSettingsPreferencesLastProjectFile {
    
    // Settings root
    NSXMLElement *elementSettings = (NSXMLElement *)[NSXMLNode elementWithName:@"Settings"];
    
    // Application metadata
    NSXMLElement *elementApplication = [[NSXMLElement alloc] initWithName:@"Application"];
    [elementSettings addChild:elementApplication];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringSettingsApplicationName]];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringSettingsApplicationVersion]];
    
    // Application preferences
    NSXMLElement *elementPreferences = [[NSXMLElement alloc] initWithName:@"Preferences"];
    [elementSettings addChild:elementPreferences];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Language" stringValue:stringSettingsPreferencesLanguage]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"LogPath" stringValue:stringSettingsPreferencesLogPath]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"ComparisonKey" stringValue:stringSettingsPreferencesComparisonKey]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Type" stringValue:stringSettingsPreferencesType]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Receipt" stringValue:stringSettingsPreferencesReceipt]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"DevCert" stringValue:stringSettingsPreferencesDevCert]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"IsSigned" stringValue:stringSettingsPreferencesIsSigned]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"DevId" stringValue:stringSettingsPreferencesDevId]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"IsNotarized" stringValue:stringSettingsPreferencesIsNotarized]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Owner" stringValue:stringSettingsPreferencesOwner]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Group" stringValue:stringSettingsPreferencesGroup]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"Permissions" stringValue:stringSettingsPreferencesPermissions]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"VersionPackageName" stringValue:stringSettingsPreferencesVersionPackageName]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"VersionPlistName" stringValue:stringSettingsPreferencesVersionPlistName]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"DateTimePackageName" stringValue:stringSettingsPreferencesDateTimePackageName]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"DateTimePlistName" stringValue:stringSettingsPreferencesDateTimePlistName]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"PackageTypePlistName" stringValue:stringSettingsPreferencesPackageTypePlistName]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"OpenLastProject" stringValue:stringSettingsPreferencesOpenLastProject]];
    [elementPreferences addAttribute:[NSXMLNode attributeWithName:@"LastProjectFile" stringValue:stringSettingsPreferencesLastProjectFile]];
    
    // Document properties
    NSXMLDocument *xmlSettings = [NSXMLDocument documentWithRootElement:elementSettings];
    [xmlSettings setVersion:@"1.0"];
    [xmlSettings setCharacterEncoding:@"UTF-8"];
    
    // Log
    NSLog(@"XML Document\n%@", xmlSettings);
    
    // Write settings file
    NSData *dataXml = [xmlSettings XMLDataWithOptions:NSXMLNodePrettyPrint];
    [dataXml writeToFile:stringSettingsFile atomically:YES];
    
    [Logger setLogEvent:@"Saving settings file: ", stringSettingsFile, nil];
    
}

- (NSDictionary *)readSettings:(NSString *)stringSettingsFile {
    
    // Open settings file
    NSXMLDocument *xmlSettings;
    NSError *error = nil;
    NSURL *urlSettingsFile = [NSURL fileURLWithPath:stringSettingsFile];
    
    [Logger setLogEvent:@"Opening settings file: ", stringSettingsFile, nil];
    
    // Parse XML
    xmlSettings = [[NSXMLDocument alloc] initWithContentsOfURL:urlSettingsFile
                                                      options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                        error:&error];
    
    // Settings Application Name
    NSArray *arraySettingsApplicationName = [xmlSettings nodesForXPath:@"./Settings/Application/@Name" error:&error];
    NSXMLElement *elementSettingsApplicationName = [arraySettingsApplicationName objectAtIndex:0];
    
    // Settings Application Version
    NSArray *arraySettingsApplicationVersion = [xmlSettings nodesForXPath:@"./Settings/Application/@Version" error:&error];
    NSXMLElement *elementSettingsApplicationVersion = [arraySettingsApplicationVersion objectAtIndex:0];
    
    // Settings Preferences Language
    NSArray *arraySettingsPreferencesLanguage = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Language" error:&error];
    NSXMLElement *elementSettingsPreferencesLanguage = [arraySettingsPreferencesLanguage objectAtIndex:0];
    
    // Settings Preferences Log Path
    NSArray *arraySettingsPreferencesLogPath = [xmlSettings nodesForXPath:@"./Settings/Preferences/@LogPath" error:&error];
    NSXMLElement *elementSettingsPreferencesLogPath = [arraySettingsPreferencesLogPath objectAtIndex:0];
    
    // Settings Preferences Comparison Key
    NSArray *arraySettingsPreferencesComparisonKey = [xmlSettings nodesForXPath:@"./Settings/Preferences/@ComparisonKey" error:&error];
    NSXMLElement *elementSettingsPreferencesComparisonKey = [arraySettingsPreferencesComparisonKey objectAtIndex:0];
    
    // Settings Preferences Type
    NSArray *arraySettingsPreferencesType = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Type" error:&error];
    NSXMLElement *elementSettingsPreferencesType = [arraySettingsPreferencesType objectAtIndex:0];
    
    // Settings Preferences Receipt
    NSArray *arraySettingsPreferencesReceipt = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Receipt" error:&error];
    NSXMLElement *elementSettingsPreferencesReceipt = [arraySettingsPreferencesReceipt objectAtIndex:0];
    
    // Settings Preferences Dev Cert
    NSArray *arraySettingsPreferencesDevCert = [xmlSettings nodesForXPath:@"./Settings/Preferences/@DevCert" error:&error];
    NSXMLElement *elementSettingsPreferencesDevCert = [arraySettingsPreferencesDevCert objectAtIndex:0];
    
    // Settings Preferences Is Signed
    NSArray *arraySettingsPreferencesIsSigned = [xmlSettings nodesForXPath:@"./Settings/Preferences/@IsSigned" error:&error];
    NSXMLElement *elementSettingsPreferencesIsSigned = [arraySettingsPreferencesIsSigned objectAtIndex:0];
    
    // Settings Preferences Dev ID
    NSArray *arraySettingsPreferencesDevId = [xmlSettings nodesForXPath:@"./Settings/Preferences/@DevId" error:&error];
    NSXMLElement *elementSettingsPreferencesDevId = [arraySettingsPreferencesDevId objectAtIndex:0];
    
    // Settings Preferences Is Notarized
    NSArray *arraySettingsPreferencesIsNotarized = [xmlSettings nodesForXPath:@"./Settings/Preferences/@IsNotarized" error:&error];
    NSXMLElement *elementSettingsPreferencesIsNotarized = [arraySettingsPreferencesIsNotarized objectAtIndex:0];
    
    // Settings Preferences Owner
    NSArray *arraySettingsPreferencesOwner = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Owner" error:&error];
    NSXMLElement *elementSettingsPreferencesOwner = [arraySettingsPreferencesOwner objectAtIndex:0];
    
    // Settings Preferences Group
    NSArray *arraySettingsPreferencesGroup = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Group" error:&error];
    NSXMLElement *elementSettingsPreferencesGroup = [arraySettingsPreferencesGroup objectAtIndex:0];
    
    // Settings Preferences Permissions
    NSArray *arraySettingsPreferencesPermissions = [xmlSettings nodesForXPath:@"./Settings/Preferences/@Permissions" error:&error];
    NSXMLElement *elementSettingsPreferencesPermissions = [arraySettingsPreferencesPermissions objectAtIndex:0];
    
    // Settings Preferences Version Package Name
    NSArray *arraySettingsPreferencesVersionPackageName = [xmlSettings nodesForXPath:@"./Settings/Preferences/@VersionPackageName" error:&error];
    NSXMLElement *elementSettingsPreferencesVersionPackageName = [arraySettingsPreferencesVersionPackageName objectAtIndex:0];
    
    // Settings Preferences Version Plist Name
    NSArray *arraySettingsPreferencesVersionPlistName = [xmlSettings nodesForXPath:@"./Settings/Preferences/@VersionPlistName" error:&error];
    NSXMLElement *elementSettingsPreferencesVersionPlistName = [arraySettingsPreferencesVersionPlistName objectAtIndex:0];
    
    // Settings Preferences Date Time Package Name
    NSArray *arraySettingsPreferencesDateTimePackageName = [xmlSettings nodesForXPath:@"./Settings/Preferences/@DateTimePackageName" error:&error];
    NSXMLElement *elementSettingsPreferencesDateTimePackageName = [arraySettingsPreferencesDateTimePackageName objectAtIndex:0];
    
    // Settings Preferences Date Time Plist Name
    NSArray *arraySettingsPreferencesDateTimePlistName = [xmlSettings nodesForXPath:@"./Settings/Preferences/@DateTimePlistName" error:&error];
    NSXMLElement *elementSettingsPreferencesDateTimePlistName = [arraySettingsPreferencesDateTimePlistName objectAtIndex:0];
    
    // Settings Preferences Package Type Plist Name
    NSArray *arraySettingsPreferencesPackageTypePlistName = [xmlSettings nodesForXPath:@"./Settings/Preferences/@PackageTypePlistName" error:&error];
    NSXMLElement *elementSettingsPreferencesPackageTypePlistName = [arraySettingsPreferencesPackageTypePlistName objectAtIndex:0];
    
    // Settings Preferences Open Last Project
    NSArray *arraySettingsPreferencesOpenLastProject = [xmlSettings nodesForXPath:@"./Settings/Preferences/@OpenLastProject" error:&error];
    NSXMLElement *elementSettingsPreferencesOpenLastProject = [arraySettingsPreferencesOpenLastProject objectAtIndex:0];
    
    // Settings Preferences Last Project File
    NSArray *arraySettingsPreferencesLastProjectFile = [xmlSettings nodesForXPath:@"./Settings/Preferences/@LastProjectFile" error:&error];
    NSXMLElement *elementSettingsPreferencesLastProjectFile = [arraySettingsPreferencesLastProjectFile objectAtIndex:0];
    
    [Logger setLogEvent:@"Parsing settings file: ", stringSettingsFile, nil];
    
    // Settings dictionary
    return @{@"SettingsApplicationName":elementSettingsApplicationName.stringValue,
             @"SettingsApplicationVersion":elementSettingsApplicationVersion.stringValue,
             @"SettingsPreferencesLanguage":elementSettingsPreferencesLanguage.stringValue,
             @"SettingsPreferencesLogPath":elementSettingsPreferencesLogPath.stringValue,
             @"SettingsPreferencesComparisonKey":elementSettingsPreferencesComparisonKey.stringValue,
             @"SettingsPreferencesType":elementSettingsPreferencesType.stringValue,
             @"SettingsPreferencesReceipt":elementSettingsPreferencesReceipt.stringValue,
             @"SettingsPreferencesDevCert":elementSettingsPreferencesDevCert.stringValue,
             @"SettingsPreferencesIsSigned":elementSettingsPreferencesIsSigned.stringValue,
             @"SettingsPreferencesDevId":elementSettingsPreferencesDevId.stringValue,
             @"SettingsPreferencesIsNotarized":elementSettingsPreferencesIsNotarized.stringValue,
             @"SettingsPreferencesOwner":elementSettingsPreferencesOwner.stringValue,
             @"SettingsPreferencesGroup":elementSettingsPreferencesGroup.stringValue,
             @"SettingsPreferencesPermissions":elementSettingsPreferencesPermissions.stringValue,
             @"SettingsPreferencesVersionPackageName":elementSettingsPreferencesVersionPackageName.stringValue,
             @"SettingsPreferencesVersionPlistName":elementSettingsPreferencesVersionPlistName.stringValue,
             @"SettingsPreferencesDateTimePackageName":elementSettingsPreferencesDateTimePackageName.stringValue,
             @"SettingsPreferencesDateTimePlistName":elementSettingsPreferencesDateTimePlistName.stringValue,
             @"SettingsPreferencesPackageTypePlistName":elementSettingsPreferencesPackageTypePlistName.stringValue,
             @"SettingsPreferencesOpenLastProject":elementSettingsPreferencesOpenLastProject.stringValue,
             @"SettingsPreferencesLastProjectFile":elementSettingsPreferencesLastProjectFile.stringValue};
    
}

@end
