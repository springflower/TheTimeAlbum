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
@interface FutureMailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

@implementation FutureMailViewController
{
    CGRect fullScreenBounds;
    UIRefreshControl *refreshControl;
    NSUserDefaults *defaults;
    UIImageView *MyBigSticker;
    NSMutableArray *putImageArray;
    NSMutableArray *putDateArray;
    NSMutableArray *putTextViewArray;
    NSMutableArray *putChildTextFieldnameArray;
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Prepare the MyBigSticker Image.
    NSArray *readMyBigStickerArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyBigSticker"];
    NSData* MyBigStickerImageData = [readMyBigStickerArray objectAtIndex:0];
    UIImage *MyBigStickerImage;
    if(MyBigStickerImageData) {
        MyBigStickerImage = [UIImage imageWithData:MyBigStickerImageData];
        MyBigSticker.image = MyBigStickerImage;
    }

    NSArray *readDateArray = [defaults objectForKey:@"Mailibformation"];
    if(readDateArray) {
        putDateArray  = [readDateArray mutableCopy];
    } else {
        putDateArray = [NSMutableArray new];
    }
    
    NSArray *readTextViewArray = [defaults objectForKey:@"textViewcontent"];
    if(readTextViewArray) {
        putTextViewArray = [readTextViewArray mutableCopy];
    } else {
        putTextViewArray = [NSMutableArray new];
    }
    
    putImageArray = [NSMutableArray new];
    for (int i=0; i<putDateArray.count; i++) {
        [putImageArray addObject:[UIImage imageNamed:@"PostCardVer4@2x.png"]];
    }
    
    NSArray *readChildTextFieldnameArray = [defaults objectForKey:@"ChildName"];
    if(readChildTextFieldnameArray) {
        putChildTextFieldnameArray = [readChildTextFieldnameArray mutableCopy];
    } else {
        putChildTextFieldnameArray = [NSMutableArray new];
    }
    
    
    [_myTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor flatSkyBlueColor];
    
    //_myTableView.backgroundColor = [UIColor flatWhiteColorDark];

    // To clean the tableView line Between. 去除 tableView cell 與 cell 之間的分隔線.
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    //[refreshControl setFrame:CGRectMake(0, 0, 100, 100)];
    [_myTableView addSubview:refreshControl];
    
    [self prepareHeaderView];
}

-(void)nextPage{
    [[SelectedRow object]SendSelectedRow:-1 Bool:false];
    WriteMailViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController"];
    [self presentViewController:nextPage animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    UIView *headerContentView = self.myTableView.tableHeaderView.subviews[0];
    headerContentView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY, 0));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return putDateArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FutureMaliViewControllerCellTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    Cell.MyCell.backgroundColor = [UIColor flatWhiteColorDark];
    
    Cell.UserName.text = [defaults objectForKey:@"userName"];
    Cell.ChildName.text = [putChildTextFieldnameArray objectAtIndex:0];
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
    Cell.DateAndTime.text = [putDateArray objectAtIndex:indexPath.row];
    [Cell.DateAndTime sizeToFit];
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row || indexPath.row == 0) {
        
    [[SelectedRow object]SendSelectedRow:(int)indexPath.row Bool:true];
        
    WriteMailViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController"];
    [self presentViewController:nextPage animated:YES completion:nil];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        [putDateArray removeObjectAtIndex:indexPath.row];
        [putTextViewArray removeObjectAtIndex:indexPath.row];
        
        [defaults setValue:putDateArray forKey:@"Mailibformation"];
        [defaults setValue:putTextViewArray forKey:@"textViewcontent"];
        [defaults synchronize];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:
(NSIndexPath *)indexPath {
    return YES;
}

-(void)refreshTableView {
    [_myTableView reloadData];
    
    [refreshControl endRefreshing];
}

-(void) prepareHeaderView  {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width), 270)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,200)];
    UIImage *myImage = [UIImage imageNamed:@"BeautyView@2x.jpg"];
    imageView.image = myImage;
    [headerView addSubview:imageView];
    
    
    UIButton *WriteMailBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 210, 360, 50)];
    WriteMailBtn.backgroundColor = [UIColor flatGrayColor];
    WriteMailBtn.layer.cornerRadius=5.0;
    [WriteMailBtn setTitle:@"撰寫一封信吧" forState:UIControlStateNormal];
    [WriteMailBtn setTitleColor:[UIColor flatBlueColor] forState:UIControlStateNormal];
    [WriteMailBtn addTarget:self action:@selector(nextPage)
           forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:WriteMailBtn];
    
    self.myTableView.tableHeaderView = headerView;
    //self.myTableView.tableFooterView = headerView;
    //[self.view addSubview:headerView];
    
    MyBigSticker = [[UIImageView alloc]
                    initWithFrame:CGRectMake(10, 130, 60, 60)];
    MyBigSticker.backgroundColor = [UIColor lightGrayColor];
    MyBigSticker.layer.cornerRadius=30.0;
    MyBigSticker.clipsToBounds = YES;
    MyBigSticker.layer.borderWidth = 3.0;
    MyBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    MyBigSticker.layer.masksToBounds = YES;
    MyBigSticker.image = [UIImage imageNamed:@"BabyUser@2x.png"];

    [imageView addSubview:MyBigSticker];
    
    UILabel *Myname = [[UILabel alloc] initWithFrame:CGRectMake(75, 150, 100, 100)];
    Myname.textColor = [UIColor whiteColor];
    Myname.text = @"未來信箱";
    [Myname sizeToFit];
    [imageView addSubview:Myname];
    
    UILabel *Mailintroduce = [[UILabel alloc] initWithFrame:CGRectMake(75, 170, 100, 100)];
    [Mailintroduce setFont:[UIFont boldSystemFontOfSize:14]];
    Mailintroduce.textColor = [UIColor whiteColor];
    Mailintroduce.text = @"給孩子一封未來的的信吧";
    [Mailintroduce sizeToFit];
    [imageView addSubview:Mailintroduce];
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
