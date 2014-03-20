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

+(PasteManCore *)sharedCore;
-(void)listenForPasteBoardUpdates;

@end
