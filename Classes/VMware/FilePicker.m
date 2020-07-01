//
//  FilePicker.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FilePicker.h"
#import "Logger.h"

@implementation FilePicker {
    
}

- (NSString *)getFile:(NSArray *)arrayFileTypes {
    
    // Return filename
    NSString *stringPickFile;
    
    // Create a File Open Dialog class
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    
    // Enable options in the dialog
    [openDialog setCanChooseFiles:YES];
    [openDialog setCanChooseDirectories:NO];
    [openDialog setAllowedFileTypes:arrayFileTypes];
    [openDialog setAllowsMultipleSelection:NO];
    
    // Display the dialog box; If OK is pressed, process the files
    if ([openDialog runModal] == NSModalResponseOK) {
   
        // Get file URL
        NSURL *urlPickFile = openDialog.URL;
        stringPickFile = urlPickFile.path;
            
        // Write to logger
        [Logger setLogEvent:@"Picking file: ", stringPickFile, nil];
        
    }
    
    else {
        
        // Handle file picker cancel
        stringPickFile = nil;
        
        [Logger setLogEvent:@"Picking file: Cancelled - User initiated", nil];
        
    }

    // Return picked file
    return stringPickFile;
    
}

@end
