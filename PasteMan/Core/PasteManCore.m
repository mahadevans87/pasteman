//
//  CoreLoop.m
//  PasteMan
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import "PasteManCore.h"
#import "PasteManItem.h"

@implementation PasteManCore


+(PasteManCore *)sharedCore {
    static PasteManCore *sharedSingleton;
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[PasteManCore alloc] init];
        
        return sharedSingleton;
    }
}

-(void)stopListeningForUpdates {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)listenForPasteBoardUpdates {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pasteboardTick:) userInfo:Nil repeats:YES];
}

-(id)init {
    if (self = [super init]) {
        // Init setup
        self.objectList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)pushObjectsToList:(NSArray *)copiedItems {
    for (id obj in copiedItems) {
        PasteManItem *item = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            item = [[PasteManItem alloc] initWithString:obj];
        } else if ([obj isKindOfClass:[NSImage class]]) {
            item = [[PasteManItem alloc] initWithImage:obj];
        }
        
        if (item) {
            // Check for duplicate items
            PasteManItem *removeObject = nil;
            for (id object in self.objectList) {
                if ([item isEqual:(PasteManItem *)object]) {
                    removeObject = object;
                    break;
                }
            }
            if (removeObject) {
                [self.objectList removeObject:removeObject];
            }
            [self.objectList addObject:item];
        }else {
            [self.objectList addObject:obj];
        }
    }
}


-(void)addItemToSystemPasteBoard:(id)object {
    NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard clearContents];
    [pasteBoard writeObjects:[NSArray arrayWithObjects:object,nil]];

}
-(void)pasteboardTick:(NSTimer *)timer {
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    if (pasteboard.changeCount > self.previousChangeCount) {
        NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], [NSImage class], nil];
        NSDictionary *options = [NSDictionary dictionary];
        NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
        if (copiedItems != nil) {
            [self pushObjectsToList:copiedItems];
        }
    }
    
    self.previousChangeCount = pasteboard.changeCount;
}

@end
