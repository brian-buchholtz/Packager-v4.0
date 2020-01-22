//
//  BuildPackage.h
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//
//  Contributed by Paul Evans on 12/19/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef BuildPackage_h
#define BuildPackage_h

#import <Foundation/Foundation.h>

@interface BuildPackage : NSObject {
    
}

+ (void)pkgBuild:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectRoot:(NSString *)stringProjectRoot ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget;
+ (void)hdiUtil:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget;

@end

#endif /* BuildPackage_h */
