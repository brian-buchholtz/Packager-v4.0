//
//  FilePicker.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FilePicker.h"
#import "Logger.h"

@implementation FilePicker {
    
}

- (NSString*)getFile {
    
    // Return filename
    NSString *stringProjectFile;
    
    // Create a File Open Dialog class
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray<NSString*> *fileTypesArray = @[@"packager", @"Packager", @"PACKAGER"];
    
    // Enable options in the dialog
    [openDialog setCanChooseFiles:YES];
    [openDialog setCanChooseDirectories:NO];
    [openDialog setAllowedFileTypes:fileTypesArray];
    [openDialog setAllowsMultipleSelection:NO];
    
    // Display the dialog box; If OK is pressed, process the files
    if ([openDialog runModal] == NSModalResponseOK) {
   
        // Get file URL
        NSURL *urlProjectFile = openDialog.URL;
        stringProjectFile = urlProjectFile.path;
            
        // Write to logger
        [Logger setLogEvent:@"Picking existing project file: ", stringProjectFile, nil];
        
    }
    
    else {
        
        // Handle file picker cancel
        stringProjectFile = nil;
        
        [Logger setLogEvent:@"Picking existing project file: Cancelled - User Initiated", nil];
        
    }

    // Return picked file
    return stringProjectFile;
    
}

@end
