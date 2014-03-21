//
//  AppController.h
//  PasteMan
//
//  Created by Mahadevan on 21/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject <NSMenuDelegate>
@property (nonatomic, strong) NSStatusBar * statusBar;
@property (nonatomic, strong) NSStatusItem * statusItem;
@property (nonatomic, strong) NSMenu * trayMenu;
-(void)setupStatusBar;

@end
