//
//  ViewController.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/19.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "ViewController.h"
#import "RootObject.h"
#import "BallViewController.h"
#import "FriendListViewController.h"
#import "BackgroundAudioVC.h"


static NSString *cellID = @"EVE";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _selectRow;//当前选择的行数
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArray;


@end

@implementation ViewController


#pragma mark - table delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [[RootObject shareRootObject] ShowStoreView];
        }
            break;
        case 1:
        {
            [[RootObject shareRootObject] showStoreEvaluation];
        }
            break;
        case 2:
        {
            [[RootObject shareRootObject] openLocalAuthentication];
        }
            break;
        case 3:
        {
            [self performSegueWithIdentifier:@"push1" sender:@(indexPath.row)];
        }
            break;
        case 4:
        {
            [[RootObject shareRootObject] openSystemCallView];
        }
            break;
        case 5:
        {
            FriendListViewController *friendListViewController = [[FriendListViewController alloc] init];
            [self.navigationController pushViewController:friendListViewController animated:YES];
        }
            break;
        case 6:
        {
            [[RootObject shareRootObject] openBrushBoard];
        }
            break;
        case 7:
        {
            [self performSegueWithIdentifier:@"pushForBgAudio" sender:@(indexPath.row)];
        }
            break;
        case 8:
        {
            [[RootObject shareRootObject] openContacts];
        }
            break;
        case 9:
        {
            [self performSegueWithIdentifier:@"pushForCorner" sender:@(indexPath.row)];
        }
            break;
        default:
            break;
    }
}


#pragma mark - getter

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        
        _titleArray = [NSMutableArray arrayWithArray:@[
                                @"本app中弹出appstore其他应用",
                                @"应用内为应用进行星级评价（ios 10.3）",
                                @"本地权限验证（touch ID,face ID）",
                                @"加速计、陀螺仪等",
                                @"调起系统通话界面（类似于qq电话）",
                                @"进入音视频聊天室（基于webRTC）",
                                @"画板（手写签名等）",
                                @"后台播放音乐并在系统控制中心显示",
                                @"获取通讯录",
                                @"自由圆角"]];
    }
    return _titleArray;
}


#pragma mark - vc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"push1"]) {
        NSNumber *index = (NSNumber *)sender;
        BallViewController *vc = (BallViewController *)segue.destinationViewController;
        vc.gtitle = self.titleArray[[index integerValue]];
    }
    else if ([segue.identifier isEqualToString:@"pushForBgAudio"])
    {
        NSNumber *index = (NSNumber *)sender;
        BackgroundAudioVC *vc = (BackgroundAudioVC *)segue.destinationViewController;
        vc.gTitle = self.titleArray[[index integerValue]];
    }
}

@end
