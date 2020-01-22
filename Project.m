//
//  Project.m
//  Packager
//
//  Created by Brian Buchholtz on 11/12/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Logger.h"

@implementation Project {
    
}

+ (void)writeProject:(NSString *)stringProjectFile ApplicationName:(NSString *)stringApplicationName ApplicationVersion:(NSString *)stringApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectRoot:(NSString *)stringProjectRoot ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget ProjectSign:(NSString *)stringProjectSign ProjectIsSigned:(NSString *)stringProjectIsSigned ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions {
    
    // Settings root
    NSXMLElement *elementSettings = (NSXMLElement *)[NSXMLNode elementWithName:@"Settings"];
    
    // Application metadata
    NSXMLElement *elementApplication = [[NSXMLElement alloc] initWithName:@"Application"];
    [elementSettings addChild:elementApplication];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringApplicationName]];
    [elementApplication addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringApplicationVersion]];
    
    // Project metadata
    NSXMLElement *elementProject = [[NSXMLElement alloc] initWithName:@"Project"];
    [elementSettings addChild:elementProject];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringProjectName]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringProjectVersion]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Identifier" stringValue:stringProjectIdentifier]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Root" stringValue:stringProjectRoot]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Source" stringValue:stringProjectSource]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Target" stringValue:stringProjectTarget]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Sign" stringValue:stringProjectSign]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"IsSigned" stringValue:stringProjectIsSigned]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Owner" stringValue:stringProjectOwner]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Group" stringValue:stringProjectGroup]];
    [elementProject addAttribute:[NSXMLNode attributeWithName:@"Permissions" stringValue:stringProjectPermissions]];

    // Document properties
    NSXMLDocument *xmlProject = [NSXMLDocument documentWithRootElement:elementSettings];
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
    NSURL *furl = [NSURL fileURLWithPath:stringProjectFile];
    
    [Logger setLogEvent:@"Opening project file: ", stringProjectFile, nil];
    
    // Parse XML
    xmlProject = [[NSXMLDocument alloc] initWithContentsOfURL:furl
                                                  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                    error:&error];
    
    // Application Name
    NSArray *arrayApplicationName = [xmlProject nodesForXPath:@"./Settings/Application/@Name" error:&error];
    NSXMLElement *elementApplicationName = [arrayApplicationName objectAtIndex:0];
    
    // Application Version
    NSArray *arrayApplicationVersion = [xmlProject nodesForXPath:@"./Settings/Application/@Version" error:&error];
    NSXMLElement *elementApplicationVersion = [arrayApplicationVersion objectAtIndex:0];
    
    // Project Name
    NSArray *arrayProjectName = [xmlProject nodesForXPath:@"./Settings/Project/@Name" error:&error];
    NSXMLElement *elementProjectName = [arrayProjectName objectAtIndex:0];
    
    // Project Version
    NSArray *arrayProjectVersion = [xmlProject nodesForXPath:@"./Settings/Project/@Version" error:&error];
    NSXMLElement *elementProjectVersion = [arrayProjectVersion objectAtIndex:0];
    
    // Project Identifier
    NSArray *arrayProjectIdentifier = [xmlProject nodesForXPath:@"./Settings/Project/@Identifier" error:&error];
    NSXMLElement *elementProjectIdentifier = [arrayProjectIdentifier objectAtIndex:0];
    
    // Project Root
    NSArray *arrayProjectRoot = [xmlProject nodesForXPath:@"./Settings/Project/@Root" error:&error];
    NSXMLElement *elementProjectRoot = [arrayProjectRoot objectAtIndex:0];
    
    // Project Source
    NSArray *arrayProjectSource = [xmlProject nodesForXPath:@"./Settings/Project/@Source" error:&error];
    NSXMLElement *elementProjectSource = [arrayProjectSource objectAtIndex:0];
    
    // Project Target
    NSArray *arrayProjectTarget = [xmlProject nodesForXPath:@"./Settings/Project/@Target" error:&error];
    NSXMLElement *elementProjectTarget = [arrayProjectTarget objectAtIndex:0];
    
    // Project Sign
    NSArray *arrayProjectSign = [xmlProject nodesForXPath:@"./Settings/Project/@Sign" error:&error];
    NSXMLElement *elementProjectSign = [arrayProjectSign objectAtIndex:0];
    
    // Project Is Signed
    NSArray *arrayProjectIsSigned = [xmlProject nodesForXPath:@"./Settings/Project/@IsSigned" error:&error];
    NSXMLElement *elementProjectIsSigned = [arrayProjectIsSigned objectAtIndex:0];
    
    // Project Owner
    NSArray *arrayProjectOwner = [xmlProject nodesForXPath:@"./Settings/Project/@Owner" error:&error];
    NSXMLElement *elementProjectOwner = [arrayProjectOwner objectAtIndex:0];
    
    // Project Group
    NSArray *arrayProjectGroup = [xmlProject nodesForXPath:@"./Settings/Project/@Group" error:&error];
    NSXMLElement *elementProjectGroup = [arrayProjectGroup objectAtIndex:0];
    
    // Project Permissions
    NSArray *arrayProjectPermissions = [xmlProject nodesForXPath:@"./Settings/Project/@Permissions" error:&error];
    NSXMLElement *elementProjectPermissions = [arrayProjectPermissions objectAtIndex:0];
    
    [Logger setLogEvent:@"Parsing project file: ", stringProjectFile, nil];
    
    // Project dictionary
    return @{@"ApplicationName":elementApplicationName.stringValue,
             @"ApplicationVersion":elementApplicationVersion.stringValue,
             @"ProjectName":elementProjectName.stringValue,
             @"ProjectVersion":elementProjectVersion.stringValue,
             @"ProjectIdentifier":elementProjectIdentifier.stringValue,
             @"ProjectRoot":elementProjectRoot.stringValue,
             @"ProjectSource":elementProjectSource.stringValue,
             @"ProjectTarget":elementProjectTarget.stringValue,
             @"ProjectSign":elementProjectSign.stringValue,
             @"ProjectIsSigned":elementProjectIsSigned.stringValue,
             @"ProjectOwner":elementProjectOwner.stringValue,
             @"ProjectGroup":elementProjectGroup.stringValue,
             @"ProjectPermissions":elementProjectPermissions.stringValue};
    
}

@end
