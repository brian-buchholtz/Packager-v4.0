//
//  Project.h
//  Packager
//
//  Created by Brian Buchholtz on 11/12/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef Project_h
#define Project_h

#import <Foundation/Foundation.h>

@interface Project:NSObject {
    
}

+ (void)writeProject:(NSString *)stringProjectFile ProjectApplicationName:(NSString *)stringProjectApplicationName ProjectApplicationVersion:(NSString *)stringProjectApplicationVersion ProjectMetadataName:(NSString *)stringProjectMetadataName ProjectMetadataIdentifier:(NSString *)stringProjectMetadataIdentifier ProjectMetadataVersion:(NSString *)stringProjectMetadataVersion ProjectMetadataShortVersion:(NSString *)stringProjectMetadataShortVersion ProjectMetadataComparisonKey:(NSString *)stringProjectMetadataComparisonKey ProjectMetadataType:(NSString *)stringProjectMetadataType ProjectMetadataReceipt:(NSString *)stringProjectMetadataReceipt ProjectMetadataInstall:(NSString *)stringProjectMetadataInstall ProjectMetadataScripts:(NSString *)stringProjectMetadataScripts ProjectMetadataOwner:(NSString *)stringProjectMetadataOwner ProjectMetadataGroup:(NSString *)stringProjectMetadataGroup ProjectMetadataPermissions:(NSString *)stringProjectMetadataPermissions ProjectMetadataDevCert:(NSString *)stringProjectMetadataDevCert ProjectMetadataDevId:(NSString *)stringProjectMetadataDevId ProjectMetadataSource:(NSString *)stringProjectMetadataSource ProjectMetadataTarget:(NSString *)stringProjectMetadataTarget ProjectMetadataRunScripts:(NSString *)stringProjectMetadataRunScripts ProjectMetadataIsSigned:(NSString *)stringProjectMetadataIsSigned ProjectMetadataIsNotarized:(NSString *)stringProjectMetadataIsNotarized;
- (NSDictionary *)readProject:(NSString *)stringProjectFile;

@end

#endif /* Project_h */
