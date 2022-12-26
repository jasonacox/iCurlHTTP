//
//  iCHSegmentedOverride.h
//  iCurlHTTP
//
//  Created by Jason Cox on 12/31/19.
//  Copyright © 2019 Jason Cox. All rights reserved.

// Use iOS 12 Style Segemented Control Style
@interface UISegmentedControl (Common)
//- (void)ensureiOS12Style;
- (void)bluetextColor;
@end


@implementation UISegmentedControl (Common)
/*
- (void)ensureiOS12Style {
    // UISegmentedControl has changed in iOS 13 and setting the tint
    // color now has no effect.
    if (@available(iOS 13, *)) {
        UIColor *tintColor = [self tintColor];
        UIImage *tintColorImage = [self imageWithColor:tintColor];
        // Must set the background image for normal to something (even clear) else the rest won't work
        [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor, NSFontAttributeName: [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
        [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [tintColor CGColor];
    }
}
*/
- (void)bluetextColor {
    // UISegmentedControl has changed in iOS 13 and setting the tint
    // color now has no effect.
    if (@available(iOS 13, *)) {
        UIColor *tintColor = [self tintColor];
        UIColor *selectColor = [UIColor blackColor];
        // use tintColor for unselected text
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor, NSFontAttributeName: [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        // use black for selected text
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: selectColor, NSFontAttributeName: [UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    }
}
/*
- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
*/
@end
