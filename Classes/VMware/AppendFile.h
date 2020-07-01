//
//  AppendFile.h
//  Packager
//
//  Created by Brian Buchholtz on 11/12/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef AppendFile_h
#define AppendFile_h

#import <Foundation/Foundation.h>

@interface AppendFile:NSObject {
    
}

+ (void)appendToFile:(NSString *)stringLogPath LogEvent:(NSString *)stringLogEvent;

@end

#endif /* AppendFile_h */
