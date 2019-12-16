//
//  AppController.m
//  Packager
//
//  Created by Brian Buchholtz on 11/7/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import "AppController.h"
#import "Logger.h"
#import "FilePicker.h"
#import "SaveAs.h"
#import "Project.h"
#import "BrowsePath.h"
#import "DDFileReader.h"
//#import "ReadUsers.h"
#import "FileSystemNode.h"
#import "FileSystemBrowserCell.h"
#import "PreviewViewController.h"

@interface AppController ()

@end

@implementation AppController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main application initialization

- (void) applicationWillFinishLaunching: (NSNotification *) not {
    
    // Set application metadata
    stringApplicationName = @"VMware Packager";
    stringApplicationVersion = @"2.10";
    
    // Settings path and file
    NSURL *urlSettingsPath = [[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent];
    NSString *stringSettingsPath = urlSettingsPath.path;
    stringSettingsFile = [NSString stringWithFormat:@"%@/%@", stringSettingsPath, @"Packager.settings"];
    
    // Update application window title
    NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, @"(Empty Project)"];
    [self.windowMain setTitle:stringApplicationTitle];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser initialization
//
// Please note bug #24527817
// NSBrowser column titles draw sporadic when navigating back with left arrow key (10.11)
//

- (void)awakeFromNib {
    
    // use a custom cell class for each browser item
    [self.browser setCellClass:[FileSystemBrowserCell class]];
    
    // Drag and drop support
    [self.browser registerForDraggedTypes:@[NSFilenamesPboardType]];
    [self.browser setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    [self.browser setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
    
    // if you want to change the background color of NSBrowser use this:
    //self.browser.backgroundColor = [NSColor controlBackgroundColor];
    
    // Double click support
    self.browser.target = self;
    self.browser.doubleAction = @selector(browserDoubleClick:);
    
    // Add right click support
    // Create new folder
    
}

- (id)rootItemForBrowser:(NSBrowser *)browser {
    
    if (self.rootNode == nil) {
        
        _rootNode = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:NSOpenStepRootDirectory()]];
        
    }
    
    return self.rootNode;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Menu

- (IBAction)menuNewProject:(id)sender {
    
    // New project
    [self NewProject];
    
}

- (IBAction)menuOpenProject:(id)sender {
    
    // Open project
    [self OpenProject];
    
}

- (IBAction)menuSaveProject:(id)sender {
    
    // Save project
    [self SaveProject];
    
}

- (IBAction)menuBuildPKG:(id)sender {
    
    // Build PKG
    [self BuildPKG];
    
}

- (IBAction)menuBuildDMG:(id)sender {
    
    // Build DMG
    [self BuildDMG];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controls

- (IBAction)buttonNewProject:(NSButton *)sender {
    
    // New project
    [self NewProject];
    
}

- (IBAction)buttonOpenProject:(NSButton *)sender {
    
    // Open project
    [self OpenProject];
    
}

- (IBAction)buttonSaveProject:(NSButton *)sender {
    
    // Save project
    [self SaveProject];
    
}

- (IBAction)buttonBuildPKG:(NSButton *)sender {
    
    // Build PKG
    [self BuildPKG];
    
}

- (IBAction)buttonBuildDMG:(NSButton *)sender {
    
    // Build DMG
    [self BuildDMG];
    
}

- (IBAction)buttonBrowse:(NSButton *)sender {
    
    // Browse project home
    [self Browse];
    
}

- (IBAction)comboboxOwner:(NSComboBox *)sender {
    
    // Not yet implemented
    
}

- (IBAction)comboboxGroup:(NSComboBox *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerRead:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerWrite:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxOwnerExecute:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupRead:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupWrite:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxGroupExecute:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneRead:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneWrite:(NSButton *)sender {
    
    // Not yet implemented
    
}

- (IBAction)checkboxEveryoneExecute:(NSButton *)sender {
    
    // Not yet implemented
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Functions

- (void)NewProject {
    
    // Browse for new project file
    SaveAs *newFile = [[SaveAs alloc] init];
    NSString *stringNewFile = [newFile newFile];
    
    if (stringNewFile) {
        
        stringProjectFile = stringNewFile;
        
        // Update application window title
        NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, stringProjectFile];
        [self.windowMain setTitle:stringApplicationTitle];
        
        [Logger setLogEvent:@"New file open successful", nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"New file open aborted", nil];
        
    }
    
}

- (void)OpenProject {
    
    // Browse for existing project file
    FilePicker *pickFile = [[FilePicker alloc] init];
    stringProjectFile = [pickFile getFile];
    
    if (stringProjectFile) {
        
        // Create project class
        Project *openProject = [[Project alloc] init];
        NSDictionary *dictProject = [openProject readProject:stringProjectFile];
        
        // Application metadata
        stringProjectApplicationName = dictProject[@"ApplicationName"];
        stringProjectApplicationVersion = dictProject[@"ApplicationVersion"];
        
        // Project metadata
        stringProjectName = dictProject[@"ProjectName"];
        stringProjectVersion = dictProject[@"ProjectVersion"];
        stringProjectHome = dictProject[@"ProjectHome"];
        stringProjectOwner = dictProject[@"ProjectOwner"];
        stringProjectGroup = dictProject[@"ProjectGroup"];
        stringProjectPermissions = dictProject[@"ProjectPermissions"];
        
        // Update application window title
        NSString *stringApplicationTitle = [NSString stringWithFormat:@"%@ - %@", stringApplicationName, stringProjectFile];
        [self.windowMain setTitle:stringApplicationTitle];
        
        // Update labels
        [self.labelName setStringValue:stringProjectName];
        [self.labelVersion setStringValue:stringProjectVersion];
        [self.labelHome setStringValue:stringProjectHome];
        
        // Update browser
        [self ChangeRoot];
        
        [Logger setLogEvent:@"Existing file open successful", nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Existing file open aborted", nil];
        
    }
    
}

- (void)SaveProject {
    
    // Verify open project
    if (stringProjectFile) {
        
        // Read control values
        stringProjectName = self.labelName.stringValue;
        stringProjectVersion = self.labelVersion.stringValue;
        stringProjectHome = self.labelHome.stringValue;
        
        // Default values
        stringProjectOwner = @"1";
        stringProjectGroup = @"1";
        stringProjectPermissions = @"777";
        
        // Write project file
        [Project writeProject:stringProjectFile ApplicationName:stringApplicationName ApplicationVersion:stringApplicationVersion ProjectName:stringProjectName ProjectVersion:stringProjectVersion ProjectHome:stringProjectHome ProjectOwner:stringProjectOwner ProjectGroup:stringProjectGroup ProjectPermissions:stringProjectPermissions];
        
    }
    
    else {
        
        // Add alert
        [Logger setLogEvent:@"Saving project file: Cancelled - Empty Project", nil];
        
    }
    
}

- (void)BuildPKG {
    
    [Logger setLogEvent:@"Build PKG", nil];
    
    [self ReadUsers];
    
}

- (void)BuildDMG {
    
    [Logger setLogEvent:@"Build DMG", nil];
    
    [self ReadGroups];
    
}

- (void)Browse {
    
    // Browse for project home
    BrowsePath *projectHome = [[BrowsePath alloc] init];
    stringProjectHome = [projectHome getPath];
    
    // Handle project home browse cancel
    if (stringProjectHome) {
        
        [self.labelHome setStringValue:stringProjectHome];
        [Logger setLogEvent:@"Project Home: ", stringProjectHome, nil];
        
        // Update browser
        [self ChangeRoot];
        
    }
    
    else {
        
        stringProjectHome = self.labelHome.stringValue;
        [Logger setLogEvent:@"Browse project home aborted", nil];
        
    }
    
}

- (void)ReadUsers {
    
    NSString *stringPasswdPath = @"/etc/passwd";
    DDFileReader *readerPasswd = [[DDFileReader alloc] initWithFilePath:stringPasswdPath];
    
    [readerPasswd enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        
        NSLog(@"read line: %@", line);
        
    }];
    
}

- (void)ReadGroups {
    
    NSString *stringGroupPath = @"/etc/group";
    DDFileReader *readerGroup = [[DDFileReader alloc] initWithFilePath:stringGroupPath];
    
    [readerGroup enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        
        NSLog(@"read line: %@", line);
        
    }];
    
}

- (void)ChangeRoot {
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:stringProjectHome ] == YES) {
    
        _rootNode = [[FileSystemNode alloc] initWithURL:[NSURL fileURLWithPath:stringProjectHome]];
        [self.browser loadColumnZero];
        
        [Logger setLogEvent:@"Setting browser root to: ", stringProjectHome, nil];
        
    }
    
    else {
        
        [Logger setLogEvent:@"Project home path doesn't exist - no change to root", nil];
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser required delegate methods

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return node.children.count;
    
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return (node.children)[index];
    
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return !node.isDirectory || node.isPackage; // take into account packaged apps and documents
    
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    
    FileSystemNode *node = (FileSystemNode *)item;
    return node.displayName;
    
}

- (void)browser:(NSBrowser *)browser willDisplayCell:(FileSystemBrowserCell *)cell atRow:(NSInteger)row column:(NSInteger)column {
    
    // Find the item and set the image.
    NSIndexPath *indexPath = [browser indexPathForColumn:column];
    indexPath = [indexPath indexPathByAddingIndex:row];
    FileSystemNode *node = [browser itemAtIndexPath:indexPath];
    cell.image = node.icon;
    cell.labelColor = node.labelColor;
    
}

- (NSViewController *)browser:(NSBrowser *)browser previewViewControllerForLeafItem:(id)item {
    
    if (self.sharedPreviewController == nil) {
        
        _sharedPreviewController = [[PreviewViewController alloc] initWithNibName:@"PreviewView" bundle:[NSBundle bundleForClass:[self class]]];
        
    }
    
    return self.sharedPreviewController; // NSBrowser will set the representedObject for us
    
}

- (NSViewController *)browser:(NSBrowser *)browser headerViewControllerForItem:(id)item {
    
    // Add a header for the first column, just as an example
    if (self.rootNode == item) {
        
        return [[NSViewController alloc] initWithNibName:@"HeaderView" bundle:[NSBundle bundleForClass:[self class]]];
        
    }
    
    else {
        
        return nil;
        
    }
    
}

- (CGFloat)browser:(NSBrowser *)browser shouldSizeColumn:(NSInteger)columnIndex forUserResize:(BOOL)forUserResize toWidth:(CGFloat)suggestedWidth  {
    
    if (!forUserResize) {
        
        id item = [browser parentForItemsInColumn:columnIndex];
        
        if ([self browser:browser isLeafItem:item]) {
            
            suggestedWidth = 200;
            
        }
        
    }
    
    return suggestedWidth;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser dragging Source

- (BOOL)browser:(NSBrowser *)browser writeRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column toPasteboard:(NSPasteboard *)pasteboard {
    
    NSMutableArray *filenames = [NSMutableArray arrayWithCapacity:rowIndexes.count];
    NSIndexPath *baseIndexPath = [browser indexPathForColumn:column];
    
    for (NSUInteger i = rowIndexes.firstIndex; i <= rowIndexes.lastIndex; i = [rowIndexes indexGreaterThanIndex:i]) {
        
        FileSystemNode *fileSystemNode = [browser itemAtIndexPath:[baseIndexPath indexPathByAddingIndex:i]];
        [filenames addObject:(fileSystemNode.URL).path];
        
    }
    
    [pasteboard declareTypes:@[NSFilenamesPboardType] owner:self];
    [pasteboard setPropertyList:filenames forType:NSFilenamesPboardType];
    _draggedColumnIndex = column;
    return YES;
    
}

- (BOOL)browser:(NSBrowser *)browser canDragRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column withEvent:(NSEvent *)event {
    
    // We will allow dragging any cell - even disabled ones. By default, NSBrowser will not let you drag a disabled cell
    return YES;
    
}

- (NSImage *)browser:(NSBrowser *)browser draggingImageForRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset {
    
    NSImage *result = [browser draggingImageForRowsWithIndexes:rowIndexes inColumn:column withEvent:event offset:dragImageOffset];
    
    // Create a custom drag image "badge" that displays the number of items being dragged
    if (rowIndexes.count > 1) {
        
        NSString *str = [NSString stringWithFormat:@"%ld items being dragged", (long)rowIndexes.count];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = NSMakeSize(0.5, 0.5);
        shadow.shadowBlurRadius = 5.0;
        shadow.shadowColor = [NSColor blackColor];
        
        NSDictionary *attrs = @{NSShadowAttributeName: shadow,
                                NSForegroundColorAttributeName: [NSColor whiteColor]};
        
        NSAttributedString *countString = [[NSAttributedString alloc] initWithString:str attributes:attrs];
        NSSize stringSize = [countString size];
        NSSize imageSize = result.size;
        imageSize.height += stringSize.height;
        imageSize.width = MAX(stringSize.width + 3, imageSize.width);
        
        NSImage *newResult = [[NSImage alloc] initWithSize:imageSize];
        
        [newResult lockFocus];
        
        [result drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        [countString drawAtPoint:NSMakePoint(0, imageSize.height - stringSize.height)];
        [newResult unlockFocus];
        
        dragImageOffset->y += (stringSize.height / 2.0);
        result = newResult;
        
    }
    
    return result;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser dragging Destination

- (FileSystemNode *)fileSystemNodeAtRow:(NSInteger)row column:(NSInteger)column {
    
    if (column >= 0) {
        
        NSIndexPath *indexPath = [self.browser indexPathForColumn:column];
        
        if (row >= 0) {
            
            indexPath = [indexPath indexPathByAddingIndex:row];
            
        }
        
        id result = [self.browser itemAtIndexPath:indexPath];
        return (FileSystemNode *)result;
        
    }
    
    else {
        
        return nil;
        
    }
    
}

- (NSDragOperation)browser:(NSBrowser *)browser validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger *)row column:(NSInteger *)column dropOperation:(NSBrowserDropOperation *)dropOperation {
    
    NSDragOperation result = NSDragOperationNone;
    
    // We only accept file types
    if ([[info draggingPasteboard].types indexOfObject:NSFilenamesPboardType] > 0) {
        
        // For a between drop, we let the user drop "on" the parent item
        if (*dropOperation == NSBrowserDropAbove) {
            
            *row = -1;
            
        }
        
        // Only allow dropping in folders, but don't allow dragging from the same folder into itself, if we are the source
        if (*column != -1) {
            
            BOOL droppingFromSameFolder = ([info draggingSource] == browser) && (*column == self.draggedColumnIndex);
            
            if (*row != -1) {
                
                // If we are dropping on a folder, then we will accept the drop at that row
                FileSystemNode *fileSystemNode = [self fileSystemNodeAtRow:*row column:*column];
                
                if (fileSystemNode.isDirectory) {
                    
                    // Yup, a good drop
                    result = NSDragOperationEvery;
                    
                }
                
                else {
                    
                    // Nope, we can't drop onto a file! We will retarget to the column, if it isn't the same folder.
                    if (!droppingFromSameFolder) {
                        
                        result = NSDragOperationEvery;
                        *row = -1;
                        *dropOperation = NSBrowserDropOn;
                        
                    }
                    
                }
                
            }
            
            else if (!droppingFromSameFolder) {
                
                result = NSDragOperationEvery;
                *row = -1;
                *dropOperation = NSBrowserDropOn;
                
            }
            
        }
        
    }
    
    return result;
    
}

- (BOOL)browser:(NSBrowser *)browser acceptDrop:(id <NSDraggingInfo>)info atRow:(NSInteger)row column:(NSInteger)column dropOperation:(NSBrowserDropOperation)dropOperation {
    
    NSArray *filenames = [[info draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    // Find the target folder
    FileSystemNode *targetFileSystemNode = nil;
    
    if ((column != -1) && (filenames != nil)) {
        
        if (row != -1) {
            
            FileSystemNode *fileSystemNode = [self fileSystemNodeAtRow:row column:column];
            
            if (fileSystemNode.isDirectory) {
                
                targetFileSystemNode = fileSystemNode;
                
            }
            
        }
        
        else {
            
            // Grab the parent for the column, which should be a directory
            targetFileSystemNode = (FileSystemNode *)[browser parentForItemsInColumn:column];
            
        }
        
    }
    
    // We now have the target folder, so move things around
    if (targetFileSystemNode != nil) {
        
        NSString *targetFolder = targetFileSystemNode.URL.path;
        NSMutableString *prettyNames = nil;
        
        // Create a display name of all the selected filenames that are moving
        for (NSUInteger i = 0; i < filenames.count; i++) {
            
            NSString *filename = [[NSFileManager defaultManager] displayNameAtPath:filenames[i]];
            
            if (prettyNames == nil) {
                
                prettyNames = [filename mutableCopy];
                
            }
            
            else {
                
                [prettyNames appendString:@", "];
                [prettyNames appendString:filename];
                
            }
            
        }
        
        // Ask the user if they really want to move those files
        NSAlert *warningAlert = [[NSAlert alloc] init];
        warningAlert.messageText = @"Verify file move";
        warningAlert.informativeText = [NSString stringWithFormat:@"Are you sure you want to move '%@' to '%@'?", prettyNames, targetFolder];
        [warningAlert addButtonWithTitle:@"Yes"];
        [warningAlert addButtonWithTitle:@"No"];
        
        [warningAlert beginSheetModalForWindow:self.windowMain completionHandler:^(NSInteger result) {
            
            if (result == NSAlertFirstButtonReturn) {
                
                // Do the actual moving of the files.
                for (NSUInteger i = 0; i < filenames.count; i++) {
                    
                    NSString *filename = filenames[i];
                    NSString *targetPath = [targetFolder stringByAppendingPathComponent:filename.lastPathComponent];
                    
                    // Normally, you should check the result of movePath to see if it worked or not.
                    NSError *error = nil;
                    
                    if (![[NSFileManager defaultManager] moveItemAtPath:filename toPath:targetPath error:&error] && error) {
                        
                        [NSApp presentError:error];
                        break;
                        
                    }
                    
                }
                
                // It would be more efficient to invalidate the children of the "from" and "to" nodes and then
                // call -reloadColumn: on each of the corresponding columns. However, we just reload every column
                //
                [self.rootNode invalidateChildren];
                
                for (NSInteger col = self.browser.lastColumn; col >= 0; col--) {
                    
                    [self.browser reloadColumn:col];
                    
                }
                
            }
            
        }];
        
        return YES;
        
    }
    
    return NO;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Complex browser action

- (void)browserDoubleClick:(id)sender {
    
    // Find the clicked item and open it in Finder
    FileSystemNode *clickedNode = [self fileSystemNodeAtRow:self.browser.clickedRow column:self.browser.clickedColumn];
    
    if (clickedNode != nil) {
        
        [[NSWorkspace sharedWorkspace] openFile:clickedNode.URL.path];
        
    }
    
}

@end
