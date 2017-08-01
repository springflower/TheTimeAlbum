//
//  FutureMailViewController.m
//  TheTimeAlbum
//
//  Created by 黃柏恩 on 2017/7/28.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "FutureMailViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "WriteMailViewController.h"
#import "FutureMaliViewControllerCellTableViewCell.h"
#import "SaveMyFutureMail.h"
@interface FutureMailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

@implementation FutureMailViewController
{
    CGRect fullScreenBounds;
    UIRefreshControl *refreshControl;
    NSUserDefaults *defaults;
    NSMutableArray *MyArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    fullScreenBounds=[[UIScreen mainScreen] bounds];
    
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [_myTableView addSubview:refreshControl];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:imageData];
    
    MyArray = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor flatPinkColor];
    
//    [MyArray addObject:@"dfndkndkndkngndk"];
//    [MyArray addObject:@"dfndkndkndkngndk"];
//    [MyArray addObject:@"dfndkndkndkngndk"];
//    [MyArray addObject:@"dfndkndkndkngndk"];
//    [MyArray addObject:@"dfndkndkndkngndk"];
//    [MyArray addObject:@"dfndkndkndkngndk"];
    [MyArray addObject:[UIImage imageNamed:@"BeautyView@2x.jpg"]];
    [MyArray addObject:[UIImage imageNamed:@"BeautyView@2x.jpg"]];
    
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
    //[self.view addSubview:headerView];
    
    UIImageView *MyBigSticker = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(10, 130, 60, 60)];
    [MyBigSticker setImage:[UIImage imageNamed:@"BabyUser@2x.png"]];
    MyBigSticker.image = image;
    MyBigSticker.backgroundColor = [UIColor lightGrayColor];
    MyBigSticker.layer.cornerRadius=30.0;
    MyBigSticker.clipsToBounds = YES;
    MyBigSticker.layer.borderWidth = 3.0;
    MyBigSticker.layer.borderColor = [UIColor whiteColor].CGColor;
    MyBigSticker.layer.masksToBounds = YES;
    
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

-(void)nextPage {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    WriteMailViewController *nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMailViewController"];
    [self presentViewController:nextPage animated:NO completion:nil];
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
    
    return MyArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//        UITableViewCell *myCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Menu"];
    
    //AboutMeViewcontrollerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTextView" forIndexPath:indexPath];

    FutureMaliViewControllerCellTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    //Cell.MyImageView.image = [UIImage imageNamed:@"Man@2x"];
//    Cell.textLabel.text = [MyArray objectAtIndex:indexPath.row];
    Cell.MyImageView.image = [MyArray objectAtIndex:indexPath.row];
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [MyArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView reloadData];
        NSLog(@"haha");
    }
}

-(void)refreshTableView {
    [_myTableView reloadData];
    
    [refreshControl endRefreshing];
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
