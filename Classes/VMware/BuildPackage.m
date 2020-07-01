//
//  BuildPackage.m
//  Packager
//
//  Created by Brian Buchholtz on 11/8/2019.
//
//  Contributed by Paul Evans on 12/19/2019.
//  Based on GeneratePKG_DMG
//
//  Copyright © 2019 VMware. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BuildPackage.h"
#import "Logger.h"

@implementation BuildPackage {
    
}

+ (void)pkgBuild:(NSString *)stringPackageFileName ProjectVersion:(NSString *)stringProjectVersion ProjectIdentifier:(NSString *)stringProjectIdentifier ProjectInstall:(NSString *)stringProjectInstall ProjectScripts:(NSString *)stringProjectScripts ProjectRunScripts:(NSString *)stringProjectRunScripts ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget {
    
    // Package file name
    NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringPackageFileName];
    
    // pkgbuild parameters
    NSString *stringPkgParam1 = @"--quiet";
    NSString *stringPkgParam2 = @"--install-location";
    NSString *stringPkgParam3 = stringProjectInstall;
    NSString *stringPkgParam4 = @"--identifier";
    NSString *stringPkgParam5 = stringProjectIdentifier;
    NSString *stringPkgParam6 = @"--version";
    NSString *stringPkgParam7 = stringProjectVersion;
    NSString *stringPkgParam8 = @"--root";
    NSString *stringPkgParam9 = [NSString stringWithFormat:@"%@/", stringProjectSource];
    NSString *stringPkgParam10 = stringPackageFile;
    NSString *stringPkgParam11 = @"--scripts";
    NSString *stringPkgParam12 = stringProjectScripts;
    
    // Log
    NSLog (@"Pkgbuild Param1: %@", stringPkgParam1);
    NSLog (@"Pkgbuild Param2: %@", stringPkgParam2);
    NSLog (@"Pkgbuild Param3: %@", stringPkgParam3);
    NSLog (@"Pkgbuild Param4: %@", stringPkgParam4);
    NSLog (@"Pkgbuild Param5: %@", stringPkgParam5);
    NSLog (@"Pkgbuild Param6: %@", stringPkgParam6);
    NSLog (@"Pkgbuild Param7: %@", stringPkgParam7);
    NSLog (@"Pkgbuild Param8: %@", stringPkgParam8);
    NSLog (@"Pkgbuild Param9: %@", stringPkgParam9);
    NSLog (@"Pkgbuild Param10: %@", stringPkgParam10);
    NSLog (@"Pkgbuild Param11: %@", stringPkgParam11);
    NSLog (@"Pkgbuild Param12: %@", stringPkgParam12);
    
    // Launch pkgbuild
    int pidPkgbuild = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipePkgbuild = [NSPipe pipe];
    NSFileHandle *filePkgbuild = pipePkgbuild.fileHandleForReading;
    
    NSTask *taskPkgbuild = [[NSTask alloc] init];
    taskPkgbuild.launchPath = @"/usr/bin/pkgbuild";
    
    if ([stringProjectRunScripts isEqualToString:@"TRUE"]) {
        
        taskPkgbuild.arguments = @[stringPkgParam1, stringPkgParam2, stringPkgParam3, stringPkgParam4, stringPkgParam5, stringPkgParam6, stringPkgParam7, stringPkgParam8, stringPkgParam9, stringPkgParam10, stringPkgParam11, stringPkgParam12];
        
    }
    
    else if ([stringProjectRunScripts isEqualToString:@"FALSE"]) {
        
        taskPkgbuild.arguments = @[stringPkgParam1, stringPkgParam2, stringPkgParam3, stringPkgParam4, stringPkgParam5, stringPkgParam6, stringPkgParam7, stringPkgParam8, stringPkgParam9, stringPkgParam10];
        
    }
    
    taskPkgbuild.standardOutput = pipePkgbuild;
    
    [taskPkgbuild launch];
    
    [Logger setLogEvent:@"pkgbuild PID: ", [NSString stringWithFormat:@"%d", pidPkgbuild], nil];
    
    NSData *dataPkgbuild = [filePkgbuild readDataToEndOfFile];
    [filePkgbuild closeFile];
    
    NSString *stringPkgbuild = [[NSString alloc] initWithData:dataPkgbuild encoding:NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"pkgbuild messages:\n", stringPkgbuild, nil];
    
}

+ (void)hdiUtil:(NSString *)stringPackageFileName ProjectName:(NSString *)stringProjectName ProjectVersion:(NSString *)stringProjectVersion ProjectSource:(NSString *)stringProjectSource ProjectTarget:(NSString *)stringProjectTarget {
    
    // Package file name
    NSString *stringPackageFile = [NSString stringWithFormat:@"%@/%@", stringProjectTarget, stringPackageFileName];
    
    // hdiutil parameters
    NSString *stringDmgParam1 = @"create";
    NSString *stringDmgParam2 = @"-volname";
    NSString *stringDmgParam3 = [NSString stringWithFormat:@"%@-%@", stringProjectName, stringProjectVersion];
    NSString *stringDmgParam4 = @"-srcfolder";
    NSString *stringDmgParam5 = [NSString stringWithFormat:@"%@/", stringProjectSource];
    NSString *stringDmgParam6 = @"-ov";
    NSString *stringDmgParam7 = @"-format";
    NSString *stringDmgParam8 = @"UDZO";
    NSString *stringDmgParam9 = stringPackageFile;
    
    // Log
    NSLog (@"Dmgbuild Param1: %@", stringDmgParam1);
    NSLog (@"Dmgbuild Param2: %@", stringDmgParam2);
    NSLog (@"Dmgbuild Param3: %@", stringDmgParam3);
    NSLog (@"Dmgbuild Param4: %@", stringDmgParam4);
    NSLog (@"Dmgbuild Param5: %@", stringDmgParam5);
    NSLog (@"Dmgbuild Param6: %@", stringDmgParam6);
    NSLog (@"Dmgbuild Param7: %@", stringDmgParam7);
    NSLog (@"Dmgbuild Param8: %@", stringDmgParam8);
    NSLog (@"Dmgbuild Param9: %@", stringDmgParam9);
    
    // Launch hdiutil
    int pidHdiutil = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipeHdiutil = [NSPipe pipe];
    NSFileHandle *fileHdiutil = pipeHdiutil.fileHandleForReading;
    
    NSTask *taskHdiutil = [[NSTask alloc] init];
    taskHdiutil.launchPath = @"/usr/bin/hdiutil";
    taskHdiutil.arguments = @[stringDmgParam1, stringDmgParam2, stringDmgParam3, stringDmgParam4, stringDmgParam5, stringDmgParam6, stringDmgParam7, stringDmgParam8, stringDmgParam9];
    taskHdiutil.standardOutput = pipeHdiutil;
    
    [taskHdiutil launch];
    
    [Logger setLogEvent:@"hdiutil PID: ", [NSString stringWithFormat:@"%d", pidHdiutil], nil];
    
    NSData *dataHdiutil = [fileHdiutil readDataToEndOfFile];
    [fileHdiutil closeFile];
    
    NSString *stringHdiutil = [[NSString alloc] initWithData:dataHdiutil encoding: NSUTF8StringEncoding];
    
    [Logger setLogEvent:@"hdiutil messages:\n", stringHdiutil, nil];
    
}

@end
