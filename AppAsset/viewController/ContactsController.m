//
//  ContactsController.m
//  AppAssert
//
//  Created by 方益民 on 2018/3/21.
//  Copyright © 2018年 Reo. All rights reserved.
//

#import "ContactsController.h"


static NSString *cellID = @"听你说声";
@interface ContactsController ()

@property (nonatomic,strong) NSMutableArray<CNContact *> *contacts;

@end

@implementation ContactsController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];

    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNContactFetchRequest *fetch = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey,CNContactPhoneNumbersKey]];
    [store enumerateContactsWithFetchRequest:fetch error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [self.contacts addObject:contact];
        [self.tableView reloadData];
        
        
        
    }];
    
    [self requestAuthorizationForAddressBook];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusRestricted)
    {
        NSLog(@"通讯录不可用");
    }
    else if (authorizationStatus == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户关了权限");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你的小迷妹" message:@"通讯录权限是关闭的" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"就这样吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        [alert addAction:action];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (NSMutableArray<CNContact *> *)contacts
{
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.textLabel.text = self.contacts[indexPath.row].givenName;
    CNLabeledValue *lv = self.contacts[indexPath.row].phoneNumbers[0];
    CNPhoneNumber *pn = lv.value;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 180, 44)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = pn.stringValue;
    [cell.contentView addSubview:label];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
