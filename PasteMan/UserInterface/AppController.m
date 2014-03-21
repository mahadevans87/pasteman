//
//  AppController.m
//  PasteMan
//
//  Created by Mahadevan on 21/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import "AppController.h"
#import "PasteManCore.h"

@implementation AppController

-(void)setupStatusBar {
    self.statusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [self.statusBar statusItemWithLength:NSSquareStatusItemLength];
    NSLog(@"%@",[NSImage imageNamed:@"trayIcon.png"]);
    
    self.statusItem.image = [NSImage imageNamed:@"trayIcon.png"];
    [self.statusItem setTarget:self];
    [self.statusItem setAction:@selector(statusItemClicked:)];

}

-(void)statusItemClicked:(id)sender {
    NSZone *menuZone = [NSMenu menuZone];
    self.trayMenu = [[NSMenu allocWithZone:menuZone] init];
    [self.trayMenu setDelegate:self];
    
    [self.statusItem setMenu:self.trayMenu];
}

-(void)menuItemClicked:(id)sender {
    @synchronized([PasteManCore sharedCore].objectList) {
        id obj = [[PasteManCore sharedCore].objectList objectAtIndex:[sender tag]];
        [[PasteManCore sharedCore] addItemToSystemPasteBoard:obj];
    }
}

- (void)menuNeedsUpdate:(NSMenu*)menu {
    @synchronized([PasteManCore sharedCore].objectList) {
        NSArray * objectList = [PasteManCore sharedCore].objectList;
        [self.trayMenu removeAllItems];
        for (id obj in [objectList reverseObjectEnumerator]) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSMenuItem * menuItem = [self.trayMenu addItemWithTitle:obj action:@selector(menuItemClicked:) keyEquivalent:@""];
                [menuItem setTarget:self];
                menuItem.tag = [objectList indexOfObject:obj];
            } else if ([obj isKindOfClass:[NSImage class]]) {
                NSMenuItem * imgMenuItem = [[NSMenuItem alloc] init];
                imgMenuItem.image = obj;
                imgMenuItem.action = @selector(menuItemClicked:);
                imgMenuItem.target = self;
                imgMenuItem.title = @"";
                [self.trayMenu addItem:imgMenuItem];
                imgMenuItem.tag = [objectList indexOfObject:obj];
                
            }
            
        }
    }
    
}


@end
