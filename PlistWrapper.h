//
//  PlistWrapper.h
//  Packager
//
//  Created by Ravishanker Kusuma on 7/20/13.
//
//

#ifndef PlistWrapper_h
#define PlistWrapper_h

#import <Foundation/Foundation.h>

@interface PlistWrapper : NSObject

// Convert Object(Dictionary,Array) to Plist(NSData)
+ (NSData *)objToPlistAsData:(id)obj;

// Convert Object(Dictionary,Array) to Plist(NSString)
+ (NSString *)objToPlistAsString:(id)obj;

//C onvert Plist(NSData) to Object(Array,Dictionary)
+ (id)plistToObjectFromData:(NSData *)data;

// Convert Plist(NSString) to Object(Array,Dictionary)
+ (id)plistToObjectFromString:(NSString*)str;

@end

#endif /* PlistWrapper_h */
