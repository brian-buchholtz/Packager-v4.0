//
//  DDFileReader.h
//  Packager
//
//  Created by Dave DeLong on 9/14/10.
//
//

#ifndef DDFileReader_h
#define DDFileReader_h

@interface DDFileReader : NSObject {
    
    NSString *filePath;
    
    NSFileHandle *fileHandle;
    unsigned long long currentOffset;
    unsigned long long totalFileLength;
    
    NSString *lineDelimiter;
    NSUInteger chunkSize;
    
}

@property (nonatomic, copy) NSString *lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end

#endif /* DDFileReader_h */
