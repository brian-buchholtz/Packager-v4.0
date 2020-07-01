//
//  ShaSum.h
//  Packager
//
//  Created by Brian Buchholtz on 12/19/2019.
//
//  Contributed by Paul Evans on 9/16/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef ShaSum_h
#define ShaSum_h

#import <Foundation/Foundation.h>

@interface ShaSum:NSObject {
    
}

+ (NSString *)getShaSum:(NSString *)stringFileName FilePath:(NSString *)stringFilePath;

@end

#endif /* ShaSum_h */
