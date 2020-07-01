//
//  Md5.h
//  Packager
//
//  Created by Brian Buchholtz on 6/30/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef Md5_h
#define Md5_h

#import <Foundation/Foundation.h>

@interface Md5:NSObject {
    
}

+ (NSString *)getMd5:(NSString *)stringFileName FilePath:(NSString *)stringFilePath;

@end

#endif /* Md5_h */
