//
//  WCChatSelectionView.m
//  微信
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "ChatSelectionView.h"
#define CHAT_BUTTON_SIZE 60
#define INSETS 15
#define LABEL_SIZE_HEIGHT 15
#define LABEL_SIZE_WIDTH 60


@implementation ChatSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:[UIColor whiteColor]];
       
        //初始化照片按钮
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        UILabel *photo = [[UILabel alloc]initWithFrame:CGRectMake(INSETS, INSETS+CHAT_BUTTON_SIZE+5, LABEL_SIZE_WIDTH, LABEL_SIZE_HEIGHT)];
        [photo setText:@"照片"];
        photo.font = [UIFont systemFontOfSize:12.0];
        photo.textAlignment = NSTextAlignmentCenter;
        //绑定事件,添加view
        [_photoButton addTarget:self action:@selector(pickPhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:[self setChatSectionViewItemBounds:_photoButton]];
        [self addSubview:photo];
        
        //初始化相机按钮
        _cameraButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setFrame:CGRectMake(INSETS*2+CHAT_BUTTON_SIZE , INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_cameraButton setImage:[UIImage imageNamed:@"sharemore_video"] forState:UIControlStateNormal];
        UILabel *camera = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*2+CHAT_BUTTON_SIZE, INSETS+CHAT_BUTTON_SIZE+5, LABEL_SIZE_WIDTH, LABEL_SIZE_HEIGHT)];
        [camera setText:@"相机"];
        camera.font = [UIFont systemFontOfSize:12.0];
        camera.textAlignment = NSTextAlignmentCenter;
        //绑定事件,添加view
        [_cameraButton addTarget:self action:@selector(pickImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:[self setChatSectionViewItemBounds:_cameraButton]];
        [self addSubview:camera];
        
        //初始化位置按钮
        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setFrame:CGRectMake(INSETS*3+CHAT_BUTTON_SIZE*2, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_locationButton setImage:[UIImage imageNamed:@"sharemore_location"] forState:UIControlStateNormal];
        UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*3+CHAT_BUTTON_SIZE*2, INSETS+CHAT_BUTTON_SIZE+5, LABEL_SIZE_WIDTH, LABEL_SIZE_HEIGHT)];
        [location setText:@"位置"];
        location.font = [UIFont systemFontOfSize:12.0];
        location.textAlignment = NSTextAlignmentCenter;
        //绑定事件,添加view
        [_locationButton addTarget:self action:@selector(pickPhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:[self setChatSectionViewItemBounds:_locationButton]];
        [self addSubview:location];
        
        //初始化名片按钮
        _friendCardButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_friendCardButton setFrame:CGRectMake(INSETS*4+CHAT_BUTTON_SIZE*3, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_friendCardButton setImage:[UIImage imageNamed:@"sharemore_friendcard"] forState:UIControlStateNormal];
        UILabel *friendCard = [[UILabel alloc]initWithFrame:CGRectMake(INSETS*4+CHAT_BUTTON_SIZE*3, INSETS+CHAT_BUTTON_SIZE+5, LABEL_SIZE_WIDTH, LABEL_SIZE_HEIGHT)];
        [friendCard setText:@"名片"];
        friendCard.font = [UIFont systemFontOfSize:12.0];
        friendCard.textAlignment = NSTextAlignmentCenter;
        //绑定事件,添加view
        [_locationButton addTarget:self action:@selector(pickPhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:[self setChatSectionViewItemBounds:_friendCardButton]];
        [self addSubview:friendCard];
        
        //初始化文件按钮
        _fileButon =[UIButton buttonWithType:UIButtonTypeCustom];
        [_fileButon setFrame:CGRectMake(INSETS, INSETS*2+CHAT_BUTTON_SIZE+LABEL_SIZE_HEIGHT, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE)];
        [_fileButon setImage:[UIImage imageNamed:@"sharemore_file"] forState:UIControlStateNormal];
        UILabel *file = [[UILabel alloc]initWithFrame:CGRectMake(INSETS, INSETS*2+CHAT_BUTTON_SIZE*2+LABEL_SIZE_HEIGHT+5, LABEL_SIZE_WIDTH, LABEL_SIZE_HEIGHT)];
        [file setText:@"文件"];
        file.font = [UIFont systemFontOfSize:12.0];
        file.textAlignment = NSTextAlignmentCenter;
        //绑定事件,添加view
        [_fileButon addTarget:self action:@selector(pickPhotoFromAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:[self setChatSectionViewItemBounds:_fileButon]];
        [self addSubview:file];

    }
    return self;
}


//给按钮设置边框
- (UIButton *)setChatSectionViewItemBounds:(UIButton *)button
{
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [button.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.47, 0.47, 0.47, 1 });
    [button.layer setBorderColor:colorref];//边框颜色
    return button;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)pickPhotoFromAlbum
{
    [_delegate pickPhotoFromAlbum];
}

-(void)pickImageFromCamera
{
    [_delegate pickImageFromCamera];
}

//-(UIImage *)imageDidFinishPicking
//{
//    
//}
//-(UIImage *)cameraDidFinishPicking
//{
//    
//}
//-(CLLocation *)locationDidFinishPicking
//{
//    
//}




@end
