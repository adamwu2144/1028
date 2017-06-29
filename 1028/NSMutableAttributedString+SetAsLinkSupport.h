//
//  NSMutableAttributedString+SetAsLinkSupport.h
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (SetAsLinkSupport)

- (BOOL)setAsLink:(NSString*)textToFind linkURL:(NSString*)linkURL;

@end
