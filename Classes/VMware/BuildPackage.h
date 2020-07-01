//
//  BuildPackage.h
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Contributed by Paul Evans on 12/19/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef BuildPackage_h
#define BuildPackage_h

#import <Foundation/Foundation.h>

@interface BuildPackage:NSObject {
    
}

+ (void)pkgBuild:(NSString *)stringPackageFileName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectInstall:(NSString *)stringProjectInstall ProjectScripts:(NSString *)stringProjectScripts ProjectRunScripts:(NSString *)stringProjectRunScripts ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget;
+ (void)hdiUtil:(NSString *)stringPackageFileName ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget;

@end

#endif /* BuildPackage_h */
