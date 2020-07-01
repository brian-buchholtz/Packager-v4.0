//
//  FilePicker.h
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef FilePicker_h
#define FilePicker_h

#import <Foundation/Foundation.h>

@interface FilePicker:NSObject {
    
}

- (NSString *)getFile:(NSArray *)fileTypesArray;

@end

#endif /* FilePicker_h */
