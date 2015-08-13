//
//  WLChatImageCell.m
//  Wanglai
//
//  Created by Ryan on 14-8-27.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "WLChatImageCell.h"

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation WLChatImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
        _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        // [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
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

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    switch (_msgStyle) {
        case WLChatImageCellStyleMe:
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
        }
            break;
        case WLChatImageCellStyleOther:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
            
        }
            break;
        default:
            break;
    }
    
    
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}


-(void)setMessageObject:(NSString*)aMessage
{
    //  [_messageConent setText:aMessage.messageContent];
    [_messageConent setText:aMessage];
    
}


- (void)setHeadImage:(UIImage *)headImage
{
    [_userHead setImage:headImage] ;
}
-(void)setChatImage:(UIImage *)chatImage
{
    [_chatImage setImage:chatImage];
  //    [_chatImage setWebImage:chatImage placeHolder:Nil downloadFlag:aTag];
}


@end
