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

@interface KKNil ()

@property (nonatomic, strong) Class klass;
@property (nonatomic, strong) Protocol *protocol;

@end

@implementation KKNil

+ (instancetype)nilForClass:(Class)klass {
  return [[KKNil alloc] initWithClass:klass];
}

+ (instancetype)nilForProtocol:(Protocol *)protocol {
  return [[KKNil alloc] initWithProtocol:protocol];
}

- (instancetype)initWithClass:(Class)klass {
  self = [super init];
  
  if (self) {
    self.klass = klass;
  }
  
  return self;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
  self = [super init];
  
  if (self) {
    self.protocol = protocol;
  }
  
  return self;
}

#pragma mark -

- (BOOL)respondsToSelector:(SEL)aSelector {
  if (self.klass) {
    return [self classRespondsToSelector:aSelector];
  
  } else if (self.protocol) {
    return [self protocolRespondsToSelector:aSelector];
  }

  return NO;
}

- (BOOL)classRespondsToSelector:(SEL)aSelector {
  return [self.klass instancesRespondToSelector:aSelector];
}

- (BOOL)protocolRespondsToSelector:(SEL)aSelector {
  const char *objCTypes = [self protocolMethodObjCTypesForSelector:aSelector];

  return NULL != objCTypes;
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  if (self.klass) {
    return [self classMethodSignatureForSelector:aSelector];

  } else if (self.protocol) {
    return [self protocolMethodSignatureForSelector:aSelector];
  }
  
  return nil;
}

- (NSMethodSignature *)classMethodSignatureForSelector:(SEL)aSelector {
  return [self.klass instanceMethodSignatureForSelector:aSelector];
}

- (NSMethodSignature *)protocolMethodSignatureForSelector:(SEL)aSelector {
  const char * objCTypes = [self protocolMethodObjCTypesForSelector:aSelector];
  
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
  struct objc_method_description methodDescription = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
  
  if (NULL == methodDescription.types) {
    methodDescription = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
  }
  
  return methodDescription.types;
}

@end
