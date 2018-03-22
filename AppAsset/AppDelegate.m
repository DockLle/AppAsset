//
//  AppDelegate.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "AppDelegate.h"
#import "RootObject.h"
#import "CommonTool.h"

@import MediaPlayer;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"fuck真你诶");
    
    [self for3DTouch];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"com.Roe.-DTouchT"]){
//        NSArray *arr = @[@"hello 3D Touch"];
//        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
//        //设置当前的VC 为rootVC
//        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//        }];
        [[RootObject shareRootObject] openBrushBoard];
    }
    else if ([shortcutItem.type isEqualToString:@"com.Roe.-DTouchTe"])
    {
        [[RootObject shareRootObject] openContacts];
    }
    else if ([shortcutItem.type isEqualToString:@"com.Roe.-DTouchTes"])
    {
        [[[CommonTool shareTool] getCurrentVC] performSegueWithIdentifier:@"push1" sender:@(3)];
    }
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type==UIEventTypeRemoteControl)
    {
        NSInteger order=-1;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                order=UIEventSubtypeRemoteControlPause;
                break;
            case UIEventSubtypeRemoteControlPlay:
                order=UIEventSubtypeRemoteControlPlay;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                order=UIEventSubtypeRemoteControlNextTrack;
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                order=UIEventSubtypeRemoteControlPreviousTrack;
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                order=UIEventSubtypeRemoteControlTogglePlayPause;
                break;
            default:
                order=-1;
                break;
        }
        NSDictionary *orderDict=@{@"order":@(order)};
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAppDidReceiveRemoteControlNotification" object:nil userInfo:orderDict];
    }
    
}

- (void)for3DTouch
{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    
    
    // create several (dynamic) shortcut items
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.Roe.-DTouchT" localizedTitle:@"画板" localizedSubtitle:@"来签个名" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.Roe.-DTouchTe" localizedTitle:@"联系人" localizedSubtitle:@"来加个好友" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.Roe.-DTouchTes" localizedTitle:@"聊天室" localizedSubtitle:@"去看看妹子" icon:icon3 userInfo:nil];
    
    
    NSArray *items = @[item1, item2, item3];
    [UIApplication sharedApplication].shortcutItems = items;
}

@end
