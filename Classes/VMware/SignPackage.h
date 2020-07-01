//
//  SignPackage.h
//  Packager
//
//  Created by Brian Buchholtz on 12/20/2019.
//
//  Contributed by Paul Evans on 12/19/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef SignPackage_h
#define SignPackage_h

#import <Foundation/Foundation.h>

@interface SignPackage:NSObject {
    
}

+ (void)productSign:(NSString *)stringSignedPackageFileName PackageFileName:(NSString *)stringPackageFileName BuildType:(NSString *)stringBuildType ProjectTarget:(NSString *)stringProjectTarget ProjectDevCert:(NSString *)stringProjectDevCert ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* SignPackage_h */
