//
//  PasteManTests.m
//  PasteManTests
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PasteManCore.h"

@interface PasteManTests : XCTestCase
{
    
}
@end

@implementation PasteManTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [[PasteManCore sharedCore] stopListeningForUpdates];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)addObjectsToPasteBoard:(NSArray *)objects {
    NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard clearContents];
    [pasteBoard writeObjects:objects];
}

- (void)testThatAnItemCanBeAddedToTheSList {
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    
    NSString * testString = @"Test with some object. How about tha2t!";
    [self addObjectsToPasteBoard:[NSArray arrayWithObjects:testString, nil]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
    NSArray * objStack = [[PasteManCore sharedCore] objectList];
    XCTAssertEqualObjects(testString, [objStack firstObject], @"First object in stack should be Test");
}

-(void)testThatMultipleStringsCanBeAddedToTheList {
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    
    NSString * testString = @"Test with some object. How about tha2t!";
    NSString * testString2 = @"Test with some object. How about tha2342t!";
    NSString * testString3 = @"This Pasteman is not a postman";
    NSString * testString4 = @"The above line was a joke!";

    [self addObjectsToPasteBoard:[NSArray arrayWithObjects:testString, testString2, testString3, testString4, nil]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
    NSArray * objStack = [[PasteManCore sharedCore] objectList];
    XCTAssertEqualObjects(testString, [objStack objectAtIndex:(objStack.count - 4)], @"First object in stack should be same as testString");
    XCTAssertEqualObjects(testString2, [objStack objectAtIndex:(objStack.count - 3)], @"Second object in stack should be same as testString2");
    XCTAssertEqualObjects(testString3, [objStack objectAtIndex:(objStack.count - 2)], @"Third object in stack should be same as testString3");
    XCTAssertEqualObjects(testString4, [objStack lastObject], @"Fourth object in stack should be same as testString4");
    
}

-(void)testThatDuplicatesStringsAreAvoided {
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    
    NSString * testString = @"Test with some object. How about tha2t!";
    NSString * testString2 = @"Test with some object. How about tha2t!";
    NSString * nonDuplicate = @"NOn duplicate object";
    NSString * testString3 = @"Test with some object. How about tha2t!";

    [self addObjectsToPasteBoard:[NSArray arrayWithObjects:testString, testString2,nonDuplicate,testString3, nil]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
    NSArray * objStack = [[PasteManCore sharedCore] objectList];
    NSCountedSet * objCountedSet = [NSCountedSet setWithArray:objStack];
    BOOL duplicateFound = NO;
    for (id obj in objCountedSet) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([objCountedSet countForObject:obj] > 1) {
                duplicateFound = YES;
                break;
            }
            
        }
    }
    XCTAssertFalse(duplicateFound, @"Duplicate strings found in list");
}

@end
