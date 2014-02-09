//
//  KKNil.m
//  KKNil
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKNil.h"
#import <objc/runtime.h>

enum {
  KKZerosCount = 8192
};

static const char KKZeros[KKZerosCount] = {0};

@implementation KKNil {
  Class _klass;
  Protocol *_protocol;
}

+ (instancetype)nilForClass:(Class)klass {
  return [[KKNil alloc] initWithClass:klass];
}

+ (instancetype)nilForProtocol:(Protocol *)protocol {
  return [[KKNil alloc] initWithProtocol:protocol];
}

- (instancetype)initWithClass:(Class)klass {
  self = [super init];
  
  if (self) {
    _klass = klass;
  }
  
  return self;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
  self = [super init];
  
  if (self) {
    _protocol = protocol;
  }
  
  return self;
}

#pragma mark -

- (BOOL)respondsToSelector:(SEL)aSelector {
  if (_klass) {
    return [self classRespondsToSelector:aSelector];
  
  } else if (_protocol) {
    return [self protocolRespondsToSelector:aSelector];
  }

  return NO;
}

- (BOOL)classRespondsToSelector:(SEL)aSelector {
  return [_klass instancesRespondToSelector:aSelector];
}

- (BOOL)protocolRespondsToSelector:(SEL)aSelector {
  const char *objCTypes = [self protocolMethodObjCTypesForSelector:aSelector];

  return !!objCTypes;
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  if (_klass) {
    return [self classMethodSignatureForSelector:aSelector];

  } else if (_protocol) {
    return [self protocolMethodSignatureForSelector:aSelector];
  }
  
  return nil;
}

- (NSMethodSignature *)classMethodSignatureForSelector:(SEL)aSelector {
  return [_klass instanceMethodSignatureForSelector:aSelector];
}

- (NSMethodSignature *)protocolMethodSignatureForSelector:(SEL)aSelector {
  const char *objCTypes = [self protocolMethodObjCTypesForSelector:aSelector];
  
  return objCTypes ? [NSMethodSignature signatureWithObjCTypes:objCTypes] : nil;
}

#pragma mark -

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
  
  NSAssert(returnLength <= KKZerosCount, @"Return length %d exceeds supported maximum of %d", returnLength, KKZerosCount);
  
  if (returnLength > 0) {
    [anInvocation setReturnValue:(void *)KKZeros];
  }
}

#pragma mark -

- (const char *)protocolMethodObjCTypesForSelector:(SEL)aSelector {
  struct objc_method_description methodDescription = protocol_getMethodDescription(_protocol, aSelector, YES, YES);
  
  if (!methodDescription.types) {
    methodDescription = protocol_getMethodDescription(_protocol, aSelector, NO, YES);
  }
  
  return methodDescription.types;
}

@end
