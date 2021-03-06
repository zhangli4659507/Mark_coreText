//
//  MDisplayView.m
//  Mark_CoreText
//
//  Created by Mark on 2016/12/9.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "MDisplayView.h"
#import <CoreText/CoreText.h>
#import "SDWebImageDownloader.h"

@interface MDisplayView ()<UIGestureRecognizerDelegate>

@end

@implementation MDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        [self addTapEvevt];
    }
    return  self;
}

- (void)addTapEvevt {

    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate  = self;
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
   for (MImaJsonModel *imaModel in _config.imaModelList) {
       CGRect imaRect = imaModel.imgRect;
       CGPoint imagePosition = imaRect.origin;
//       因为底层坐标是反的 所以需要转换
       imagePosition.y = self.bounds.size.height - imaRect.origin.y - imaRect.size.height;
       CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imaRect.size.width, imaRect.size.height);
       if (CGRectContainsPoint(rect, point)) {
           NSLog(@"点击了图片");
       }
    }
    
    
    MLinkJsonModel *linkModel = [_config touchLinkInview:self atPoint:point];
    if (linkModel) {
        NSLog(@"点击了链接");
    }
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//获取当前绘制上下文
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵为不做图形变换
    CGContextTranslateCTM(context, 0, self.bounds.size.height);//平移方法，将画布向上平移一个屏幕高
    CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    
    [self drawImaRect];//绘制图片
    
    if (_config.frameRef) {
            CTFrameDraw(_config.frameRef, context);
    }
    // Drawing code
}

- (void)drawImaRect {

    for (MImaJsonModel *imaModel in _config.imaModelList) {
        CGFloat wid = CGRectGetWidth(self.bounds) - 20;
        imaModel.imgRect = CGRectMake(imaModel.imgRect.origin.x + 10, imaModel.imgRect.origin.y,wid , wid*imaModel.imaScale);
        [imaModel drawRectWithDisplaySuperView:self];
    }
}


@end
