//
//  UIVew+LGExtension.m
//  LGCalender
//
//  Created by jamy on 15/6/24.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "UIVew+LGExtension.h"

@implementation UIView (LGExtension)

- (CGFloat)myTop
{
    return CGRectGetMinY(self.frame);
}

- (void)setMyTop:(CGFloat)myTop
{
    self.frame = CGRectMake(self.myLeft, myTop, self.myWidth, self.myHeight);
}

- (CGFloat)myBottom
{
    return CGRectGetMaxY(self.frame);
}

-(void)setMyBottom:(CGFloat)myBottom
{
    self.myTop = myBottom - self.myHeight;
}

- (CGFloat)myLeft
{
    return CGRectGetMinX(self.frame);
}

- (void)setMyLeft:(CGFloat)myLeft
{
    self.frame = CGRectMake(myLeft, self.myTop, self.myWidth, self.myHeight);
}

- (CGFloat)myRight
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMyRight:(CGFloat)myRight
{
    self.myLeft = myRight - self.myWidth;
}

- (CGFloat)myHeight
{
    return CGRectGetHeight(self.frame);
}

- (void)setMyHeight:(CGFloat)myHeight
{
    self.frame = CGRectMake(self.myLeft, self.myTop, self.myWidth, myHeight);
}

- (CGFloat)myWidth
{
    return CGRectGetWidth(self.frame);
}

- (void)setMyWidth:(CGFloat)myWidth
{
    self.frame = CGRectMake(self.myLeft, self.myTop, myWidth, self.myHeight);
}

@end
