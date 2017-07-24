//
//  addNewMessageVC.m
//  TheTimeAlbum
//
//  Created by 林子涵 on 2017/7/24.
//  Copyright © 2017年 Greathard. All rights reserved.
//

#import "addNewMessageVC.h"
#import <AFNetworking.h>
#import "myDefines.h"


@interface addNewMessageVC ()

@end

@implementation addNewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtnPressed:(id)sender {
    NSString *babyID = @"1";
    NSString *content = self.contentText.text;
    NSString *postType = @"1";
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *param2 = @{@"content": content, @"type": postType, @"babyID": babyID};
    params[@"content"] = content;
    params[@"type"] = postType;
    params[@"babyID"] = babyID;
    NSLog(@"%@.......%@........%@",params[@"content"],params[@"type"],params[@"babyID"]);
    
    [session POST:SEND_MESSAGE_URL parameters:param2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"AFN success.......");
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AFN fail.......... %@", error);
        //NSLog(@"%@", );
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
