//
//  KKNilForClassTests.m
//  KKNilForClassTests
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKNil.h"

@interface KKNilForClassTests : XCTestCase

@property (nonatomic, strong) id nilArray;
@property (nonatomic, strong) id nilString;

@end

@implementation KKNilForClassTests

- (void)setUp {
  self.nilArray = [KKNil nilForClass:[NSArray class]];
  self.nilString = [KKNil nilForClass:[NSString class]];
}

- (void)testCreatingObjectsWithNilForClass {
  XCTAssertTrue([self.nilArray isKindOfClass:[KKNil class]]);
  XCTAssertTrue([self.nilString isKindOfClass:[KKNil class]]);
}

- (void)testRespondingToCorrectMethods {
  XCTAssertTrue([self.nilArray respondsToSelector:@selector(lastObject)]);
  XCTAssertTrue([self.nilString respondsToSelector:@selector(lastPathComponent)]);
  XCTAssertNoThrow([self.nilArray lastObject]);
  XCTAssertNoThrow([self.nilString lastPathComponent]);
}

- (void)testNotRespondingToOtherMethods {
  XCTAssertFalse([self.nilArray respondsToSelector:@selector(lastPathComponent)]);
  XCTAssertFalse([self.nilString respondsToSelector:@selector(lastObject)]);
  XCTAssertThrows([self.nilArray lastPathComponent]);
  XCTAssertThrows([self.nilString lastObject]);
}

- (void)testNotCrashingOnMethodsReturningVoid {
  XCTAssertNoThrow([self.nilArray makeObjectsPerformSelector:nil]);
  XCTAssertNoThrow([self.nilArray getObjects:NULL range:NSMakeRange(0, 0)]);
}

- (void)testReturningNilForMethodsReturningId {
  XCTAssertNil([self.nilArray objectEnumerator]);
  XCTAssertNil([self.nilString lastPathComponent]);
}

- (void)testReturningEquivalentOfZeroForMethodsReturningStruct {
  NSRange range = [self.nilString rangeOfString:@""];
  
  XCTAssertEqual(range.location, (NSUInteger)0);
  XCTAssertEqual(range.length, (NSUInteger)0);
}

- (void)testReturningZeroForMethodsReturningPrimitiveTypes {
  XCTAssertEqual([self.nilString isEqualToString:@""], NO);
  XCTAssertEqual([self.nilString length], (NSUInteger)0);
  XCTAssertEqual([self.nilString longLongValue], (long long)0);
  XCTAssertEqual([self.nilString characterAtIndex:123], (unichar)0);
}

@end
