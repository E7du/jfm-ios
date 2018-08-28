//
//  DefaultValueKit.m
//  jfm
//
//  Created by Jobsz on 8/20/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "DefaultValueKit.h"

@implementation DefaultValueKit

+ (id)defaultValue:(id)data
{
	if ([data isKindOfClass:[NSString class]]) {
		return @"";
	} else if ([data isKindOfClass:[NSNumber class]]) {
		return @0;
	} else if ([data isKindOfClass:[NSDictionary class]]) {
		return @{};
	} else if ([data isKindOfClass:[NSArray class]]) {
		return @[];
	}
	return [NSObject new];
}

@end
