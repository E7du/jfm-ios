//
//  Generator.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DbMeta;

@interface Generator : NSObject

+ (BOOL)generatorModel:(DbMeta *)db path:(NSString *)path;

@end
