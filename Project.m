//
//  Project.m
//  Packager
//
//  Created by Brian Buchholtz on 11/12/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Logger.h"

@implementation Project {
    
}

+ (void)writeProject:(NSString *)stringProjectFile ApplicationName:(NSString *)stringApplicationName ApplicationVersion:(NSString *)stringApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectHome:(NSString *)stringProjectHome ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions {
    
    // Settings root
    NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"Settings"];
    
    // Application metadata
    NSXMLElement *application = [[NSXMLElement alloc] initWithName:@"Application"];
    [root addChild:application];
    [application addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringApplicationName]];
    [application addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringApplicationVersion]];
    
    // Project metadata
    NSXMLElement *project = [[NSXMLElement alloc] initWithName:@"Project"];
    [root addChild:project];
    [project addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:stringProjectName]];
    [project addAttribute:[NSXMLNode attributeWithName:@"Version" stringValue:stringProjectVersion]];
    [project addAttribute:[NSXMLNode attributeWithName:@"Home" stringValue:stringProjectHome]];
    [project addAttribute:[NSXMLNode attributeWithName:@"Owner" stringValue:stringProjectOwner]];
    [project addAttribute:[NSXMLNode attributeWithName:@"Group" stringValue:stringProjectGroup]];
    [project addAttribute:[NSXMLNode attributeWithName:@"Permissions" stringValue:stringProjectPermissions]];

    // Document properties
    NSXMLDocument *xmlProject = [NSXMLDocument documentWithRootElement:root];
    [xmlProject setVersion:@"1.0"];
    [xmlProject setCharacterEncoding:@"UTF-8"];
    
    // Log
    NSLog(@"XML Document\n%@", xmlProject);
    
    // Write project file
    NSData *xmlData = [xmlProject XMLDataWithOptions:NSXMLNodePrettyPrint];
    [xmlData writeToFile:stringProjectFile atomically:YES];
    
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
    NSXMLElement *elementApplicationName;
    elementApplicationName = [arrayApplicationName objectAtIndex:0];
    
    // Application Version
    NSArray *arrayApplicationVersion = [xmlProject nodesForXPath:@"./Settings/Application/@Version" error:&error];
    NSXMLElement *elementApplicationVersion;
    elementApplicationVersion = [arrayApplicationVersion objectAtIndex:0];
    
    // Project Name
    NSArray *arrayProjectName = [xmlProject nodesForXPath:@"./Settings/Project/@Name" error:&error];
    NSXMLElement *elementProjectName;
    elementProjectName = [arrayProjectName objectAtIndex:0];
    
    // Project Version
    NSArray *arrayProjectVersion = [xmlProject nodesForXPath:@"./Settings/Project/@Version" error:&error];
    NSXMLElement *elementProjectVersion;
    elementProjectVersion = [arrayProjectVersion objectAtIndex:0];
    
    // Project Home
    NSArray *arrayProjectHome = [xmlProject nodesForXPath:@"./Settings/Project/@Home" error:&error];
    NSXMLElement *elementProjectHome;
    elementProjectHome = [arrayProjectHome objectAtIndex:0];
    
    // Project Owner
    NSArray *arrayProjectOwner = [xmlProject nodesForXPath:@"./Settings/Project/@Owner" error:&error];
    NSXMLElement *elementProjectOwner;
    elementProjectOwner = [arrayProjectOwner objectAtIndex:0];
    
    // Project Group
    NSArray *arrayProjectGroup = [xmlProject nodesForXPath:@"./Settings/Project/@Group" error:&error];
    NSXMLElement *elementProjectGroup;
    elementProjectGroup = [arrayProjectGroup objectAtIndex:0];
    
    // Project Permissions
    NSArray *arrayProjectPermissions = [xmlProject nodesForXPath:@"./Settings/Project/@Permissions" error:&error];
    NSXMLElement *elementProjectPermissions;
    elementProjectPermissions = [arrayProjectPermissions objectAtIndex:0];
    
    [Logger setLogEvent:@"Parsing project file: ", stringProjectFile, nil];
    
    // Project dictionary
    return @{@"ApplicationName":elementApplicationName.stringValue,
             @"ApplicationVersion":elementApplicationVersion.stringValue,
             @"ProjectName":elementProjectName.stringValue,
             @"ProjectVersion":elementProjectVersion.stringValue,
             @"ProjectHome":elementProjectHome.stringValue,
             @"ProjectOwner":elementProjectOwner.stringValue,
             @"ProjectGroup":elementProjectGroup.stringValue,
             @"ProjectPermissions":elementProjectPermissions.stringValue};
    
}

@end
