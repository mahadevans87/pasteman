//
//  CoreLoop.h
//  PasteMan
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasteManCore : NSObject

@property NSInteger previousChangeCount;
@property (strong) NSTimer * timer;
@property (atomic, strong) NSMutableArray * objectList;

+(PasteManCore *)sharedCore;

-(void)listenForPasteBoardUpdates;
-(void)stopListeningForUpdates;

-(void)pushObjectsToList:(NSArray *)copiedItems;

-(void)addItemToSystemPasteBoard:(id)object;

@end
