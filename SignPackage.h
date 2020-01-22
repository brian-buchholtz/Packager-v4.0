//
//  SignPackage.h
//  Packager
//
//  Created by Brian Buchholtz on 12/20/19.
//
//  Contributed by Paul Evans on 12/19/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef SignPackage_h
#define SignPackage_h

#import <Foundation/Foundation.h>

@interface SignPackage : NSObject {
    
}

+ (void)productSign:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectSign:(NSString *)stringProjectSign ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* SignPackage_h */
