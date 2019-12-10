//
//  Project.h
//  Packager
//
//  Created by Brian Buchholtz on 11/12/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#ifndef Project_h
#define Project_h

#import <Foundation/Foundation.h>

@interface Project : NSObject {
    
}

+ (void)writeProject:(NSString *)stringProjectFile ApplicationName:(NSString *)stringApplicationName ApplicationVersion:(NSString *)stringApplicationVersion ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectHome:(NSString *)stringProjectHome ProjectOwner:(NSString *)stringProjectOwner ProjectGroup:(NSString *)stringProjectGroup ProjectPermissions:(NSString *)stringProjectPermissions;
- (NSDictionary *)readProject:(NSString *)stringProjectFile;

@end

#endif /* Project_h */
