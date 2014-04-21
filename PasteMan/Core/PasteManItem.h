//
//  PasteManItem.h
//  PasteMan
//
//  Created by Krishna Murthy on 21/04/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _PasteManItemType {
    kPasteManItemTypeNone = -1,
    kPasteManItemTypeNSString,
    kPasteManItemTypeNSImage
}PasteManItemType;

@interface PasteManItem : NSObject

@property(nonatomic, assign) PasteManItemType pasteManItemType;
@property(nonatomic, strong) id item;
@property(nonatomic, strong) NSString *hashCode;

-(id)initWithImage:(NSImage *)image;
-(id)initWithString:(NSString *)string;

@end
