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
//  ImageXSettingsTableViewCell.m
//  ImageXModule
//
//  Created by ByteDance on 2024/2/29.
//

#import "ImageXSettingsTableViewCell.h"
#import "ImageXSettingsModel.h"
#import "BDImageCache.h"
#import <Masonry/Masonry.h>

#define CELL_TAG_OFFSET 100

@interface ImageXSettingsTableViewCell () <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger tvTag;
@property (nonatomic, assign) NSInteger tvRow;
@property (nonatomic, assign) ImageXSettingType type;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *additionLabel;

@end

@implementation ImageXSettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithTag:(NSInteger)tag row:(NSInteger)row reuseIdentifier:(NSString *)cellID type:(ImageXSettingType)type {
    self = [[ImageXSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (self) {
        self.tvTag = tag;
        self.tvRow = row;
        self.type = type;
        self.tag = tag * CELL_TAG_OFFSET + row;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self constructViews];
    }
    return self;
}

- (void)constructViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.additionLabel];
    [self.contentView addSubview:self.select];
    
    CGFloat nameLabelWidth = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}].width + 3;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.width.mas_equalTo(nameLabelWidth);
        make.height.mas_equalTo(22);
    }];
    
    if (self.type == ImageXSettingActionType) {
        CGFloat rightLabelWidth = [self.rightLabel.text sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}].width + 3;
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.contentView.mas_top).offset(17);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(rightLabelWidth);
        }];
    }else if (self.type == ImageXSettingSelectType) {
        self.select.hidden = NO;
        [self.select mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    CGFloat additionLabelWidth = [self.additionLabel.text sizeWithAttributes:@{NSFontAttributeName:self.additionLabel.font}].width + 3;
    [self.additionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLabel.mas_left).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(additionLabelWidth);
    }];
}

#pragma mark - Lazy Load

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = ImageXSettingsModel.tableViewData[self.tvTag][self.tvRow][@"name"];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _nameLabel.textColor = [UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0];
    }
    return _nameLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = ImageXSettingsModel.tableViewData[self.tvTag][self.tvRow][@"rightLabel"];
        _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        if (self.tvTag == 0) {
            _rightLabel.textColor = [UIColor colorWithRed:0x16 / 255.0 green:0x64 / 255.0 blue:0xFF / 255.0 alpha:1.0];
        }else if (self.tvTag == 1) {
            _rightLabel.textColor = [UIColor colorWithRed:0xE6 / 255.0 green:0x3F / 255.0 blue:0x3F / 255.0 alpha:1.0];
        }
    }
    return _rightLabel;
}

- (UILabel *)additionLabel {
    if (_additionLabel == nil) {
        _additionLabel = [[UILabel alloc] init];
        _additionLabel.text = @"";
        if ([ImageXSettingsModel.tableViewData[self.tvTag][self.tvRow][@"name"] isEqualToString:NSLocalizedString(@"settings_appid", nil)]) {
            _additionLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"kImageXAppID"];
        }
        if ([ImageXSettingsModel.tableViewData[self.tvTag][self.tvRow][@"name"] isEqualToString:NSLocalizedString(@"settings_disk_cache", nil)]) {
            _additionLabel.text = [NSString stringWithFormat:@"%.2f MB", (CGFloat)[[BDImageCache sharedImageCache] totalDiskSize] / 1024 / 1024];
        }
        _additionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _additionLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
    }
    return _additionLabel;
}

- (UISwitch *)select {
    if (_select == nil) {
        _select = [UISwitch new];
        _select.hidden = YES;
        _select.onTintColor = [UIColor blueColor];
        [_select addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.tag == 102) {
            _select.on = [ImageXSettingsModel sharedSettings].options & BDImageRequestIgnoreDiskCache;
        }else if (self.tag == 103) {
            _select.on = [ImageXSettingsModel sharedSettings].options & BDImageRequestIgnoreMemoryCache;
        }
    }
    return _select;
}

- (void)switchAction:(UISwitch *)sender {
    // set the Ignore cache options
    if (self.tag == 102) {
        [ImageXSettingsModel sharedSettings].options ^= BDImageRequestIgnoreDiskCache;
    }else if (self.tag == 103) {
        [ImageXSettingsModel sharedSettings].options ^= BDImageRequestIgnoreMemoryCache;
    }
}

@end
