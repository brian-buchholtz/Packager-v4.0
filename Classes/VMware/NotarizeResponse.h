//
//  NotarizeResponse.h
//  Packager
//
//  Created by Brian Buchholtz on 4/15/2020.
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#ifndef NotarizeResponse_h
#define NotarizeResponse_h

#import <Foundation/Foundation.h>

@interface NotarizeResponse:NSObject {
    
}

- (NSDictionary *)readNotarizeResponse:(NSData *)dataNotarizeResponse;

@end

#endif /* NotarizeResponse_h */
