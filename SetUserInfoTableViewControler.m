//
//  SetUserInfoTableViewControler.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/9/8.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "SetUserInfoTableViewControler.h"
#import "AboutMeViewcontrollerCell.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "loginViewController.h"

@interface SetUserInfoTableViewControler ()



@end

@implementation SetUserInfoTableViewControler

NSArray *userInfoArray;

NSUserDefaults *defaults;

UIImage *userImage;

NSMutableArray *userArray;

NSMutableArray *countArray;

AboutMeViewcontrollerCell *cell;

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    self.navigationItem.title = @"使用者設定";
    userInfoArray = @[@"頭像",@"使用者名稱",@"使用者帳號"];
    
    NSData *localUserImage = [defaults dataForKey:@"userImage"];
    userImage = [[UIImage alloc] initWithData:localUserImage];
    
    userArray = [[NSMutableArray alloc]
                 initWithObjects:userImage,
                 [defaults objectForKey:@"userName"],
                 [defaults objectForKey:@"userMail"], nil];
    
}
- (IBAction)backToLastPage:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return  1;
    } else if(section == 1){
        return 2;
    } else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [[AboutMeViewcontrollerCell alloc]
            initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    if(indexPath.section == 0 ) {
        cell.imageView.image = userArray[indexPath.row];
        cell.detailTextLabel.text = userInfoArray[indexPath.row];
    } else if(indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = userArray[1];
        cell.detailTextLabel.text = userInfoArray[1];
    } else if(indexPath.section == 1 && indexPath.row == 1){
        cell.textLabel.text = userArray[2];
        cell.detailTextLabel.text = userInfoArray[2];
    } else if(indexPath.section == 2) {
        cell.detailTextLabel.text = @"帳號登出";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //為table Cell 加上選取後的動畫。
    
    if(indexPath.section == 2 && indexPath.row == 0) {
        [self showAlert];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 80;
        
    }
    return 50;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"";
        
    }else {
        return @" ";
    }
    
}

-(void) showAlert {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"確定要登出帳號嗎？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^
                          (UIAlertAction * _Nonnull action) {
                              
                              // 登出ＦＢ
                              FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                              [loginManager logOut];
                              
                              
                              // 清除所有userdefaults
                              NSUserDefaults *localUserData = [NSUserDefaults standardUserDefaults];
                              NSDictionary *dictionary = [localUserData dictionaryRepresentation];
                              for(NSString *key in [dictionary allKeys]){
                                  [localUserData removeObjectForKey:key];
                                  [localUserData synchronize];
                              }
                              
                              [self goLoginPage];
                              
                          }];
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:Cancel];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) goLoginPage {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"loginPage" bundle:nil];
    loginViewController *lgvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    //[viewControllers addObject:lgvc];
    //[self.navigationController pushViewController:tlvc animated:YES];
    [self presentViewController:lgvc animated:YES completion:nil];
    //[self presentViewController:[viewControllers firstObject] animated:YES completion:nil];
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
