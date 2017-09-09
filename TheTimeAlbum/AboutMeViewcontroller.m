//
//  AboutMeViewcontroller.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/18.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import "SelectedRow.h"
#import "UpdateDataView.h"
#import "AboutMeViewcontroller.h"
#import "AboutMeViewcontrollerCell.h"
#import "SetInfoTableViewControler.h"
#import "AddChildSettingViewController.h"
#import "SetUserInfoTableViewControler.h"
#define PERSONALINFORMATION @"個人帳號資料"

@interface AboutMeViewcontroller ()
{
    NSUserDefaults *defaults;
    
    NSArray * information;
    NSMutableArray *userArray;
    NSMutableArray *packegUserArray;
    NSMutableArray *putinformationArray;
    UILabel *label;
    
    UpdateDataView *downloadMailContent;
}

@end

@implementation AboutMeViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];

    NSData *localUserImage = [defaults dataForKey:@"userImage"];
    UIImage *userImage = [[UIImage alloc] initWithData:localUserImage];
    userArray = [[NSMutableArray alloc]
                 initWithObjects:userImage,
                 [defaults objectForKey:@"userName"],
                 [defaults objectForKey:@"userMail"], nil];
    packegUserArray = [[NSMutableArray alloc] initWithObjects:userArray, nil];
    information = @[@"孩子設定",@"關於我們",@"清除緩存"];
    
    putinformationArray = [[NSMutableArray alloc] initWithObjects:packegUserArray,information, nil];
    
    self.navigationItem.title = PERSONALINFORMATION;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self getSize];
    
    //讀取是否已有建立第一個孩子.
    NSUserDefaults *readChildNameDefaults;
    readChildNameDefaults = [NSUserDefaults standardUserDefaults];
    //如果讀出的陣列數量為零的話，就執行 AddChildSettingViewController 來創造第一個孩子。
    NSArray *readChildTextFieldnameArray = [readChildNameDefaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray.count == 0) {
//        AddChildSettingViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildSettingViewController"];
//        [self presentViewController:nextPage animated:YES completion:nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc =
        [storyboard instantiateViewControllerWithIdentifier:@"StartCreateFirstChildViewController"];
        //[self.navigationController pushViewController:vc animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [[putinformationArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AboutMeViewcontrollerCell *myCell=[[AboutMeViewcontrollerCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Menu"];
    if(indexPath.section == 0) {
        myCell.imageView.layer.cornerRadius = 32;
        myCell.imageView.clipsToBounds = YES;
        myCell.imageView.layer.borderWidth = 1.0;
        myCell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        myCell.imageView.layer.masksToBounds = YES;
        myCell.imageView.image = [userArray objectAtIndex:0];
        myCell.textLabel.text = [userArray objectAtIndex:1];
        myCell.detailTextLabel.text = [userArray objectAtIndex:2];
        return myCell;
    } else if(indexPath.row == 2){
        myCell.textLabel.text = [[putinformationArray objectAtIndex:1] objectAtIndex:indexPath.row];
        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        myCell.detailTextLabel.text = [NSString stringWithFormat:@"目前暫存容量為：%ld MB",(long)[self getSize]];
        return  myCell;
    } else {
        myCell.textLabel.text = [[putinformationArray objectAtIndex:1] objectAtIndex:indexPath.row];
        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return myCell;
    }

}

//設定分類開頭標題
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"";

    }else {
        return @" ";
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 80;

    }
        return 50;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //為table Cell 加上選取後的動畫。
    if(indexPath.section == 0) {
        SetUserInfoTableViewControler *editUserControler = [self.storyboard instantiateViewControllerWithIdentifier:@"SetUserInfoTableViewControler"];
        [self.navigationController pushViewController:editUserControler animated:YES];
        
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            SetInfoTableViewControler *editController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetInfoTableViewControler"];
            [self.navigationController pushViewController:editController animated:YES];
        }else if(indexPath.row == 2) {
            [self showAlert];
        }
    }
}


-(void) showAlert {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"確定清除暫存檔嗎？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^
                          (UIAlertAction * _Nonnull action) {
                              [self clearDisk];
                              [self.tableView reloadData];
                            
                          }];
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:Cancel];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Prepare to clean Temp fil

- (void)clearDisk {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * tmpDirectory = NSTemporaryDirectory();
    NSError *error;
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:tmpDirectory error:&error];
    for (NSString *file in cacheFiles)
    {
        error = nil;
        [fileManager removeItemAtPath:[tmpDirectory stringByAppendingPathComponent:file] error:&error];
    }
}

#pragma mark - Prepare to count temp file Memory 準備計算 Temp 資料夾裏檔案 的容量

- (NSInteger)getSize {
    NSUInteger size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:tmpDirectory];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [tmpDirectory stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    NSLog(@"temp的容量為 ：%lu MB",(unsigned long)size/1000000);
    return size/1000000;
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
