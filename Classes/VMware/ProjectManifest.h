//
//  ProjectManifest.h
//  Packager
//
//  Created by Brian Buchholtz on 1/16/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef ProjectManifest_h
#define ProjectManifest_h

#import <Foundation/Foundation.h>

@interface ProjectManifest:NSObject {
    
}

- (NSArray *)getProjectManifest:(NSString *)stringProjectSource ProjectInstall:(NSString *)stringProjectInstall;

@end

#endif /* ProjectManifest_h */
