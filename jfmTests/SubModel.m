//
//  SubModel.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "SubModel.h"

@implementation SubModel

- (void)setName:(NSString *)name
{
    [self set:@"name" value:name];
}

- (NSString *)name
{
    return [self get:@"name"];
}

- (void)setIcon:(NSString *)icon
{
    [self set:@"icon" value:icon];
}

- (NSString *)icon
{
    return [self get:@"icon"];
}

- (void)setAge:(unsigned int)age
{
    [self set:@"age" value:[NSNumber numberWithInt:age]];
}

- (unsigned int)age
{
    return [[self get:@"age"] unsignedIntValue];
}

+ (NSString *)tableName
{
    return @"zcq";
}

@end
