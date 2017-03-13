//
//  NSKeyedUnarchiver_openDataObject.h
//  testArchive
//
//  Created by ios on 08.03.17.
//  Copyright © 2017 ios. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UnSafeKeyedUnarchiver : NSObject
- (NSKeyedUnarchiver *) createUnarchiver : (NSData*)data ;
@end

