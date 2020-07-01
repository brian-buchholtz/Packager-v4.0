//
//  Logger.h
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef Logger_h
#define Logger_h

#import <Foundation/Foundation.h>

@interface Logger:NSObject {
    
}

+ (void)setLogEvent:(id) first, ...;

@end

#endif /* Logger_h */
