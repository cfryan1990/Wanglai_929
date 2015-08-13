//
//  LoginViewController.h
//  Wanglai
//
//  Created by Ryan on 14-8-8.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController
{
    UITextField *userTextField;
}

@property (nonatomic,retain) UITextField * userTextField;
@property (nonatomic,retain) UITextField * passTextField;

@end
