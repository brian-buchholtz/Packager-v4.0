//
//  FileSize.h
//  Packager
//
//  Created by Brian Buchholtz on 12/20/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef FileSize_h
#define FileSize_h

#import <Foundation/Foundation.h>

@interface FileSize:NSObject {
    
}

+ (NSNumber *)getFileSize:(NSString *)stringFileName FilePath:(NSString *)stringFilePath;

@end

#endif /* FileSize_h */
