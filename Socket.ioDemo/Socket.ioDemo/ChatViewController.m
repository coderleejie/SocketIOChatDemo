//
//  ChatViewController.m
//  Socket.ioDemo
//
//  Created by lottak_mac2 on 16/9/20.
//  Copyright © 2016年 com.lottak. All rights reserved.
//

#import "ChatViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"

@interface ChatViewController ()<SocketIODelegate,UITableViewDelegate,UITableViewDataSource> {
    SocketIO *_socketIO;
    UITableView *_tableView;
    NSMutableArray<NSDictionary*> *_dataArr;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userName = [NSString stringWithFormat:@"%d号用户",arc4random()%100 + 1];
    self.title = userName;
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"localhost" onPort:3000];//连接
    _dataArr = [@[] mutableCopy];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser:)],[[UIBarButtonItem alloc]initWithTitle:@"发" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)]];
    [_socketIO sendEvent:@"adduser" withData:userName];//添加用户
    // Do any additional setup after loading the view.
}
- (void)addUser:(UIBarButtonItem*)item {
    [self.navigationController pushViewController:[ChatViewController new] animated:YES];
}
- (void)sendMessage:(UIBarButtonItem*)item {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入聊天内容...";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *message = [alertVC.textFields[0] text];
        [_socketIO sendEvent:@"sendchat" withData:message];//发送消息
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okAction];
    [alertVC addAction:cancleAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@说:",_dataArr[indexPath.row].allKeys[0]];
    cell.detailTextLabel.text = _dataArr[indexPath.row].allValues[0];
    return cell;
}
#pragma mark -- SocketIODelegate
- (void) socketIODidConnect:(SocketIO *)socket {
    
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    
}
- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    
}
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    if([packet.name isEqualToString:@"updatechat"]) {
        [_dataArr addObject:@{packet.args[0]:packet.args[1]}];
        [_tableView reloadData];
    }
}
- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    
}
- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    
}


@end
