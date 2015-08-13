//
//  WLMessageCell.m
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WLChatMessageCell.h"


#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation WLChatMessageCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
   //     _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
 //       [self.contentView addSubview:_chatImage];
       // [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];

    NSString *orgin=_messageConent.text;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];

    
    switch (_msgStyle) {
        case WLChatMessageCellStyleMe:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
             [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        //    [_userHead setImage:[UIImage imageNamed:@"defaultPerson.png"]] ;
        }
            break;
        case WLChatMessageCellStyleOther:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            
      //      [_userHead setImage:[UIImage imageNamed:@"defaultPerson.png"]] ;
        }
            break;
                default:
            break;
    }
    
    
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMessageObject:(NSString*)aMessage
{
  //  [_messageConent setText:aMessage.messageContent];
    [_messageConent setText:aMessage];
  //  [_messageConent setFont:[UIFont fontWithName:@"Arial" size:15.0]];
   
}


- (void)setHeadImage:(UIImage *)headImage
{
    [_userHead setImage:headImage] ;
}
//-(void)setChatImage:(NSURL *)chatImage tag:(int)aTag
//{
//    [_chatImage setTag:aTag];
//    [_chatImage setWebImage:chatImage placeHolder:Nil downloadFlag:aTag];
//}

@end
