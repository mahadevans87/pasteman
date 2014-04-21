//
//  PasteManItem.m
//  PasteMan
//
//  Created by Krishna Murthy on 21/04/14.
//  Copyright (c) 2014 Prodigen. All rights reserved.
//

#import "PasteManItem.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation PasteManItem

-(id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.pasteManItemType = kPasteManItemTypeNSString;
        self.item = string;
        return self;
    }
    
    return nil;
}

-(id)initWithImage:(NSImage *)image
{
    if (self = [super init]) {
        self.pasteManItemType = kPasteManItemTypeNSImage;
        self.item = image;
        [self genrateHashCode:image];
        return self;
    }
    
    return nil;
}

-(BOOL)isEqual:(id)object {
    BOOL isEqual = NO;
    if (self.pasteManItemType == kPasteManItemTypeNSImage) {
        PasteManItem *item = (PasteManItem *)object;
        isEqual = [self.hashCode isEqualToString:item.hashCode];
    }else if (self.pasteManItemType == kPasteManItemTypeNSString) {
        PasteManItem *item = (PasteManItem *)object;
        isEqual = [self.item isEqualToString:item.item];
    }
    
    return isEqual;
}

-(void)genrateHashCode:(NSImage *)image
{
    NSData* inputData = [image TIFFRepresentation];
    unsigned char imageDigestChar[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes],
           (CC_LONG)[inputData length],
           imageDigestChar);
    
    //create the resultant MD5 hash value
    NSMutableString *imageHash = [[NSMutableString alloc] init];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [imageHash appendFormat:@"%02x", imageDigestChar[i]];
    }
    
    self.hashCode = imageHash;
}

@end
