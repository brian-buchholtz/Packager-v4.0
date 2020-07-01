//
//  ProjectManifest.m
//  Packager
//
//  Created by Brian Buchholtz on 1/16/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "ProjectManifest.h"

// Not playing nice with UEM
#import "FileSize.h"
#import "Md5.h"

#import "Logger.h"

@implementation ProjectManifest {
    
}

- (NSArray *)getProjectManifest:(NSString *)stringProjectSource ProjectInstall:(NSString *)stringProjectInstall {
    
    // Array to return
    NSMutableArray *arrayProjectManifest = [[NSMutableArray alloc] init];
    
    // Native way of building manifest
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *urlProjectSource = [NSURL fileURLWithPath:stringProjectSource];
    NSArray *arrayKey = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumDirectory = [fileManager
                                            enumeratorAtURL:urlProjectSource
                                            includingPropertiesForKeys:arrayKey
                                            options:0
                                            errorHandler:^BOOL(NSURL *urlProjectSourceItem, NSError *error) {
                                                // Handle the error.
                                                // Return YES if the enumeration should continue after the error.
                                                return YES;
                                            }];
    
    for (NSURL *urlProjectSourceItem in enumDirectory) {
        
        NSError *error;
        NSNumber *numberIsDirectory = nil;
        
        if (![urlProjectSourceItem getResourceValue:&numberIsDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            
            [Logger setLogEvent:@"Error creating manifect:\n", error, nil];
            
        }
        
        else if (![numberIsDirectory boolValue]) {
            
            // Remove .DS_Store from manifest
            if ([urlProjectSourceItem.lastPathComponent rangeOfString:@".DS_Store"].location == NSNotFound) {
                
                // No error and it’s not a directory; do something with the file
                NSString *stringProjectSourcePath = [urlProjectSourceItem path];
                
                // Check for source trailing slash
                NSString *stringSourceLastChar = [stringProjectSourcePath substringFromIndex:[stringProjectSourcePath length] - 1];
                NSString *stringSourcePrefix = @"";
                
                if (![stringSourceLastChar isEqualToString:@"/"]) {
                    
                    stringSourcePrefix = [NSString stringWithFormat:@"%@/", stringProjectSource];
                    
                }
                
                else {
                    
                    stringSourcePrefix = stringProjectSource;
                    
                }
                
                NSString *stringSourceItem = [stringProjectSourcePath copy];
                
                if ([stringProjectSourcePath hasPrefix:stringSourcePrefix]) {
                    
                    // Check for install trailing slash
                    NSString *stringInstallLastChar = [stringProjectInstall substringFromIndex:[stringProjectInstall length] - 1];
                    NSString *stringInstallPrefix = @"";
                    
                    if (![stringInstallLastChar isEqualToString:@"/"]) {
                        
                        stringInstallPrefix = [NSString stringWithFormat:@"%@/", stringProjectInstall];
                        
                    }
                    
                    else {
                        
                        stringInstallPrefix = stringProjectInstall;
                        
                    }
                    
                    // Create manifest dictionary
                    NSMutableDictionary *dictProjectManifest = [NSMutableDictionary new];
                    
                    // source_path
                    [dictProjectManifest setValue:stringProjectSourcePath forKey:@"source_path"];
                    
                    // source_item
                    stringSourceItem = [stringProjectSourcePath substringFromIndex:[stringSourcePrefix length]];
                    [dictProjectManifest setValue:stringSourceItem forKey:@"source_item"];
                    
                    // path
                    NSString *stringPath = [NSString stringWithFormat:@"%@%@", stringInstallPrefix, stringSourceItem];
                    [dictProjectManifest setValue:stringPath forKey:@"path"];
                    
                    // destination_path
                    NSString *stringDestinationPath = [stringPath stringByDeletingLastPathComponent];
                    [dictProjectManifest setValue:stringDestinationPath forKey:@"destination_path"];
                    
                    // Not playing nice with UEM
                    // Needs clean-up
                    NSURL *urlProjectSourcePath = [NSURL fileURLWithPath:stringProjectSourcePath];
                    
                    // filename
                    NSString *stringFilePath = urlProjectSourcePath.path.stringByDeletingLastPathComponent;
                    NSString *stringFileName = urlProjectSourcePath.lastPathComponent;
                    [dictProjectManifest setValue:stringFileName forKey:@"filename"];
                    
                    // installed_size
                    NSNumber *numberFileSize = [FileSize getFileSize:stringFileName FilePath:stringFilePath];
                    [dictProjectManifest setValue:numberFileSize forKey:@"installed_size"];
                    
                    // md5checksum
                    NSString *stringMd5 = [Md5 getMd5:stringFileName FilePath:stringFilePath];
                    [dictProjectManifest setValue:stringMd5 forKey:@"md5checksum"];
                    
                    [Logger setLogEvent:@"Adding item to manifest: ", stringPath, nil];
                    
                    // Add manifest dictionary to returned array
                    [arrayProjectManifest addObject:dictProjectManifest];
                    
                }
                
            }
            
        }
        
    }
    
    return arrayProjectManifest;
    
}

@end
