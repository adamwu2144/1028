//
//  TextFieldNoMenu.m
//  1028
//
//  Created by fg on 2017/5/22.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "TextFieldNoMenu.h"

@implementation TextFieldNoMenu

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
