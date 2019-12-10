//
//  BrowsePath.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "BrowsePath.h"
#import "Logger.h"

@implementation BrowsePath {
    
}

- (NSString*)getPath {
    
    // Return filename
    NSString *stringProjectHome;
    
    // Create a File Open Dialog class
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    
    // Enable options in the dialog
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setAllowsMultipleSelection:NO];
    
    // Display the dialog box; If OK is pressed, process the files
    if ([openDialog runModal] == NSModalResponseOK) {
        
        NSURL *urlProjectHome = openDialog.URL;
        stringProjectHome = urlProjectHome.path;

        // Write to logger
        [Logger setLogEvent:@"Setting project home: ", stringProjectHome, nil];
        
    }
    
    else {
        
        // Handle file picker cancel
        stringProjectHome = nil;
        
        [Logger setLogEvent:@"Setting project home: Cancelled - User Initiated", nil];
        
    }
    
    // Return picked file
    return stringProjectHome;
    
}

@end
