//
//  DDFileReader.m
//  Packager
//
//  Created by Dave DeLong on 9/14/10.
//
//  Edited by Brian Buchholtz 12/16/19.
//  Hacked for ARC
//

#import <Foundation/Foundation.h>
#import "DDFileReader.h"

@interface NSData (DDAdditions)

- (NSRange)rangeOfData_dd:(NSData *)dataToFind;

@end

@implementation NSData (DDAdditions)

- (NSRange)rangeOfData_dd:(NSData *)dataToFind {
    
    const void *bytes = [self bytes];
    NSUInteger length = [self length];
    
    const void *searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;
    
    NSRange foundRange = {NSNotFound, searchLength};
    
    for (NSUInteger index = 0; index < length; index++) {
        
        if (((char *)bytes)[index] == ((char *)searchBytes)[searchIndex]) {
            
            // The current character matches
            if (foundRange.location == NSNotFound) {
                
                foundRange.location = index;
                
            }
            
            searchIndex++;
            
            if (searchIndex >= searchLength) {
                
                return foundRange;
            
            }
            
        }
        
        else {
            
            searchIndex = 0;
            foundRange.location = NSNotFound;
            
        }
        
    }
    
    return foundRange;
    
}

@end

@implementation DDFileReader
@synthesize lineDelimiter, chunkSize;

- (id)initWithFilePath:(NSString *)aPath {
    
    if (self = [super init]) {
        
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPath];
        
        if (fileHandle == nil) {
            
            //[self release]; return nil;
            return nil;
            
        }
        
        lineDelimiter = [[NSString alloc] initWithString:@"\n"];
        //[fileHandle retain];
        //filePath = [aPath retain];
        filePath = aPath;
        currentOffset = 0ULL;
        chunkSize = 10;
        [fileHandle seekToEndOfFile];
        totalFileLength = [fileHandle offsetInFile];
        // We don't need to seek back, since readLine will do that.
        
    }
    
    return self;
    
}

- (void)dealloc {
    
    [fileHandle closeFile];
    //[fileHandle release], fileHandle = nil;
    fileHandle = nil;
    //[filePath release], filePath = nil;
    filePath = nil;
    //[lineDelimiter release], lineDelimiter = nil;
    lineDelimiter = nil;
    currentOffset = 0ULL;
    //[super dealloc];
    
}

- (NSString *)readLine {
    
    if (currentOffset >= totalFileLength) {
        
        return nil;
    
    }
    
    NSData *newLineData = [lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle seekToFileOffset:currentOffset];
    NSMutableData *currentData = [[NSMutableData alloc] init];
    BOOL shouldReadMore = YES;
    
    //NSAutoreleasePool *readPool = [[NSAutoreleasePool alloc] init];
    
    while (shouldReadMore) {
        
        if (currentOffset >= totalFileLength) {
            
            break;
        
        }
        
        NSData *chunk = [fileHandle readDataOfLength:chunkSize];
        NSRange newLineRange = [chunk rangeOfData_dd:newLineData];
        
        if (newLineRange.location != NSNotFound) {
            
            // Include the length so we can include the delimiter in the string
            chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location+[newLineData length])];
            shouldReadMore = NO;
            
        }
        
        [currentData appendData:chunk];
        currentOffset += [chunk length];
        
    }
    
    //[readPool release];
    
    NSString *line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
    //[currentData release];
    //return [line autorelease];
    return line;
    
}

- (NSString *)readTrimmedLine {
    
    return [[self readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

#if NS_BLOCKS_AVAILABLE
- (void)enumerateLinesUsingBlock:(void(^)(NSString*, BOOL*))block {
    
    NSString *line = nil;
    BOOL stop = NO;
    
    while (stop == NO && (line = [self readLine])) {
        
        block(line, &stop);
        
    }
    
}

#endif

@end
