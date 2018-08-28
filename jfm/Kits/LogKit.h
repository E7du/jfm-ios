//
//  LogKit.h
//  jfm
//
//  Created by Jobsz on 9/9/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

// Dev
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
// Release
#else
#define NSLog(...) {}
#endif

//TODO: LogLevel
@interface LogKit : NSObject

@end
