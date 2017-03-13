//
//  NSKeyedUnarchiver_openDataObject.m
//  testArchive
//
//  Created by ios on 08.03.17.
//  Copyright © 2017 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSKeyedUnarchiver_openDataObject.h"

@implementation UnSafeKeyedUnarchiver
- (NSKeyedUnarchiver *) createUnarchiver : (NSData*)data
{
    @try {
        NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        return ua;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
@end
