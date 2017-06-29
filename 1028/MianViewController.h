//
//  MianViewController.h
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Framework/ICSDrawerController/ICSDrawerController.h"


@interface MianViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property (strong, nonatomic) IBOutlet UITextView *mytextView;

@property(nonatomic, weak) ICSDrawerController *drawer;


@end
