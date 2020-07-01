//
//  XcrunAltool.h
//  Packager
//
//  Created by Brian Buchholtz on 4/27/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef XcrunAltool_h
#define XcrunAltool_h

#import <Foundation/Foundation.h>

@interface XcrunAltool:NSObject {
    
}

+ (NSDictionary *)xcrunAltool:(NSString *)stringFileName FilePath:(NSString *)stringFilePath ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectDevId:(NSString *)stringProjectDevId ProjectDevPassword:(NSString *)stringProjectDevPassword;

@end

#endif /* XcrunAltool_h */
