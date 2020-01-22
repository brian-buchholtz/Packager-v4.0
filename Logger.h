//
//  Logger.h
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef Logger_h
#define Logger_h

#import <Foundation/Foundation.h>

@interface Logger : NSObject {
    
}

- (NSString *)setLogFile;
+ (void)setLogEvent: (id) first, ...;

@end

#endif /* Logger_h */
