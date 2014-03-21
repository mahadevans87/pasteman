//
//  AppDelegate.m
//  PasteMan
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[PasteManCore sharedCore] listenForPasteBoardUpdates];
    self.appController = [[AppController alloc] init];
    [self.appController setupStatusBar];
    
}

@end
