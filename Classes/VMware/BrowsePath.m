//
//  BrowsePath.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BrowsePath.h"
#import "Logger.h"

@implementation BrowsePath {
    
}

- (NSString *)getPath:(NSString *)stringBasePath {
    
    // Return filename
    NSString *stringBrowsePath;
    
    // Create a File Open Dialog class
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    
    // Enable options in the dialog
    [openDialog setDirectoryURL:[NSURL fileURLWithPath:stringBasePath]];
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setCanCreateDirectories:YES];
    [openDialog setAllowsMultipleSelection:NO];
    
    // Display the dialog box; If OK is pressed, process the files
    if ([openDialog runModal] == NSModalResponseOK) {
        
        NSURL *urlBrowsePath = openDialog.URL;
        stringBrowsePath = urlBrowsePath.path;

        // Write to logger
        [Logger setLogEvent:@"Browse path: ", stringBrowsePath, nil];
        
    }
    
    else {
        
        // Handle file picker cancel
        stringBrowsePath = nil;
        
        [Logger setLogEvent:@"Browse path: Cancelled - User initiated", nil];
        
    }
    
    // Return picked file
    return stringBrowsePath;
    
}

@end
