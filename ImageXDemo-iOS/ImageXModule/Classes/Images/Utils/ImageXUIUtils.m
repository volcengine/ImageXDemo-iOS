//
//  ImageXUIUtils.m
//  ImageXModule
//
//  Created by ByteDance on 2024/6/11.
//

#import <Foundation/Foundation.h>

UIImage * imageFromColor(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage * createCenteredThumbnailWithImage(UIImage *originalImage) {
    CGSize newSize = CGSizeMake(150, 150);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    [[UIColor colorWithRed:0xF6 / 255.0 green:0xF8 / 255.0 blue:0xFA / 255.0 alpha:1.0] setFill];
    UIRectFill(CGRectMake(0, 0, newSize.width, newSize.height));
    
    CGRect thumbnailRect = CGRectMake((newSize.width - originalImage.size.width) / 2.0,
                                      (newSize.height - originalImage.size.height) / 2.0,
                                      originalImage.size.width,
                                      originalImage.size.height);
    [originalImage drawInRect:thumbnailRect];
    UIImage *centeredThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return centeredThumbnail;
}

NSArray<UIButton *> * createButtonsFromArray(NSArray<NSString *> *types) {
    NSMutableArray *buttons = [NSMutableArray array];
    int index = 0;
    for (NSString *imageType in types) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = index++;
        button.layer.cornerRadius = 10.0;
        button.clipsToBounds = true;
        [button setTitle:imageType forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [button setTitleColor:[UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [button setBackgroundImage:imageFromColor([UIColor colorWithRed:0xF4 / 255.0 green:0xF5 / 255.0 blue:0xF7 / 255.0 alpha:1.0]) forState:UIControlStateNormal];
        [button setBackgroundImage:imageFromColor([UIColor whiteColor]) forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(clickType:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        
        [buttons addObject:button];
    }
    return buttons;
}


