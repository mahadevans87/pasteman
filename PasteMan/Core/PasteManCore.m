//
//  CoreLoop.m
//  PasteMan
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import "PasteManCore.h"

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

-(void)listenForPasteBoardUpdates {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pasteboardTick:) userInfo:Nil repeats:YES];
}

-(id)init {
    if (self = [super init]) {
        // Init setup
    }
    return self;
}

-(void)pasteboardTick:(NSTimer *)timer {
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    if (pasteboard.changeCount > self.previousChangeCount) {
        NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], [NSImage class], nil];
        NSDictionary *options = [NSDictionary dictionary];
        NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
        if (copiedItems != nil) {
            NSLog(@"%@",copiedItems);
        }
    }
    
    self.previousChangeCount = pasteboard.changeCount;
}

@end
