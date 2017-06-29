//
//  SocialLinkCell.h
//  1028
//
//  Created by fg on 2017/6/12.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialLinkCell : UITableViewCell
- (IBAction)facebookBtnClicked:(id)sender;
- (IBAction)igBtnClicked:(id)sender;
- (IBAction)youTubeBtnClicked:(id)sender;
- (IBAction)meiPaiBtnClicked:(id)sender;
- (IBAction)weiboBtnClicked:(id)sender;
- (IBAction)youkuBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *edgeDistance;

@end
