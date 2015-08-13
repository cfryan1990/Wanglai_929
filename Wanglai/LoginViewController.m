//
//  LoginViewController.m
//  Wanglai
//
//  Created by Ryan on 14-8-8.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
//@synthesize userTextField,passTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"欢迎";
    
    UILabel * userLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80 ,30 )];
    userLabel.text = @"用户名 :";
    userLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:userLabel];
    
    
    _userTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 200, 30)];
    _userTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_userTextField];
    
    
    UILabel * passLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 80 ,30 )];
    passLabel.text = @"密码 :";
    passLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:passLabel];
    
    
    _passTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 150, 200, 30)];
    _passTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_passTextField];
    
    /* leftbarbutton设置   */
    UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    /* rightbarbuttonitem设置   */
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(LoginController)];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.

}

- (void)dismissController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"hello");
    }];
}

//取得当前程序的委托
-(XMPPAppDelegate *)appDelegate{
    
    return (XMPPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

- (void)LoginController
{
    NSString *myJID = _userTextField.text;
    NSString *myPassword = _passTextField.text;
    
    if (myJID.length > 0 && myPassword.length > 0) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:myJID forKey:XMPPmyJID];
        [defaults setObject:myPassword forKey:XMPPmyPassword];
        
        //保存
        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[self appDelegate] connect];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
