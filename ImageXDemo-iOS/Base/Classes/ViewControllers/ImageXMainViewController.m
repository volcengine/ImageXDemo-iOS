/**
 * MIT License
 
 * Copyright (c) 2024 Bytedance Inc.

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
//  ImageXMainViewController.m
//  Base
//
//  Created by ByteDance on 2024/2/21.
//

#import "ImageXMainViewController.h"
#import "ImageXMainTableViewCell.h"
#import "ImageXMainModel.h"
#import <Masonry/Masonry.h>

@interface ImageXMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *imageXLabel;
@property (nonatomic, strong) UILabel *provideLabel;
@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) UITableView *settingTableView;

@end

@implementation ImageXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/RootBG"]];
    backgroundImage.frame = self.view.bounds;
    [self.view insertSubview:backgroundImage atIndex:0];
    self.navigationItem.hidesBackButton = YES;
    
    [self constructViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 15, *)) {
    }else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 15, *)) {
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)constructViews {
    [self.view addSubview:self.imageXLabel];
    [self.view addSubview:self.provideLabel];
    [self.view addSubview:self.rootTableView];
    [self.view addSubview:self.settingTableView];
    
    [self.rootTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(214);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(222);
        make.width.mas_equalTo(360);
    }];
    CGFloat provideLabelWidth = [self.provideLabel.text sizeWithAttributes:@{NSFontAttributeName:self.provideLabel.font}].width + 3;
     [self.provideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(self.rootTableView.mas_top).offset(-40);
         make.left.equalTo(self.rootTableView.mas_left);
         make.height.mas_equalTo(24);
         make.width.mas_equalTo(provideLabelWidth);
     }];
        [self.imageXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.provideLabel.mas_top).offset(-10);
            make.left.equalTo(self.rootTableView.mas_left);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(111);
        }];
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootTableView.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.right.equalTo(self.rootTableView.mas_right);
        make.height.mas_equalTo(74);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ImageXMainModel.tableViewData[tableView.tag] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ImageXDemoMainScreen";
    ImageXMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[ImageXMainTableViewCell alloc] initWithTag:tableView.tag row:indexPath.row reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = ImageXMainModel.tableViewData[tableView.tag][indexPath.row][@"action"];
    Class pushViewController = NSClassFromString(className);
    id vc = [[pushViewController alloc] init];
    if (tableView.tag == 0 && [vc respondsToSelector:NSSelectorFromString(@"setCurItem:")]) {
        NSNumber *curItem = @(indexPath.row);
        [vc performSelector:NSSelectorFromString(@"setCurItem:") withObject:curItem];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy Load

- (UILabel *)imageXLabel {
    if (_imageXLabel == nil) {
        _imageXLabel = [[UILabel alloc] init];
        _imageXLabel.text = NSLocalizedString(@"label_veImageX", nil);
        _imageXLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _imageXLabel.textColor = [UIColor colorWithRed:0x11 / 255.0 green:0x12 / 255.0 blue:0x14 / 255.0 alpha:1.0];
    }
    return _imageXLabel;
}

- (UILabel *)provideLabel {
    if (_provideLabel == nil) {
        _provideLabel = [[UILabel alloc] init];
        _provideLabel.text = NSLocalizedString(@"label_provide", nil);
        _provideLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _provideLabel.textColor = [UIColor colorWithRed:0x11 / 255.0 green:0x12 / 255.0 blue:0x14 / 255.0 alpha:1.0];
    }
    return _provideLabel;
}

- (UITableView *)rootTableView {
    if (_rootTableView == nil) {
        _rootTableView = [[UITableView alloc] init];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.layer.cornerRadius = 8.0;
        _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootTableView.tag = 0;
        _rootTableView.scrollEnabled = NO;
    }
    return _rootTableView;
}

- (UITableView *)settingTableView {
    if (_settingTableView == nil) {
        _settingTableView = [[UITableView alloc] init];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.layer.cornerRadius = 8.0;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingTableView.tag = 1;
        _settingTableView.scrollEnabled = NO;
    }
    return _settingTableView;
}

@end

