//
//  ExtractPackage.h
//  Packager
//
//  Created by Brian Buchholtz on 5/1/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef ExtractPackage_h
#define ExtractPackage_h

#import <Foundation/Foundation.h>

@interface ExtractPackage:NSObject {
    
}

+ (void)extractPackage:(NSString *)stringBuildType PackageSource:(NSString *)stringPackageSource PackageTarget:(NSString *)stringPackageTarget ExpandMode:(NSString *)stringExpandMode;

@end

#endif /* ExtractPackage_h */
