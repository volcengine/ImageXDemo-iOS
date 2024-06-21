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
//  ImageXDetailsTableViewCell.m
//  ImageXModule
//
//  Created by ByteDance on 2024/4/11.
//

#import "ImageXDetailsTableViewCell.h"
#import <Masonry/Masonry.h>

@interface ImageXDetailsTableViewCell ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@end

@implementation ImageXDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithName:(NSString *)name content:(NSString *)content tag:(NSUInteger)tag reuseIdentifier:(NSString *)cellID {
    self = [[ImageXDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (self) {
        self.name = name;
        self.content = content;
        self.tag = tag;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self constructViews];
    }
    return self;
}

- (void)constructViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    
    CGFloat nameLabelWidth = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}].width + 3;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(nameLabelWidth);
    }];
    
    CGFloat contentLabelWidth = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:self.contentLabel.font}].width + 3;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(contentLabelWidth);
    }];
}

#pragma mark - Lazy Load

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = self.name;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _nameLabel.textColor = [UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        if ([self.content isEqualToString:@"copy"]) {
            _contentLabel.text = NSLocalizedString(@"copy", nil);
            _contentLabel.textColor = [UIColor colorWithRed:0x16 / 255.0 green:0x5D / 255.0 blue:0xFF / 255.0 alpha:1.0];
        }else {
            _contentLabel.text = self.content;
            _contentLabel.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
        }
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _contentLabel;
}

@end
