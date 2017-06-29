//
//  SocialLinkCell.m
//  1028
//
//  Created by fg on 2017/6/12.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "SocialLinkCell.h"

@implementation SocialLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openDaleDietrichDotCom:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)facebookBtnClicked:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028FB]];
}

- (IBAction)igBtnClicked:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028IG]];
}

- (IBAction)youTubeBtnClicked:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028YouTube]];
}

- (IBAction)meiPaiBtnClicked:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028MeiPai]];
}

- (IBAction)weiboBtnClicked:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028WeiBo]];
}

- (IBAction)youkuBtnClick:(id)sender {
    [self openDaleDietrichDotCom:[ApiBuilder get1028YouKu]];
}
@end
