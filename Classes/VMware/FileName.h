//
//  FileName.h
//  Packager
//
//  Created by Brian Buchholtz on 6/25/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef FileName_h
#define FileName_h

#import <Foundation/Foundation.h>

@interface FileName:NSObject {
    
}

+ (NSString *)setFileName:(NSString *)stringBuildType CurrentDate:(NSDate *)dateCurrent ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectType:(NSString *)stringProjectType ProjectIsPlist:(NSString *)stringProjectIsPlist ProjectIsSigned:(NSString *)stringProjectIsSigned VersionPackageName:(NSString *)stringVersionPackageName VersionPlistName:(NSString *)stringVersionPlistName DateTimePackageName:(NSString *)stringDateTimePackageName DateTimePlistName:(NSString *)stringDateTimePlistName PackageTypePlistName:(NSString *)stringPackageTypePlistName;

@end

#endif /* FileName_h */
