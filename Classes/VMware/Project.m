//
//  Project.m
//  Packager
//
//  Created by Brian Buchholtz on 11/12/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Logger.h"

@implementation Project {
    
}

+ (void)writeProject:(NSString *)stringProjectFile ProjectApplicationName:(NSString *)stringProjectApplicationName ProjectApplicationVersion:(NSString *)stringProjectApplicationVersion ProjectMetadataName:(NSString *)stringProjectMetadataName ProjectMetadataIdentifier:(NSString *)stringProjectMetadataIdentifier ProjectMetadataVersion:(NSString *)stringProjectMetadataVersion ProjectMetadataShortVersion:(NSString *)stringProjectMetadataShortVersion ProjectMetadataComparisonKey:(NSString *)stringProjectMetadataComparisonKey ProjectMetadataType:(NSString *)stringProjectMetadataType ProjectMetadataReceipt:(NSString *)stringProjectMetadataReceipt ProjectMetadataInstall:(NSString *)stringProjectMetadataInstall ProjectMetadataScripts:(NSString *)stringProjectMetadataScripts ProjectMetadataOwner:(NSString *)stringProjectMetadataOwner ProjectMetadataGroup:(NSString *)stringProjectMetadataGroup ProjectMetadataPermissions:(NSString *)stringProjectMetadataPermissions ProjectMetadataDevCert:(NSString *)stringProjectMetadataDevCert ProjectMetadataDevId:(NSString *)stringProjectMetadataDevId ProjectMetadataSource:(NSString *)stringProjectMetadataSource ProjectMetadataTarget:(NSString *)stringProjectMetadataTarget ProjectMetadataRunScripts:(NSString *)stringProjectMetadataRunScripts ProjectMetadataIsSigned:(NSString *)stringProjectMetadataIsSigned ProjectMetadataIsNotarized:(NSString *)stringProjectMetadataIsNotarized {
    
    // Project root
    NSXMLElement *elementProject = (NSXMLElement *)[NSXMLNode elementWithName:@"Project"];
    
    // Application metadata
    NSXMLElement *elementApplication = [[NSXMLElement alloc] initWithName:@"Application"];
    [elementProject addChild:elementApplication];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringProjectApplicationName]];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringProjectApplicationVersion]];
    
    // Project metadata
    NSXMLElement *elementMetadata = [[NSXMLElement alloc] initWithName:@"Metadata"];
    [elementProject addChild:elementMetadata];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringProjectMetadataName]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Identifier" stringValue:stringProjectMetadataIdentifier]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringProjectMetadataVersion]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"ShortVersion" stringValue:stringProjectMetadataShortVersion]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"ComparisonKey" stringValue:stringProjectMetadataComparisonKey]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Type" stringValue:stringProjectMetadataType]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Receipt" stringValue:stringProjectMetadataReceipt]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Install" stringValue:stringProjectMetadataInstall]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Scripts" stringValue:stringProjectMetadataScripts]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Owner" stringValue:stringProjectMetadataOwner]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Group" stringValue:stringProjectMetadataGroup]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Permissions" stringValue:stringProjectMetadataPermissions]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"DevCert" stringValue:stringProjectMetadataDevCert]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"DevId" stringValue:stringProjectMetadataDevId]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Source" stringValue:stringProjectMetadataSource]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"Target" stringValue:stringProjectMetadataTarget]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"RunScripts" stringValue:stringProjectMetadataRunScripts]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"IsSigned" stringValue:stringProjectMetadataIsSigned]];
    [elementMetadata addAttribute:[NSXMLNode attributeWithName:@"IsNotarized" stringValue:stringProjectMetadataIsNotarized]];
    
    // Document properties
    NSXMLDocument *xmlProject = [NSXMLDocument documentWithRootElement:elementProject];
    [xmlProject setVersion:@"1.0"];
    [xmlProject setCharacterEncoding:@"UTF-8"];
    
    // Log
    NSLog(@"XML Document\n%@", xmlProject);
    
    // Write project file
    NSData *dataXml = [xmlProject XMLDataWithOptions:NSXMLNodePrettyPrint];
    [dataXml writeToFile:stringProjectFile atomically:YES];
    
    [Logger setLogEvent:@"Saving project file: ", stringProjectFile, nil];
    
 }

- (NSDictionary *)readProject:(NSString *)stringProjectFile {
    
    // Open project file
    NSXMLDocument *xmlProject;
    NSError *error = nil;
    NSURL *urlProjectFile = [NSURL fileURLWithPath:stringProjectFile];
    
    [Logger setLogEvent:@"Opening project file: ", stringProjectFile, nil];
    
    // Parse XML
    xmlProject = [[NSXMLDocument alloc] initWithContentsOfURL:urlProjectFile
                                                  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                    error:&error];
    
    // Project Application Name
    NSArray *arrayProjectApplicationName = [xmlProject nodesForXPath:@"./Project/Application/@Name" error:&error];
    NSXMLElement *elementProjectApplicationName = [arrayProjectApplicationName objectAtIndex:0];
    
    // Project Application Version
    NSArray *arrayProjectApplicationVersion = [xmlProject nodesForXPath:@"./Project/Application/@Version" error:&error];
    NSXMLElement *elementProjectApplicationVersion = [arrayProjectApplicationVersion objectAtIndex:0];
    
    // Project Metadata Name
    NSArray *arrayProjectMetadataName = [xmlProject nodesForXPath:@"./Project/Metadata/@Name" error:&error];
    NSXMLElement *elementProjectMetadataName = [arrayProjectMetadataName objectAtIndex:0];
    
    // Project Metadata Identifier
    NSArray *arrayProjectMetadataIdentifier = [xmlProject nodesForXPath:@"./Project/Metadata/@Identifier" error:&error];
    NSXMLElement *elementProjectMetadataIdentifier = [arrayProjectMetadataIdentifier objectAtIndex:0];
    
    // Project Metadata Version
    NSArray *arrayProjectMetadataVersion = [xmlProject nodesForXPath:@"./Project/Metadata/@Version" error:&error];
    NSXMLElement *elementProjectMetadataVersion = [arrayProjectMetadataVersion objectAtIndex:0];
    
    // Project Metadata Short Version
    NSArray *arrayProjectMetadataShortVersion = [xmlProject nodesForXPath:@"./Project/Metadata/@ShortVersion" error:&error];
    NSXMLElement *elementProjectMetadataShortVersion = [arrayProjectMetadataShortVersion objectAtIndex:0];
    
    // Project Metadata Comparison Key
    NSArray *arrayProjectMetadataComparisonKey = [xmlProject nodesForXPath:@"./Project/Metadata/@ComparisonKey" error:&error];
    NSXMLElement *elementProjectMetadataComparisonKey = [arrayProjectMetadataComparisonKey objectAtIndex:0];
    
    // Project Metadata Type
    NSArray *arrayProjectMetadataType = [xmlProject nodesForXPath:@"./Project/Metadata/@Type" error:&error];
    NSXMLElement *elementProjectMetadataType = [arrayProjectMetadataType objectAtIndex:0];
    
    // Project Metadata Receipt
    NSArray *arrayProjectMetadataReceipt = [xmlProject nodesForXPath:@"./Project/Metadata/@Receipt" error:&error];
    NSXMLElement *elementProjectMetadataReceipt = [arrayProjectMetadataReceipt objectAtIndex:0];
    
    // Project Metadata Install
    NSArray *arrayProjectMetadataInstall = [xmlProject nodesForXPath:@"./Project/Metadata/@Install" error:&error];
    NSXMLElement *elementProjectMetadataInstall = [arrayProjectMetadataInstall objectAtIndex:0];
    
    // Project Metadata Scripts
    NSArray *arrayProjectMetadataScripts = [xmlProject nodesForXPath:@"./Project/Metadata/@Scripts" error:&error];
    NSXMLElement *elementProjectMetadataScripts = [arrayProjectMetadataScripts objectAtIndex:0];
    
    // Project Metadata Owner
    NSArray *arrayProjectMetadataOwner = [xmlProject nodesForXPath:@"./Project/Metadata/@Owner" error:&error];
    NSXMLElement *elementProjectMetadataOwner = [arrayProjectMetadataOwner objectAtIndex:0];
    
    // Project Metadata Group
    NSArray *arrayProjectMetadataGroup = [xmlProject nodesForXPath:@"./Project/Metadata/@Group" error:&error];
    NSXMLElement *elementProjectMetadataGroup = [arrayProjectMetadataGroup objectAtIndex:0];
    
    // Project Metadata Permissions
    NSArray *arrayProjectMetadataPermissions = [xmlProject nodesForXPath:@"./Project/Metadata/@Permissions" error:&error];
    NSXMLElement *elementProjectMetadataPermissions = [arrayProjectMetadataPermissions objectAtIndex:0];
    
    // Project Metadata Dev Cert
    NSArray *arrayProjectMetadataDevCert = [xmlProject nodesForXPath:@"./Project/Metadata/@DevCert" error:&error];
    NSXMLElement *elementProjectMetadataDevCert = [arrayProjectMetadataDevCert objectAtIndex:0];
    
    // Project Metadata Dev ID
    NSArray *arrayProjectMetadataDevId = [xmlProject nodesForXPath:@"./Project/Metadata/@DevId" error:&error];
    NSXMLElement *elementProjectMetadataDevId = [arrayProjectMetadataDevId objectAtIndex:0];
    
    // Project Metadata Source
    NSArray *arrayProjectMetadataSource = [xmlProject nodesForXPath:@"./Project/Metadata/@Source" error:&error];
    NSXMLElement *elementProjectMetadataSource = [arrayProjectMetadataSource objectAtIndex:0];
    
    // Project Metadata Target
    NSArray *arrayProjectMetadataTarget = [xmlProject nodesForXPath:@"./Project/Metadata/@Target" error:&error];
    NSXMLElement *elementProjectMetadataTarget = [arrayProjectMetadataTarget objectAtIndex:0];
    
    // Project Metadata Run Scripts
    NSArray *arrayProjectMetadataRunScripts = [xmlProject nodesForXPath:@"./Project/Metadata/@RunScripts" error:&error];
    NSXMLElement *elementProjectMetadataRunScripts = [arrayProjectMetadataRunScripts objectAtIndex:0];
    
    // Project Metadata Is Signed
    NSArray *arrayProjectMetadataIsSigned = [xmlProject nodesForXPath:@"./Project/Metadata/@IsSigned" error:&error];
    NSXMLElement *elementProjectMetadataIsSigned = [arrayProjectMetadataIsSigned objectAtIndex:0];
    
    // Project Metadata Is Notarized
    NSArray *arrayProjectMetadataIsNotarized = [xmlProject nodesForXPath:@"./Project/Metadata/@IsNotarized" error:&error];
    NSXMLElement *elementProjectMetadataIsNotarized = [arrayProjectMetadataIsNotarized objectAtIndex:0];
    
    [Logger setLogEvent:@"Parsing project file: ", stringProjectFile, nil];
    
    // Project dictionary
    return @{@"ProjectApplicationName":elementProjectApplicationName.stringValue,
             @"ProjectApplicationVersion":elementProjectApplicationVersion.stringValue,
             @"ProjectMetadataName":elementProjectMetadataName.stringValue,
             @"ProjectMetadataIdentifier":elementProjectMetadataIdentifier.stringValue,
             @"ProjectMetadataVersion":elementProjectMetadataVersion.stringValue,
             @"ProjectMetadataShortVersion":elementProjectMetadataShortVersion.stringValue,
             @"ProjectMetadataComparisonKey":elementProjectMetadataComparisonKey.stringValue,
             @"ProjectMetadataType":elementProjectMetadataType.stringValue,
             @"ProjectMetadataReceipt":elementProjectMetadataReceipt.stringValue,
             @"ProjectMetadataInstall":elementProjectMetadataInstall.stringValue,
             @"ProjectMetadataScripts":elementProjectMetadataScripts.stringValue,
             @"ProjectMetadataOwner":elementProjectMetadataOwner.stringValue,
             @"ProjectMetadataGroup":elementProjectMetadataGroup.stringValue,
             @"ProjectMetadataPermissions":elementProjectMetadataPermissions.stringValue,
             @"ProjectMetadataDevCert":elementProjectMetadataDevCert.stringValue,
             @"ProjectMetadataDevId":elementProjectMetadataDevId.stringValue,
             @"ProjectMetadataSource":elementProjectMetadataSource.stringValue,
             @"ProjectMetadataTarget":elementProjectMetadataTarget.stringValue,
             @"ProjectMetadataRunScripts":elementProjectMetadataRunScripts.stringValue,
             @"ProjectMetadataIsSigned":elementProjectMetadataIsSigned.stringValue,
             @"ProjectMetadataIsNotarized":elementProjectMetadataIsNotarized.stringValue};
    
}

@end
