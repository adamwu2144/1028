//
//  NSMutableAttributedString+SetAsLinkSupport.m
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "NSMutableAttributedString+SetAsLinkSupport.h"

@implementation NSMutableAttributedString (SetAsLinkSupport)

- (BOOL)setAsLink:(NSString*)textToFind linkURL:(NSString*)linkURL {
    
    NSRange foundRange = [self.mutableString rangeOfString:textToFind];
    if (foundRange.location != NSNotFound) {
        [self addAttribute:NSLinkAttributeName value:linkURL range:foundRange];
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:foundRange];

        return YES;
    }
    return NO;
}

@end
