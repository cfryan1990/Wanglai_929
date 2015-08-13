//
//  SendMessageViewController.h
//
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPAppDelegate.h"
#import "ChatSelectionView.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatVoiceRecorderVC.h"

@interface SendMessageViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ShareMoreDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UITableView *msgRecordTable;
    NSMutableArray *msgRecordsArray;
    IBOutlet UITextField *messageText;
    IBOutlet UIView *inputBar;
    IBOutlet UIButton *switchBtn;
    IBOutlet UIButton *shareMore;
    //UIImage *_myHeadImage,*_userHeadImage;
    ChatSelectionView *_shareMoreView;
    UIButton * recordBtn;
    
    BOOL recording;
    NSTimer *peakTimer;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    
    NSString *tempRecordFileWavName;//IOS本地录音文件路径
    NSString *tempRecordFileAmrPath;//转换为amr格式文件的路径，便于网络传输
       
    ChatVoiceRecorderVC *chatVoice;
    
    bool isOnline;
    int currentMsgCount;
   
}
//消息数组
@property (nonatomic, strong) NSMutableArray *msgRecordsArray;
@property (nonatomic,strong) XMPPUserCoreDataStorageObject *xmppUserObject;

- (IBAction)shareMore:(id)sender;
- (IBAction)switchBtn:(id)sender;

@property (nonatomic, strong) XMPPJID *toJID;
@property (nonatomic, strong) NSString *toJIDString;

@end
