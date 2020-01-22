//
//  PayloadSize.h
//  Packager
//
//  Created by Brian Buchholtz on 1/15/20.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef PayloadSize_h
#define PayloadSize_h

#import <Foundation/Foundation.h>

@interface PayloadSize : NSObject {
    
}

+ (NSNumber *)getFolderSize:(NSString *)stringProjectSource;

@end

#endif /* PayloadSize_h */
