//
//  AppDelegate.h
//  PasteMan
//
//  Created by Mahadevan on 20/03/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasteManCore.h"
#import "AppController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) AppController * appController;
@end
