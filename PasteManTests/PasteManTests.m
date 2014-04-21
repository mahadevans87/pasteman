//
//  PasteManTests.m
//  PasteManTests
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PasteManCore.h"
#import "PasteManItem.h"

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
    PasteManItem * firstItem = [objStack firstObject];
    XCTAssertEqualObjects(testString, firstItem.item, @"First object in stack should be Test");
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
    PasteManItem * pManItem = [objStack objectAtIndex:(objStack.count - 4)];
    XCTAssertEqualObjects(testString, pManItem.item, @"First object in stack should be same as testString");

    PasteManItem * pManItem1 = [objStack objectAtIndex:(objStack.count - 3)];

    XCTAssertEqualObjects(testString2, pManItem1.item, @"Second object in stack should be same as testString2");

    
    PasteManItem * pManItem2 = [objStack objectAtIndex:(objStack.count - 2)];

    XCTAssertEqualObjects(testString3, pManItem2.item, @"Third object in stack should be same as testString3");

    
    PasteManItem * pManItem3 = [objStack lastObject];

    XCTAssertEqualObjects(testString4, pManItem3.item, @"Fourth object in stack should be same as testString4");
    
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

-(void)testThatDuplicateStringsAreAvoidedAndAreMovedToTheLastOfTheObjectList {
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    
    NSString * testString = @"Test with some object. How about tha2t!";
    NSString * testString2 = @"Test with some object. How about tha2t!";
    NSString * nonDuplicate = @"NOn duplicate object";
    NSString * testString3 = @"Test with some object. How about tha2t!";
    
    [self addObjectsToPasteBoard:[NSArray arrayWithObjects:testString, testString2,nonDuplicate,testString3, nil]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
    NSArray * objStack = [[PasteManCore sharedCore] objectList];
    
    NSInteger indexOfNonDuplicate = -1;
    NSInteger indexOfTestString3 = -1;
    for (id obj in objStack) {
        if ([obj isKindOfClass:[PasteManItem class]]) {
            PasteManItem * pManItem = (PasteManItem *)obj;
            if (pManItem.pasteManItemType == kPasteManItemTypeNSString) {
                if ([pManItem.item isEqualToString:nonDuplicate]) {
                    indexOfNonDuplicate = [objStack indexOfObject:pManItem];
                }
                if ([pManItem.item isEqualToString:testString3]) {
                    indexOfTestString3 = [objStack indexOfObject:pManItem];
                }
            }

        }
    }
    XCTAssertTrue(indexOfNonDuplicate < indexOfTestString3, @"Duplicate string is more recent than teststring3");
    
}

#pragma mark -
#pragma mark - Unit test for NSImages

-(void)testThatDuplicatesImagesAreAvoided {
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    
    NSImage *testImage = [NSImage imageNamed:@"trayIcon.png"];
    NSImage *testImage2 = [NSImage imageNamed:@"trayIcon.png"];
    NSImage *testImage3 = [NSImage imageNamed:@"trayIcon.png"];
    
    [self addObjectsToPasteBoard:[NSArray arrayWithObjects:testImage, testImage2,testImage3, nil]];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
    NSArray * objStack = [[PasteManCore sharedCore] objectList];
    
    // Check duplicate Image
    BOOL duplicateFound = NO;
    for (id obj in objStack) {
        PasteManItem *item = (PasteManItem *)obj;
        if (item.pasteManItemType == kPasteManItemTypeNSImage) {
            
            for (id nextObj in objStack) {
                if ([objStack indexOfObject:obj] != [objStack indexOfObject:nextObj]) {
                    if ([item isEqual:(PasteManItem *)nextObj]) {
                        duplicateFound = YES;
                        break;
                    }
                }
            }
            
            if (duplicateFound) {
                break;
            }
        }
    }
    
    XCTAssertFalse(duplicateFound, @"Duplicate strings found in list");
}



@end
