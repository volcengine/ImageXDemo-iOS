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
//  ImageXDecodingDetailsViewController.m
//  ImageXModule
//
//  Created by ByteDance on 2024/4/9.
//

#import "ImageXDecodingDetailsViewController.h"
#import "ImageXDetailsTableViewCell.h"
#import "UIImageView+BDWebImage.h"
#import "BDImageView.h"
#import "UIImage+BDImageTransform.h"
#import "ImageXSettingsModel.h"
#import "ImageXUIUtils.h"
#import <Masonry/Masonry.h>

#define CELL_TAG_OFFSET 100

@interface ImageXDecodingDetailsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *recordDic;
@property (nonatomic, strong) NSString *loadStatus;
@property (nonatomic, assign) CGFloat urlLabelHeight;
@property (nonatomic, assign) CGFloat errLabelHeight;

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) BDImageView *imageView;
@property (nonatomic, strong) UILabel *basicLabel;
@property (nonatomic, strong) UITableView *basicTableView;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UITableView *logTableView;
@property (nonatomic, strong) UILabel *logInfoLabel;
@property (nonatomic, strong) MASConstraint *logInfoLabelHeightConstraint;
@property (nonatomic, assign) BOOL logInfoLabelExpanded;

@end

@implementation ImageXDecodingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0];
    self.navigationItem.title = NSLocalizedString(@"decode_details", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:18], NSForegroundColorAttributeName:[UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0]}];
    self.navigationController.navigationBar.topItem.title = @"";
    
    NSData *data = [self.record dataUsingEncoding:NSUTF8StringEncoding];
    self.urlLabelHeight = [self.url boundingRectWithSize:CGSizeMake(343, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}
                                                 context:nil].size.height;
    if (data != nil) {
        NSError *error = nil;
        self.recordDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil) {
            self.loadStatus = [self.recordDic objectForKey:@"load_status"];
            self.errLabelHeight = [[self.recordDic objectForKey:@"err_desc"] boundingRectWithSize:CGSizeMake(343, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]}
                                                                context:nil].size.height;
        }
    }
    
    [self constructViews];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    if (!self.needAnimatedControl) {
        return;
    }
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        [_toolBar.lastBaselineAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    } else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toolBar
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    }
}

- (void)constructViews {
    [self.view addSubview:self.scrollView];
    
    CGFloat topOffset = UIApplication.sharedApplication.statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topOffset);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    [self.containerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(self.view.bounds.size.width);
    }];
    
    BDImageRequestOptions options = [ImageXSettingsModel sharedSettings].options;
    [self.imageView bd_setImageWithURL:[NSURL URLWithString:self.url] placeholder:createCenteredThumbnailWithImage([UIImage imageNamed:@"Images/imageLoading"]) options:options completion:^(BDWebImageRequest * _Nullable request, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BDWebImageResultFrom from) {
        if (error == nil) {
            NSLog(@"details image load success");
        }else {
            self.imageView.image = [UIImage imageNamed:@"Images/imageFailed"];
        }
    }];
    
    [self.containerView addSubview:self.basicLabel];
    [self.basicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(16);
        make.left.equalTo(self.containerView.mas_left).offset(16);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(20);
    }];
    
    [self.containerView addSubview:self.basicTableView];
    [self.basicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.basicLabel.mas_bottom).offset(8);
        make.height.mas_equalTo([self calculateTableView0Height]);
    }];
    
    [self.containerView addSubview:self.logLabel];
    [self.logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.basicTableView.mas_bottom).offset(16);
        make.left.equalTo(self.containerView.mas_left).offset(16);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(20);
    }];
    
    [self.containerView addSubview:self.logTableView];
    [self.logTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_equalTo(54);
    }];
    
    [self.containerView addSubview:self.logInfoLabel];
    [self.logInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logTableView.mas_bottom);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        self.logInfoLabelHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logInfoLabel.mas_bottom).offset(43);
    }];
    
    if (self.needAnimatedControl) {
        [self.view addSubview:self.toolBar];
    }
}

- (CGFloat)calculateTableView0Height {
    CGFloat tableView0Height = 54 * 7 + self.urlLabelHeight;
    if (![self.loadStatus isEqualToString:@"success"]) {
        tableView0Height += (54 * 2 + self.errLabelHeight);
    }
    return tableView0Height;
}

- (void)showLogInfo {
    if (self.logInfoLabelHeightConstraint) {
        [self.logInfoLabelHeightConstraint uninstall];
    }
    if (self.logInfoLabelExpanded) {
        [self.logInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.logInfoLabelHeightConstraint = make.height.mas_equalTo(0);
        }];
    }else {
        CGFloat expandedHeight = [self.logInfoLabel.text boundingRectWithSize:CGSizeMake(self.containerView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.logInfoLabel.font} context:nil].size.height + 20;
        [self.logInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.logInfoLabelHeightConstraint = make.height.mas_equalTo(expandedHeight);
        }];
    }
    self.logInfoLabelExpanded = !self.logInfoLabelExpanded;
}

- (NSString *)fileSizeString {
    long fileSizeInBytes = [[self.recordDic objectForKey:@"file_size"] longValue];
    NSString *formattedString = @"";

    if (fileSizeInBytes < 0) {
        formattedString = @"NULL";
    }else if (fileSizeInBytes < 1024) {
        formattedString = [NSString stringWithFormat:@"%ldB", fileSizeInBytes];
    }else if (fileSizeInBytes < 1024 * 1024) {
        double fileSizeInKB = fileSizeInBytes / 1024.0;
        formattedString = [NSString stringWithFormat:@"%.3gKB", fileSizeInKB];
    }else {
        double fileSizeInMB = fileSizeInBytes / (1024.0 * 1024.0);
        formattedString = [NSString stringWithFormat:@"%.3gMB", fileSizeInMB];
    }

    return formattedString;
}

- (void)copyURL {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.url;
    [self sentAlert];
}

- (void)copyErrDesc {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.recordDic objectForKey:@"err_desc"];
    [self sentAlert];
}

- (void)copyLoadMonitor {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.record;
    [self sentAlert];
}

- (void)copyLargeImageMonitor {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.record;
    [self sentAlert];
}

- (void)sentAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"copy_done", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0 && indexPath.row == 0) {
        return 54 + self.urlLabelHeight;
    }
    if (tableView.tag == 0 && indexPath.row == 8) {
        return 54 + self.errLabelHeight;
    }
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        if ([[self.recordDic objectForKey:@"load_status"] isEqualToString:@"success"]) {
            return 7;
        }else {
            return 9;
        }
    }else if (tableView.tag == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ImageXDecodingDetails";
    ImageXDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSString *name, *content;
    // you can obtain information that you want in a image request in the completion block of a request, details in ImageXDecodingViewCongtroller.m
    if (tableView.tag == 0) {
        switch (indexPath.row) {
            case 0:
                name = NSLocalizedString(@"image_url", nil);
                content = @"copy";
                break;
            case 1:
                name = NSLocalizedString(@"load_status", nil);
                content = [self.recordDic objectForKey:@"load_status"];
                break;
            case 2:
                name = NSLocalizedString(@"image_type", nil);
                content = [self.recordDic objectForKey:@"image_type"];
                break;
            case 3:
                name = NSLocalizedString(@"file_size", nil);
                content = [self fileSizeString];
                break;
            case 4:
                name = NSLocalizedString(@"image_resolution", nil);
                content = [self.recordDic objectForKey:@"applied_image_size"];
                break;
            case 5:
                name = NSLocalizedString(@"download_duration", nil);
                long timeDownload = [[self.recordDic objectForKey:@"download_duration"] longValue];
                if (timeDownload > 0) {
                    content = [NSString stringWithFormat:@"%ld ms", timeDownload];
                }else {
                    content = @"NULL";
                }
                break;
            case 6:
                name = NSLocalizedString(@"decode_duration", nil);
                long timeDecode = [[self.recordDic objectForKey:@"decode_duration"] longValue];
                if (timeDecode > 0) {
                    content = [NSString stringWithFormat:@"%ld ms", timeDecode];
                }else {
                    content = @"NULL";
                }
                break;
            case 7:
                name = NSLocalizedString(@"err_code", nil);
                content = [[self.recordDic objectForKey:@"err_code"] stringValue];
                break;
            case 8:
                name = NSLocalizedString(@"err_description", nil);
                content = @"copy";
                break;
            default:
                name = NSLocalizedString(@"default", nil);
                content = NSLocalizedString(@"default", nil);
                break;
        }
    }else if (tableView.tag == 1) {
        switch (indexPath.row) {
            case 0:
                name = @"imagex_load_monitor";
                content = @"copy";
                break;
            case 1:
                name = @"imagex_large_image_monitor";
                content = @"copy";
                break;
            default:
                name = NSLocalizedString(@"default", nil);
                content = NSLocalizedString(@"default", nil);
                break;
        }
    }
    
    if(!cell){
        cell = [[ImageXDetailsTableViewCell alloc] initWithName:name content:content tag:indexPath.row + tableView.tag * CELL_TAG_OFFSET reuseIdentifier:cellID];
    }
    switch (cell.tag) {
        case 0: {
            cell.contentLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyURL)];
            [cell.contentLabel addGestureRecognizer:tapGesture];
            [cell.contentView addSubview:({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 42, 357, 40)];
                label.text = self.url;
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByCharWrapping;
                label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
                label.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
                label;
            })];
            break;
        }
        case 8: {
            cell.contentLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyErrDesc)];
            [cell.contentLabel addGestureRecognizer:tapGesture];
            [cell.contentView addSubview:({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 42, 357, 40)];
                label.text = [self.recordDic objectForKey:@"err_desc"];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByCharWrapping;
                label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
                label.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
                label;
            })];
            break;
        }
        case 100: {
            cell.nameLabel.userInteractionEnabled = YES;
            cell.contentLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureShow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogInfo)];
            [cell.nameLabel addGestureRecognizer:tapGestureShow];
            UITapGestureRecognizer *tapGestureCopy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLoadMonitor)];
            [cell.contentLabel addGestureRecognizer:tapGestureCopy];
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Lazy Load

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor colorWithRed:0xF4 / 255.0 green:0xF5 / 255.0 blue:0xF7 / 255.0 alpha:1.0];
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (BDImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[BDImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UILabel *)basicLabel {
    if (_basicLabel == nil) {
        _basicLabel = [[UILabel alloc] init];
        _basicLabel.text = NSLocalizedString(@"basic_info", nil);
        _basicLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _basicLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
    }
    return _basicLabel;
}

- (UITableView *)basicTableView {
    if (_basicTableView == nil) {
        _basicTableView = [[UITableView alloc] init];
        _basicTableView.delegate = self;
        _basicTableView.dataSource = self;
        _basicTableView.tag = 0;
        _basicTableView.scrollEnabled = NO;
    }
    return _basicTableView;
}

- (UILabel *)logLabel {
    if (_logLabel == nil) {
        _logLabel = [[UILabel alloc] init];
        _logLabel.text = NSLocalizedString(@"monitor_info", nil);
        _logLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _logLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
    }
    return _logLabel;
}

- (UITableView *)logTableView {
    if (_logTableView == nil) {
        _logTableView = [[UITableView alloc] init];
        _logTableView.delegate = self;
        _logTableView.dataSource = self;
        _logTableView.tag = 1;
        _logTableView.scrollEnabled = NO;
    }
    return _logTableView;
}

- (UILabel *)logInfoLabel {
    if (_logInfoLabel == nil) {
        _logInfoLabel = [[UILabel alloc] init];
        NSArray *lines = [self.record componentsSeparatedByString:@"\n"];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
        [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
            NSString *lineNumber = [NSString stringWithFormat:@"%2d: ", (int)(idx + 1)];
            NSString *lineWithNumber = [lineNumber stringByAppendingString:line];
            if (idx != 0) {
                [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:lineWithNumber]];
        }];
        _logInfoLabel.attributedText = attributedText;
        _logInfoLabel.font = [UIFont fontWithName:@"Menlo" size:12];
        _logInfoLabel.backgroundColor = [UIColor colorWithRed:0x1E / 255.0 green:0x25 / 255.0 blue:0x2E / 255.0 alpha:1.0];
        _logInfoLabel.textColor = [UIColor whiteColor];
        _logInfoLabel.numberOfLines = 0;
    }
    return _logInfoLabel;
}

- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] init];
        UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"play", nil) style:UIBarButtonItemStylePlain target:self action:@selector(playAnimatedImage)];
        UIBarButtonItem *pauseItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"pause", nil) style:UIBarButtonItemStylePlain target:self action:@selector(pauseAnimatedImage)];
        UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"stop", nil) style:UIBarButtonItemStylePlain target:self action:@selector(stopAnimatedImage)];
        UIBarButtonItem *infinityLoopItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"infinity_loop", nil) style:UIBarButtonItemStylePlain target:self action:@selector(infinityLoopAnimatedImage)];
        UIBarButtonItem *customLoopItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"custom_loop", nil) style:UIBarButtonItemStylePlain target:self action:@selector(customLoopAnimatedImage)];
        [_toolBar setItems:@[playItem, pauseItem, stopItem, infinityLoopItem, customLoopItem] animated:YES];
        [[UIToolbar appearance] setBackgroundImage:[UIImage bd_imageWithColor:[UIColor whiteColor]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    }
    return _toolBar;
}

#pragma mark - Animated Image Control

// Animated Image Playback Control Function
- (void)playAnimatedImage {
    if ([self.imageView.player isPlaying]) {
        return;
    }
    [self.imageView.player startPlay];
}

- (void)pauseAnimatedImage {
    if (![self.imageView.player isPlaying]) {
        return;
    }
    [self.imageView.player pause];
}

- (void)stopAnimatedImage {
    if (![self.imageView.player isPlaying]) {
        return;
    }
    [self.imageView.player stopPlay];
}

- (void)infinityLoopAnimatedImage {
    self.imageView.customLoop = 0;
    self.imageView.infinityLoop = YES;
    [self playAnimatedImage];
}

- (void)customLoopAnimatedImage {
    [self stopAnimatedImage];
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"custom_loop_count", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"set_custom_loop", nil);
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = 1;
        textField.delegate = self;
    }];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UITextField *textField = alertController.textFields.firstObject;
        strongSelf.imageView.customLoop = [textField.text intValue];
        [strongSelf playAnimatedImage];
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filteredString];
    }
    return YES;
}

@end
