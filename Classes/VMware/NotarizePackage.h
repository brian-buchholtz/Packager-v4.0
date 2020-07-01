//
//  NotarizePackage.h
//  Packager
//
//  Created by Brian Buchholtz on 4/20/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef NotarizePackage_h
#define NotarizePackage_h

#import <Foundation/Foundation.h>

@interface NotarizePackage:NSObject {
    
}

+ (NSString *)notarizePackage:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectSize:(NSNumber *)numberProjectSize ProjectIsNotarized:(NSString *)stringProjectIsNotarized ProjectDevId:(NSString *)stringProjectDevId;

@end

#endif /* NotarizePackage_h */
