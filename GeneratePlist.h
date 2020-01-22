//
//  GeneratePlist.h
//  Packager
//
//  Created by Brian Buchholtz on 12/17/19.
//
//  Contributed by Paul Evans on 9/16/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef GeneratePlist_h
#define GeneratePlist_h

#import <Foundation/Foundation.h>

@interface GeneratePlist : NSObject {
    
}

+ (void)writePlist:(NSString *)stringBuildType ApplicationName:(NSString *)stringApplicationName ApplicationVersion:(NSString *)stringApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions ProjectRoot:(NSString *)stringProjectRoot ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget PayloadSize:(NSNumber *)numberPayloadSize PackageSize:(NSNumber *)numberPackageSize PackageHash:(NSString *)stringPackageHash ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* GeneratePlist_h */
