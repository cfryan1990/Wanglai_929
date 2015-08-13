//
//  AppDelegate.h
//  Wanglai
//
//  Created by Ryan on 14-8-12.
//  Copyright (c) 2014年 com.hdu421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "LoginViewController.h"

@class FMDatabase;
@protocol ChatDelegate;

@interface XMPPAppDelegate : NSObject <UIApplicationDelegate, XMPPRosterDelegate, XMPPvCardTempModuleDelegate>
{
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
	
	NSString *password;
	
	BOOL customCertEvaluation;
	
	BOOL isXmppConnected;
    FMDatabase* _db;
    NSString* _userIdOld;
	
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

@property (assign, nonatomic) BOOL isLogined;

@property (nonatomic,strong) id<ChatDelegate> chatDelegate;

@property (nonatomic, strong) IBOutlet UIWindow *window;


+ (XMPPAppDelegate *)sharedInstance;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSString *)docFilePath;
- (NSString *)dataFilePath;
- (NSString *)tempFilePath;
- (NSString *)imageFilePath;

- (BOOL)connect;
- (void)disconnect;
//- (FMDatabase*)getDatabase;
- (FMDatabase*)openUserDb:(NSString*)userId;

@end

@protocol ChatDelegate <NSObject>

-(void)getNewMessage:(XMPPAppDelegate *)appD Message:(XMPPMessage *)message;

@end

