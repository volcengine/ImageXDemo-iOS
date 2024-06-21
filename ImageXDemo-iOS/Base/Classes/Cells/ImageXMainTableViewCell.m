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
//  ImageXMainTableViewCell.m
//  Base
//
//  Created by ByteDance on 2024/2/28.
//

#import "ImageXMainTableViewCell.h"
#import "ImageXMainModel.h"

@implementation ImageXMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithTag:(NSInteger)tag row:(NSInteger)row reuseIdentifier:(NSString *)cellID {
    self = [[ImageXMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (self) {
        [self constructViews:tag row:row];
    }
    return self;
}

- (void)constructViews:(NSInteger)tag row:(NSInteger)row {
    [self addSubview:({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithRed:0x11 / 255.0 green:0x12 / 255.0 blue:0x14 / 255.0 alpha:1.0];
        titleLabel.text = ImageXMainModel.tableViewData[tag][row][@"name"];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        CGFloat titleLabelWidth = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width + 3;
        titleLabel.frame = CGRectMake(56, 22, titleLabelWidth, 28);
        titleLabel;
    })];
    [self addSubview:({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ImageXMainModel.tableViewData[tag][row][@"imagePath"]]];
        imageView.frame = CGRectMake(16, 23, 28, 28);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView;
    })];
    [self addSubview:({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/rightArrow"]];
        imageView.frame = CGRectMake(330, 27, 16, 16);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView;
    })];
}

@end
