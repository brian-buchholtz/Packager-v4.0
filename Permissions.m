//
//  Permissions.m
//  Packager
//
//  Created by Brian Buchholtz on 1/16/20.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "Permissions.h"

@implementation Permissions {
    
}

+ (NSString *)convertPermissions:(int) intPermissions {
    
    NSString *stringPermissions;
    
    if (intPermissions >= 4) {
        
        stringPermissions = @"r";
        intPermissions = intPermissions - 4;
        
    }
    
    if (intPermissions >= 2) {
        
        stringPermissions = [NSString stringWithFormat:@"%@w", stringPermissions];
        intPermissions = intPermissions - 2;
        
    }
    
    if (intPermissions >= 1) {
        
        stringPermissions = [NSString stringWithFormat:@"%@X", stringPermissions];
        //intPermissions = intPermissions - 1;
        
    }
    
    return stringPermissions;
    
}

@end
