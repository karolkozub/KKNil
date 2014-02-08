//
//  KKNilForProtocolTests.m
//  KKNil
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKNil.h"

@interface KKNilForProtocolTests : XCTestCase

@property (nonatomic, strong) id nilFilePresenter;
@property (nonatomic, strong) id nilFastEnumeration;

@end

@implementation KKNilForProtocolTests

- (void)setUp {
  self.nilFilePresenter = [KKNil nilForProtocol:@protocol(NSFilePresenter)];
  self.nilFastEnumeration = [KKNil nilForProtocol:@protocol(NSFastEnumeration)];
}

- (void)testCreatingObjectsWithNilForProtocol {
  XCTAssertTrue([self.nilFilePresenter isKindOfClass:[KKNil class]]);
  XCTAssertTrue([self.nilFastEnumeration isKindOfClass:[KKNil class]]);
}

- (void)testRespondingToRequiredMethods {
  XCTAssertTrue([self.nilFilePresenter respondsToSelector:@selector(presentedItemURL)]);
  XCTAssertTrue([self.nilFastEnumeration respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]);
  XCTAssertNoThrow([self.nilFilePresenter presentedItemURL]);
  XCTAssertNoThrow([self.nilFastEnumeration countByEnumeratingWithState:nil objects:NULL count:0]);
}

- (void)testRespondingToOptionalMethods {
  XCTAssertTrue([self.nilFilePresenter respondsToSelector:@selector(primaryPresentedItemURL)]);
  XCTAssertNoThrow([self.nilFilePresenter primaryPresentedItemURL]);
}

- (void)testNotRespondingToOtherMethods {
  XCTAssertFalse([self.nilFilePresenter respondsToSelector:@selector(characterAtIndex:)]);
  XCTAssertFalse([self.nilFastEnumeration respondsToSelector:@selector(longLongValue)]);
  XCTAssertThrows([self.nilFilePresenter characterAtIndex:0]);
  XCTAssertThrows([self.nilFastEnumeration longLongValue]);
}

- (void)testReturningNilMethodSignatureForUnknownMethods {
  XCTAssertNoThrow([self.nilFilePresenter methodSignatureForSelector:@selector(characterAtIndex:)]);
  XCTAssertNil([self.nilFilePresenter methodSignatureForSelector:@selector(characterAtIndex:)]);
}

- (void)testReturningNilForMethodsReturningId {
  XCTAssertNil([self.nilFilePresenter presentedItemURL]);
  XCTAssertNil([self.nilFilePresenter presentedItemOperationQueue]);
}

@end
