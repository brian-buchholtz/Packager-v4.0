//
//  GeneratePlist.h
//  Packager
//
//  Created by Brian Buchholtz on 12/17/2019.
//
//  Contributed by Paul Evans on 9/16/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef GeneratePlist_h
#define GeneratePlist_h

#import <Foundation/Foundation.h>

@interface GeneratePlist:NSObject {
    
}

+ (void)writePlist:(NSString *)stringPlistFileName BuildType:(NSString *)stringBuildType CurrentDate:(NSDate *)dateCurrent SettingsApplicationName:(NSString *)stringSettingsApplicationName SettingsApplicationVersion:(NSString *)stringSettingsApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectShortVersion:(NSString *)stringProjectShortVersion ProjectComparisonKey:(NSString *)stringProjectComparisonKey ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions ProjectType:(NSString *)stringProjectType ProjectReceipt:(NSString *)stringProjectReceipt ProjectInstall:(NSString *)stringProjectInstall ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget ProjectManifest:(NSArray *)arrayProjectManifest PayloadSize:(NSNumber *)numberPayloadSize PackageFileName:(NSString *)stringPackageFileName PackageSize:(NSNumber *)numberPackageSize PackageHash:(NSString *)stringPackageHash ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* GeneratePlist_h */
