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
//  ImageXSettingsViewController.m
//  ImageXModule
//
//  Created by ByteDance on 2024/2/28.
//

#import "ImageXSettingsViewController.h"
#import "ImageXSettingsTableViewCell.h"
#import "ImageXSettingsModel.h"
#import "BDImageManagerConfig.h"
#import "BDWebImageStartUpConfig.h"
#import "BDWebImageManager.h"
#import <Masonry/Masonry.h>
#import <RangersAppLog/BDAutoTrack.h>

@interface ImageXSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *lightGrayView;

@property (nonatomic, strong) UILabel *basicSettingsLabel;
@property (nonatomic, strong) UILabel *cacheCleanLabel;
@property (nonatomic, strong) UITableView *basicSettingsTableView;
@property (nonatomic, strong) UITableView *cacheClearTableView;

@end

@implementation ImageXSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0];
    self.navigationItem.title = NSLocalizedString(@"label_settings", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18], NSForegroundColorAttributeName:[UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0]}];
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self constructViews];
}

- (void)constructViews {
    [self.view addSubview:self.lightGrayView];
    [self.lightGrayView addSubview:self.basicSettingsLabel];
    [self.lightGrayView addSubview:self.basicSettingsTableView];
    [self.lightGrayView addSubview:self.cacheCleanLabel];
    [self.lightGrayView addSubview:self.cacheClearTableView];
    
    CGFloat topOffset = UIApplication.sharedApplication.statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    [self.lightGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topOffset);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    CGFloat basicSettingsLabelWidth = [self.basicSettingsLabel.text sizeWithAttributes:@{NSFontAttributeName:self.basicSettingsLabel.font}].width + 3;
    [self.basicSettingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightGrayView.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(basicSettingsLabelWidth);
    }];
    [self.basicSettingsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.basicSettingsLabel.mas_bottom).offset(8);
        make.height.mas_equalTo([ImageXSettingsModel.tableViewData[self.basicSettingsTableView.tag] count] * 54);
    }];
    CGFloat cacheCleanLabelWidth = [self.cacheCleanLabel.text sizeWithAttributes:@{NSFontAttributeName:self.cacheCleanLabel.font}].width + 3;
    [self.cacheCleanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.basicSettingsTableView.mas_bottom).offset(24);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(cacheCleanLabelWidth);
    }];
    [self.cacheClearTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.cacheCleanLabel.mas_bottom).offset(8);
        make.height.mas_equalTo([ImageXSettingsModel.tableViewData[self.cacheClearTableView.tag] count] * 54);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ImageXSettingsModel.tableViewData[tableView.tag] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ImageXDemoSettings";
    ImageXSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    ImageXSettingType type = (tableView.tag == 1 && indexPath.row > 1) ? ImageXSettingSelectType : ImageXSettingActionType;
    if(!cell){
        cell = [[ImageXSettingsTableViewCell alloc] initWithTag:tableView.tag row:indexPath.row reuseIdentifier:cellID type:type];
    }
    if (type == ImageXSettingActionType) {
        NSString *method = ImageXSettingsModel.tableViewData[tableView.tag][indexPath.row][@"methodName"];
        if (method.length > 0 && [self respondsToSelector:NSSelectorFromString(method)]) {
            cell.rightLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(method)];
            [cell.rightLabel addGestureRecognizer:tapGesture];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Lazy Load

- (UIView *)lightGrayView {
    if (_lightGrayView == nil) {
        _lightGrayView = [[UIView alloc] init];
        _lightGrayView.backgroundColor = [UIColor colorWithRed:0xF7 / 255.0 green:0xF8 / 255.0 blue:0xFA / 255.0 alpha:1.0];
    }
    return _lightGrayView;
}

- (UILabel *)basicSettingsLabel {
    if (_basicSettingsLabel == nil) {
        _basicSettingsLabel = [[UILabel alloc] init];
        _basicSettingsLabel.text = NSLocalizedString(@"basic_settings", nil);
        _basicSettingsLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _basicSettingsLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
    }
    return _basicSettingsLabel;
}

- (UITableView *)basicSettingsTableView {
    if (_basicSettingsTableView == nil) {
        _basicSettingsTableView = [[UITableView alloc] init];
        _basicSettingsTableView.delegate = self;
        _basicSettingsTableView.dataSource = self;
        _basicSettingsTableView.tag = 0;
        _basicSettingsTableView.scrollEnabled = NO;
    }
    return _basicSettingsTableView;
}

- (UILabel *)cacheCleanLabel {
    if (_cacheCleanLabel == nil) {
        _cacheCleanLabel = [[UILabel alloc] init];
        _cacheCleanLabel.text = NSLocalizedString(@"cache_settings", nil);
        _cacheCleanLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _cacheCleanLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
    }
    return _cacheCleanLabel;
}

- (UITableView *)cacheClearTableView {
    if (_cacheClearTableView == nil) {
        _cacheClearTableView = [[UITableView alloc] init];
        _cacheClearTableView.delegate = self;
        _cacheClearTableView.dataSource = self;
        _cacheClearTableView.tag = 1;
        _cacheClearTableView.scrollEnabled = NO;
    }
    return _cacheClearTableView;
}

- (void)changeAppID {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"change_appID", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"appID_placeholder", nil);
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = 0;
        textField.delegate = self;
    }];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *appID = textField.text;
        if (appID.length > 0) {
            BDAutoTrackConfig *config = [BDAutoTrackConfig configWithAppID:appID
                                                             launchOptions:nil];
            config.channel = @"App Store";
            config.appName = @"dp_tob_sdk_test2";
            config.showDebugLog = YES;
            config.logger = ^(NSString * _Nullable log) {
                NSLog(@"applog -- %@", log);
            };
            config.logNeedEncrypt = NO;
            [BDAutoTrack startTrackWithConfig:config];
            
            BDWebImageStartUpConfig * imageConfig = [BDWebImageStartUpConfig new];
            imageConfig.appID = appID;
            imageConfig.serviceVendor = BDImageServiceVendorCN;
            [[BDWebImageManager sharedManager] startUpWithConfig:imageConfig];
            
            [[NSUserDefaults standardUserDefaults] setObject:appID forKey:@"kImageXAppID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.basicSettingsTableView removeFromSuperview];
            self.basicSettingsTableView = nil;
            [self constructViews];
        }
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showCloudConfig {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.navigationItem.title = NSLocalizedString(@"settings_cloudconfig", nil);
    vc.view.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:({
        UILabel *cloudConfigLabel = [[UILabel alloc] initWithFrame:vc.view.bounds];
        cloudConfigLabel.numberOfLines = 0;
        cloudConfigLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cloudConfigLabel.text = [[BDImageManagerConfig sharedInstance] remoteConfigDescription];
        cloudConfigLabel.textColor = [UIColor blackColor];
        cloudConfigLabel.font = [UIFont systemFontOfSize:12];
        cloudConfigLabel;
    })];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cleanDiskCache {
    // clean disk cache
    [self.cacheClearTableView removeFromSuperview];
    self.cacheClearTableView = nil;
    __weak typeof(self) weakSelf = self;
    [BDWebImageManager.sharedManager.imageCache clearDiskWithBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"clear_disk_done", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }]];
            [strongSelf presentViewController:alert animated:YES completion:nil];
            [strongSelf.lightGrayView addSubview:self.cacheClearTableView];
            [strongSelf.cacheClearTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(strongSelf.view.mas_left);
                make.right.equalTo(strongSelf.view.mas_right);
                make.top.equalTo(strongSelf.cacheCleanLabel.mas_bottom).offset(8);
                make.height.mas_equalTo([ImageXSettingsModel.tableViewData[strongSelf.cacheClearTableView.tag] count] * 54);
            }];
        });
    }];
    
    
}

- (void)cleanMemoryCache {
    // clean memory cache
    [BDWebImageManager.sharedManager.imageCache.memoryCache removeAllObjects];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"clear_memory_done", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 0) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filteredString];
    }
    return YES;
}

@end
