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
//  ImagexXLogInViewController.m
//  Base
//
//  Created by ByteDance on 2024/2/21.
//

#import "ImageXLogInViewController.h"
#import "ImageXMainViewController.h"
#import <Masonry/Masonry.h>
#import <TTSDK/BDWebImageToB.h>
#import <TTSDK/TTSDKManager.h>
#import <RangersAppLog/BDAutoTrack.h>

@interface ImageXLogInViewController () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL hasRead;

@property (nonatomic, strong) UIImageView *enter1;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UILabel *powerdLabel;

@end

@implementation ImageXLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/LoginBG"]];
    backgroundImage.frame = self.view.bounds;
    [self.view insertSubview:backgroundImage atIndex:0];
    
    [self constructSubviews];
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

- (void)constructSubviews {
    [self.view addSubview:self.enter1];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.circleButton];
    [self.view addSubview:self.readLabel];
    [self.view addSubview:self.privacyLabel];
    [self.view addSubview:self.powerdLabel];
    
    CGFloat topOffset = UIApplication.sharedApplication.statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(291);
        make.top.equalTo(self.view).offset(topOffset + 120);
        make.height.mas_equalTo(34);
    }];
    [self.enter1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1.mas_left);
        make.width.mas_equalTo(60);
        make.bottom.equalTo(self.label1.mas_top).offset(-20);
        make.height.mas_equalTo(60);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(291);
        make.top.equalTo(self.label1.mas_bottom);
        make.height.mas_equalTo(34);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(291);
        make.top.equalTo(self.label2.mas_bottom).offset(40);
        make.height.mas_equalTo(45);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(291);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.height.mas_equalTo(45);
    }];
    [self.circleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
        make.left.equalTo(self.loginButton.mas_left).offset(45);
    }];
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleButton.mas_centerY);
        make.left.equalTo(self.circleButton.mas_right).offset(6);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(85);
    }];
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleButton.mas_centerY);
        make.left.equalTo(self.readLabel.mas_right).offset(3);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    CGFloat powerdLabelWidth = [self.powerdLabel.text sizeWithAttributes:@{NSFontAttributeName:self.powerdLabel.font}].width + 3;
    [self.powerdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.privacyLabel.mas_bottom).offset(308);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(powerdLabelWidth);
    }];
}

- (void)logInWithAppID {
    if (self.textField.text.length == 0) {
        [self sendAlert:NSLocalizedString(@"alert_appID_null", nil)];
        return;
    }
    if (!self.hasRead) {
        [self sendAlert:NSLocalizedString(@"alert_read_privacy_policy", nil)];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.textField.text forKey:@"kImageXAppID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // init applog
    BDAutoTrackConfig *config = [BDAutoTrackConfig configWithAppID:self.textField.text
                                                     launchOptions:nil];
    config.channel = @"App Store";
    config.appName = @"dp_tob_sdk_test2";
    config.showDebugLog = YES;
    config.logger = ^(NSString * _Nullable log) {
        NSLog(@"applog -- %@", log);
    };
    config.logNeedEncrypt = NO;
    [BDAutoTrack startTrackWithConfig:config];
    
    // init TTSDK Image
    TTSDKImagexConfiguration *imagexConfig = [TTSDKImagexConfiguration defaultImagexConfig];
//    imagexConfig.token = @"xxx";
//    imagexConfig.authCodes = @[
//        @"xxx",
//        @"xxx"
//    ];
    TTSDKConfiguration *TTSDKConfig = [TTSDKConfiguration defaultConfigurationWithAppID:self.textField.text];
    TTSDKConfig.imagexConfiguration = imagexConfig;
    TTSDKConfig.bizType = TTSDKServiceBizType_Image;
    TTSDKConfig.shouldInitAppLog = NO;
    if (imagexConfig.token.length == 0 || imagexConfig.authCodes.count == 0) {
        [self sendAlert:NSLocalizedString(@"alert_token_authcodes_empty", nil)];
        return;
    }
    [TTSDKManager startWithConfiguration:TTSDKConfig];
    [BDWebImageManager sharedManager].isCustomSequenceHeicsDecoderFirst = YES;
    [BDWebImageManager sharedManager].isSystemHeicDecoderFirst = NO;
    
    ImageXMainViewController *vc = [[ImageXMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendAlert:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)read {
    if (self.hasRead) {
        self.hasRead = NO;
        [self.circleButton setImage:[UIImage imageNamed:@"Images/circle"] forState:UIControlStateNormal];
    }else {
        self.hasRead = YES;
        [self.circleButton setImage:[UIImage imageNamed:@"Images/circleChoosed"] forState:UIControlStateNormal];
    }
}

- (void)labelTapped:(UITapGestureRecognizer *)gesture {
    NSURL *url = [NSURL URLWithString:@"https://www.volcengine.com/docs/508/110611"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filteredString = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filteredString];
}

#pragma mark - Lazy Load

- (UIImageView *)enter1 {
    if (_enter1 == nil) {
        _enter1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/Enter1"]];
        _enter1.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _enter1;
}

- (UILabel *)label1 {
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] init];
        _label1.text = NSLocalizedString(@"title_welcome", nil);
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:27];
        _label1.textColor = [UIColor colorWithRed:0x0C / 255.0 green:0x0D / 255.0 blue:0x0E / 255.0 alpha:1.0];
        if ([[[NSLocale currentLocale] languageCode] isEqualToString:@"en"]) {
            _label1.adjustsFontSizeToFitWidth = YES;
            _label1.minimumScaleFactor = 0.5;
        }
    }
    return _label1;
}

- (UILabel *)label2 {
    if (_label2 == nil) {
        _label2 = [[UILabel alloc] init];
        _label2.text = NSLocalizedString(@"title_bytedance", nil);
        _label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _label2.textColor = [UIColor colorWithRed:0x73 / 255.0 green:0x7A / 255.0 blue:0x87 / 255.0 alpha:1.0];
    }
    return _label2;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"hint_appID", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0x80 / 255.0 green:0x83 / 255.0 blue:0x8A / 255.0 alpha:1.0]}];
        _textField.layer.cornerRadius = 6.0;
        _textField.textColor = [UIColor grayColor];
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textField.backgroundColor = [UIColor colorWithRed:0xF5 / 255.0 green:0xF8 / 255.0 blue:0xFD / 255.0 alpha:1.0];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.layer.cornerRadius = 6.0;
        [_loginButton addTarget:self action:@selector(logInWithAppID) forControlEvents:UIControlEventTouchUpInside];
        CAGradientLayer *graLayer = [CAGradientLayer layer];
        graLayer.frame = CGRectMake(0, 0, 291, 45);
        [graLayer setColors:@[(id)[[UIColor colorWithRed:0x00 / 255.0 green:0x6E / 255.0 blue:0xFF / 255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0x00 / 255.0 green:0xA3 / 255.0 blue:0xFF / 255.0 alpha:1.0] CGColor]]];
        graLayer.startPoint = CGPointMake(0, 0);
        graLayer.endPoint = CGPointMake(1, 0);
        graLayer.locations = @[@(0.67),@(1.0)];
        graLayer.cornerRadius = 6.0;
        [self.loginButton.layer addSublayer:graLayer];
        [_loginButton setTitle:NSLocalizedString(@"button_login", nil) forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Bold" size:15]];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UIButton *)circleButton {
    if (_circleButton == nil) {
        _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circleButton setImage:[UIImage imageNamed:@"Images/circle"] forState:UIControlStateNormal];
        [_circleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_circleButton addTarget:self action:@selector(read) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleButton;
}

- (UILabel *)readLabel {
    if (_readLabel == nil) {
        _readLabel = [[UILabel alloc] init];
        _readLabel.text = NSLocalizedString(@"label_agree", nil);
        _readLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _readLabel.textColor = [UIColor colorWithRed:0x42 / 255.0 green:0x46 / 255.0 blue:0x4E / 255.0 alpha:1.0];
        _readLabel.adjustsFontSizeToFitWidth = YES;
        _readLabel.minimumScaleFactor = 0.5;
    }
    return _readLabel;
}

- (UILabel *)privacyLabel {
    if (_privacyLabel == nil) {
        _privacyLabel = [[UILabel alloc] init];
        _privacyLabel.userInteractionEnabled = YES;
        _privacyLabel.text = NSLocalizedString(@"label_policy", nil);
        _privacyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _privacyLabel.textColor = [UIColor colorWithRed:0x73 / 255.0 green:0x7A / 255.0 blue:0x87 / 255.0 alpha:1.0];
        _privacyLabel.adjustsFontSizeToFitWidth = YES;
        _privacyLabel.minimumScaleFactor = 0.5;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_privacyLabel.text];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attributedString.length)];
        _privacyLabel.attributedText = attributedString;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_privacyLabel addGestureRecognizer:tapGesture];
    }
    return _privacyLabel;
}

- (UILabel *)powerdLabel {
    if (_powerdLabel == nil) {
        _powerdLabel = [[UILabel alloc] init];
        _powerdLabel.text = NSLocalizedString(@"label_volcengine", nil);
        _powerdLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _powerdLabel.textColor = [UIColor colorWithRed:0x4E / 255.0 green:0x59 / 255.0 blue:0x69 / 255.0 alpha:1.0];
    }
    return _powerdLabel;
}

@end

