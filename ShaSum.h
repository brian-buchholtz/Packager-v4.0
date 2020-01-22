//
//  ShaSum.h
//  Packager
//
//  Created by Brian Buchholtz on 12/19/19.
//
//  Contributed by Paul Evans on 9/16/19.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef ShaSum_h
#define ShaSum_h

#import <Foundation/Foundation.h>

@interface ShaSum : NSObject {
    
}

+ (NSString *)getShaSum:(NSString *)stringBuildType ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectTarget:(NSString *)stringProjectTarget ProjectIsSigned:(NSString *)stringProjectIsSigned;

@end

#endif /* ShaSum_h */
