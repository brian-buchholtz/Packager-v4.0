//
//  ReadUsers.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/19.
//  Copyright © 2019 VMware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadUsers.h"
#import "Logger.h"

@implementation ReadUsers {
    
}




/*

NSString *fileRoot = [[NSBundle mainBundle] pathForResource:@"record" ofType:@"txt"];
FILE *file = fopen([fileRoot UTF8String], "r");
char buffer[256];
while (fgets(buffer, 256, file) != NULL){
    NSString *result = [NSString stringWithUTF8String:buffer];
    NSLog(@"%@",result);
}



unichar firstChar = [codeString characterAtIndex:0];



NSString *string = @"oop:ack:bork:greeble:ponies";
NSArray *chunks = [string componentsSeparatedByString: @":"];




NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity: 3];

[dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:0];
[dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:1];
[dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:2];

*/










//+ (NSMutableArray *)readUsers {
- (void)readUsers {
    
    // passwd path and file
    NSString *stringPasswdPath = @"/etc/passwd";
    //NSString *stringPasswdFile = [[NSBundle mainBundle] pathForResource:stringPasswdPath ofType:@"txt"];
    
    //NSString *path = @"/Users/pineapple/Desktop/finalproj/test242.txt";
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:stringPasswdPath];
    NSData *dataBuffer = nil;
    
    while ((dataBuffer = [fileHandle readDataOfLength:1024])) {
        
        // Do something with the buffer
        NSLog(@"%@",dataBuffer);
        
    }
    
    
    
    
    
    
    
//    FILE *filePasswd = fopen([stringPasswdFile UTF8String], "r");
    
//    char buffer[256];
    
//    while (fgets(buffer, 256, filePasswd) != NULL) {
        
//        NSString *result = [NSString stringWithUTF8String:buffer];
//        NSLog(@"%@",result);
        
//    }
    
    
    
    
    
        
    // Get date and time
    //NSDate *date = [NSDate date];
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    //NSString *stringDate = [dateFormatter stringFromDate:date];
    //NSString *stringData = [NSString stringWithFormat:@"[%@] %@\r\n", stringDate, stringEvent];
    
    //NSData *dataString = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    

    //NSLog (@"Creating new log file");
    
    
    
}











@end
