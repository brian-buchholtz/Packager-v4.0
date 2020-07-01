//
//  StaplePackage.h
//  Packager
//
//  Created by Brian Buchholtz on 4/20/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef StaplePackage_h
#define StaplePackage_h

#import <Foundation/Foundation.h>

@interface StaplePackage:NSObject {
    
}

+ (void)writeStapleScript:(NSString *)stringFileName SettingsApplicationName:(NSString *)stringSettingsApplicationName SettingsApplicationVersion:(NSString *)stringSettingsApplicationVersion ProjectTarget:(NSString *)stringProjectTarget ProjectDevId:(NSString *)stringProjectDevId RequestUuid:(NSString *)stringRequestUuid;

@end

#endif /* StaplePackage_h */
