//
//  WLContactTableViewCell.m
//  Wanglai
//
//  Created by Ryan on 14-9-2.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "WLContactTableViewCell.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation WLContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _contactName =[[UILabel alloc]initWithFrame:CGRectZero];
        
//        [_contactName setBackgroundColor:[UIColor clearColor]];
        [_contactName setNumberOfLines:20];
        [_contactName setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_contactName];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    NSString *orgin=_contactName.text;
//    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
   //头像布局
    [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
    [_contactName setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, 0, CELL_WIDTH, CELL_HEIGHT)];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContactName:(NSString*)conatctName
{
    [_contactName setText:conatctName];
    [_contactName setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
}


- (void)setHeadImage:(UIImage *)headImage
{
    [_userHead setImage:headImage] ;
}

@end
