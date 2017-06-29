//
//  AddressCell.h
//  FG
//
//  Created by Kenny on 2015/8/24.
//  Copyright (c) 2015年 FG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldNoMenu.h"

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TextFieldNoMenu *cityField;
@property (weak, nonatomic) IBOutlet TextFieldNoMenu *addressField;
@end
