//
//  FutureMailViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//
#import "SelectedRow.h"
#import "FutureMailViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "WriteMailViewController.h"
#import "FutureMaliViewControllerCellTableViewCell.h"
#import "UseDownloadDataClass.h"
@interface FutureMailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *HeaderView;



@end

@implementation FutureMailViewController
{
    CGRect fullScreenBounds;
    //UIRefreshControl *refreshControl;
    //準備讀取儲存的檔案
    NSUserDefaults *defaults;
    //準備讀取孩子的大頭貼
    UIImageView *ChidlBigStickerImageView;
    //準備讀取孩子的背景圖片
    UIImageView *MyChildBackgroundImageView;
    //準備讀取所創造的信件數量，來產生信件圖片
    NSMutableArray *putImageArray;
    //準備讀取信件的內容，當信件刪除時，內容也跟著刪除
    NSMutableArray *putTextViewArray;
    //準備讀取信件內容陣列的資料，依照所選的孩子ID
    NSMutableArray *putTextViewAddArray;
    //準備讀取孩子的名字陣列，用來顯示在信件圖片上
    NSMutableArray *putChildTextFieldnameArray;
    //準備如果沒有任何信件的話，顯示這個 View.
    UIView *DescriptionView;
    //準備讀取目前選擇的小孩ID.
    NSInteger ChildID;
    //準備讀取信件的創造日期，用來顯示在信件圖片上
    NSMutableArray *putDateArray;
    //準備讀取信件陣列，依所選擇的小孩ID來決定
    NSMutableArray *putDateAddArray;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self updateDate];
    
    }
//準備更新資料
-(void)updateDate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //讀取目前所選擇的小孩ID
        ChildID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChildID"];
        
        // Prepare the MyBigSticker Image. 準備讀取孩子的大頭貼
        if([[UseDownloadDataClass object] ReadChildBigStickerArray].count != 0) {
            NSArray *readChildBigStickerArray = [[UseDownloadDataClass object] ReadChildBigStickerArray];
            NSData* ChildBigStickerImageData = [readChildBigStickerArray objectAtIndex:ChildID];
            if(readChildBigStickerArray.count != 0) {
                ChidlBigStickerImageView.image = [UIImage imageWithData:ChildBigStickerImageData];
            }
        }
        //讀取孩子背景圖片陣列
        NSArray *readMyChildBackImageArray = [defaults objectForKey:@"readMyChildBackImageArray"];
        if(![readMyChildBackImageArray[ChildID] isKindOfClass:[NSString class]]) {
            NSData* ChildBackgroundImageData = [readMyChildBackImageArray objectAtIndex:ChildID];
            MyChildBackgroundImageView.image = [UIImage imageWithData:ChildBackgroundImageData];
        } else {
            MyChildBackgroundImageView.image = [UIImage imageNamed:readMyChildBackImageArray[ChildID]];
        }
        
        // Prepare the WriteDateArray. 準備讀取使用者信件的創建日期.
        NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
        if(readDateArray) {
            putDateArray  = [readDateArray mutableCopy];
            putDateAddArray = [[putDateArray objectAtIndex:ChildID] mutableCopy];
        } else {
            putDateArray = [NSMutableArray new];
            putDateAddArray = [NSMutableArray new];
        }
        
        // Prepare the judgt the putDateArray is empty or have value. 準備讀取使用者使否有創建信件，如果沒有就顯示有就不顯示.
        if(putDateAddArray.count == 0) {
            DescriptionView.hidden = NO;
        } else
            DescriptionView.hidden = YES;
        
        // Prepare the readTextViewArray. 準備讀取使用者信件的內容，用來連動當要刪除信件時，內容也跟著刪除。
        NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
        if(readTextViewArray) {
            putTextViewArray = [readTextViewArray mutableCopy];
            putTextViewAddArray = [[putTextViewArray objectAtIndex:ChildID] mutableCopy];
        } else {
            putTextViewArray = [NSMutableArray new];
            putTextViewAddArray = [NSMutableArray new];
        }
        
        // Prepare the putImageArray. 準備讀取日期陣列是否有存值，來產生信件圖片的數量。
        putImageArray = [NSMutableArray new];
        for (int i=0; i<putDateAddArray.count; i++) {
            [putImageArray addObject:[UIImage imageNamed:@"PostCardVer4@2x.png"]];
        }
        
        // Prepare the readChildTextFieldnameArray. 準備讀取所創建的孩子名字，根據所選取的孩子名稱來決定信件上孩子的名字。
        NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
        if(readChildTextFieldnameArray) {
            putChildTextFieldnameArray = [readChildTextFieldnameArray mutableCopy];
        } else {
            putChildTextFieldnameArray = [NSMutableArray new];
        }
        
        //當要顯示時，進行 tableView 的更新
        [_myTableView reloadData];
        //  [refreshControl endRefreshing];
        
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //設定 navigation bar 顯示
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    //準備讀取儲存的資料
    defaults = [NSUserDefaults standardUserDefaults];
    //設定背景顏色
    self.view.backgroundColor = [UIColor flatSkyBlueColor];
    
    //To clean the tableView line Between. 去除 tableView cell 與 cell 之間的分隔線.
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self prepareHeaderView];
    
    //設定當通知發生時，執行 FutureMailViewController 來更新資料
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDate) name:@"FutureMailViewController" object:nil];
}

#pragma mark - Prepare to NextPage 準備到下一頁

-(void)nextPage {
    [[SelectedRow object]SendSelectedRowAboutMail:-1 Bool:false];
    WriteMailViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController"];
    [self presentViewController:nextPage animated:YES completion:nil];
}

#pragma mark - Setting the scrollViewDidScroll function 設定 ScrollView 被滑動時設定條件

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"Y軸為：%f",offsetY);
    UIView *headerContentView = self.myTableView.tableHeaderView.subviews[0];
    
    headerContentView.transform = CGAffineTransformMakeTranslation(0,MIN(offsetY,0));
 
}

#pragma mark -Prepare TableViewSection and Cell 準備 tableView 的 Section 與 Cell

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
        return putDateAddArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FutureMaliViewControllerCellTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    if(putImageArray.count !=0 || putDateArray.count !=0 ) {
        Cell.MyCell.backgroundColor = [UIColor whiteColor];
        
        Cell.UserName.text = [defaults objectForKey:@"userName"];
        Cell.ChildName.text = [putChildTextFieldnameArray objectAtIndex:ChildID];
        [Cell.UserName sizeToFit];
        [Cell.ChildName sizeToFit];
        
        //Cell.MyImageView.clipsToBounds = true;    //建立 MyImageView 的圓形
        //Cell.MyImageView.layer.cornerRadius = 12;
        Cell.MyImageView.layer.borderWidth = 1;
        Cell.MyImageView.layer.borderColor = [UIColor flatSandColor].CGColor;
        
        Cell.MyImageView.layer.shadowOffset = CGSizeMake(0,5);
        Cell.MyImageView.layer.shadowRadius = 3.5;
        Cell.MyImageView.layer.shadowOpacity = 0.8;
        Cell.MyImageView.layer.masksToBounds = false;
        
        Cell.MyImageView.image = [putImageArray objectAtIndex:indexPath.row];
        Cell.DateAndTime.text = [putDateAddArray objectAtIndex:indexPath.row];
        [Cell.DateAndTime sizeToFit];
        return Cell;
    }
    return Cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row || indexPath.row == 0) {
        
    [[SelectedRow object]SendSelectedRowAboutMail:(int)indexPath.row Bool:true];
        
    WriteMailViewController *editController = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController2"];
        [self.navigationController pushViewController:editController animated:YES];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
 
        [putDateAddArray removeObjectAtIndex:indexPath.row];
        [putTextViewAddArray removeObjectAtIndex:indexPath.row];
        
        putDateArray[ChildID] = putDateAddArray;
        putTextViewArray[ChildID] = putTextViewAddArray;
        
        [defaults setValue:putDateArray forKey:@"Mailibformation"];
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        [defaults synchronize];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.2];
        [transition setType:kCATransitionFade];
        [DescriptionView.layer addAnimation:transition forKey:nil];
            if(putDateAddArray.count == 0) {
                DescriptionView.hidden = NO;
            } else {
                DescriptionView.hidden = YES;
            }
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:
(NSIndexPath *)indexPath {
    return YES;
}


-(void)refreshTableView {
    
    [_myTableView reloadData];
    
}


#pragma mark - Prepare the tableViewOfHeaderView 準備 tableView 的 HederView

-(void) prepareHeaderView  {
    
    //設定一個 UIView 給 myTableView 的 HeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width), 290)];
    MyChildBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,220)];
    [headerView addSubview:MyChildBackgroundImageView];
    
    //設定一個 Buttton 給 headerView
    UIButton *WriteMailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 225,self.view.frame.size.width, 50)];
    WriteMailBtn.backgroundColor = [UIColor flatGrayColor];
    WriteMailBtn.layer.cornerRadius=5.0;
    [WriteMailBtn setImage:[UIImage imageNamed:@"WriteMailImage75x75@2x.png"] forState:UIControlStateNormal];
    [WriteMailBtn setTitle:@"撰寫一封信吧" forState:UIControlStateNormal];
    [WriteMailBtn setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
    [WriteMailBtn addTarget:self action:@selector(nextPage)
           forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:WriteMailBtn];
    
    //設定一個 UIView 給 headerView
    DescriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, (self.view.frame.size.width), 200)];
    //DescriptionView.backgroundColor = [UIColor flatSandColor];
    [headerView addSubview:DescriptionView];
    
    //設定一個 UIlabel 給 DescriptionView
    UILabel *WriteFirstMailLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-70, 10,140,100)];
    //WriteFirstMailLabel.backgroundColor = [UIColor blueColor];
    [WriteFirstMailLabel setTextColor:[UIColor flatGrayColor]];
    [WriteFirstMailLabel setNumberOfLines:0];
    WriteFirstMailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    WriteFirstMailLabel.text = @"目前還沒有任何一封信喔，為孩子寫下第一封信吧～";
    //[WriteFirstMailLabel sizeToFit];
    [DescriptionView addSubview:WriteFirstMailLabel];
    
    //設定一個 ImageView 給 DescriptionView
    UIImageView *WriteMailImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-50, 100, 100, 100)];
    WriteMailImageView.image = [UIImage imageNamed:@"WriteMailImage@2x.png"];
    WriteMailImageView.tintColor = [UIColor flatGrayColor];
    [DescriptionView addSubview:WriteMailImageView];
    
    //將設定好的 UIView 給 mytableView 的 HeaderView
    self.myTableView.tableHeaderView = headerView;
    
    //設定放置大頭貼的 ImageView 給 MyChildBackgroundImageView
    ChidlBigStickerImageView = [[UIImageView alloc]
                    initWithFrame:CGRectMake(10, 130, 80, 80)];
    ChidlBigStickerImageView.backgroundColor = [UIColor lightGrayColor];
    ChidlBigStickerImageView.layer.cornerRadius=40.0;
    ChidlBigStickerImageView.clipsToBounds = YES;
    ChidlBigStickerImageView.layer.borderWidth = 3.0;
    ChidlBigStickerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    ChidlBigStickerImageView.layer.masksToBounds = YES;
    ChidlBigStickerImageView.image = [UIImage imageNamed:@"BabyUser@2x.png"];
    [MyChildBackgroundImageView addSubview:ChidlBigStickerImageView];
    
    //設定一個 UILabel 給 MyChildBackgroundImageView
    UILabel *Myname = [[UILabel alloc] initWithFrame:CGRectMake(95, 165, 100, 100)];
    [Myname setFont:[UIFont boldSystemFontOfSize:18]];
    Myname.textColor = [UIColor whiteColor];
    Myname.text = @"未來信箱";
    [Myname sizeToFit];
    [MyChildBackgroundImageView addSubview:Myname];
    
    //設定一個 UILabel 給 MyChildBackgroundImageView
    UILabel *Mailintroduce = [[UILabel alloc] initWithFrame:CGRectMake(95, 185, 100, 100)];
    [Mailintroduce setFont:[UIFont boldSystemFontOfSize:16]];
    Mailintroduce.textColor = [UIColor whiteColor];
    Mailintroduce.text = @"給孩子一封未來的的信吧";
    [Mailintroduce sizeToFit];
    [MyChildBackgroundImageView addSubview:Mailintroduce];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIImage *myImage = [UIImage imageNamed:@"loginHeader.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.backgroundColor = [UIColor grayColor];
   // imageView.frame = CGRectMake(10,10,300,100);

    return imageView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 50;
    } else {
        return 0;
    }
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
