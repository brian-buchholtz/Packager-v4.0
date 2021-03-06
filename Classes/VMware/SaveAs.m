//
//  SaveAs.m
//  Packager
//
//  Created by Brian Buchholtz on 11/15/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "SaveAs.h"
#import "Logger.h"

@implementation SaveAs {
    
}

- (NSString *)newFile {
    
    // Return filename
    NSString *stringProjectFile;
    
    // Create a File Save Dialog class
    NSSavePanel *saveDialog = [NSSavePanel savePanel];
    
    // Set array of file types
    NSArray<NSString*> *fileTypesArray = @[@"packager"];
    
    // Enable options in the dialog
    [saveDialog setAllowedFileTypes:fileTypesArray];
    [saveDialog setCanCreateDirectories:YES];
    
    // Display the dialog box; If OK is pressed, process the files
    if ([saveDialog runModal] == NSModalResponseOK) {
        
        // Get file URL
        NSURL *urlProjectFile = saveDialog.URL;
        stringProjectFile = urlProjectFile.path;
        
        // Write to logger
        [Logger setLogEvent:@"Picking new project file: ", stringProjectFile, nil];
        
    }
    
    else {
        
        // Handle file picker cancel
        stringProjectFile = nil;
        
        [Logger setLogEvent:@"Picking new project file: Cancelled - User initiated", nil];
        
    }
    
    // Return picked file
    return stringProjectFile;
    
}

@end
