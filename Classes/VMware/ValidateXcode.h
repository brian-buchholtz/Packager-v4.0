//
//  ValidateXcode.h
//  Packager
//
//  Created by Brian Buchholtz on 4/25/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef ValidateXcode_h
#define ValidateXcode_h

#import <Foundation/Foundation.h>

@interface ValidateXcode:NSObject {
    
}

+ (BOOL)validateXcrun;
+ (BOOL)validateAltool;

@end

#endif /* ValidateXcode_h */
