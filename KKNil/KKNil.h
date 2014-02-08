//
//  KKNil.h
//  KKNil
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKNil : NSObject

+ (instancetype)nilForClass:(Class)klass;
+ (instancetype)nilForProtocol:(Protocol *)protocol;

@end
