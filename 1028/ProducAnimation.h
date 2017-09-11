//
//  ProducAnimation.h
//  1028
//
//  Created by fg on 2017/8/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JLPresentOneTransitionType) {
    JLPresentOneTransitionTypePresent = 0,
    JLPresentOneTransitionTypeDismiss
};

@interface ProducAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) JLPresentOneTransitionType type;

@end
