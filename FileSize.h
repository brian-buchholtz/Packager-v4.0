//
//  FileSize.h
//  Packager
//
//  Created by Brian Buchholtz on 12/20/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef FileSize_h
#define FileSize_h

#import <Foundation/Foundation.h>

@interface FileSize : NSObject {
    
}

+ (NSNumber *)getFileSize:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* FileSize_h */
