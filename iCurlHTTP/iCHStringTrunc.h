//
//  iCHStringTrunc.h
//  iCurlHTTP
//
//  Created by Jason Cox on 12/31/19.
//  Copyright © 2019 Jason Cox. All rights reserved.
//

#ifndef iCHStringTrunc_h
#define iCHStringTrunc_h


// Extend NSString to add truncation power
@interface NSString (TFDString)

//- (NSString *)truncateByWordWithLimit:(NSInteger)limit;
- (NSString *)stringByTruncatingString: (NSString *)string toWidth: (CGFloat)width withFont: (UIFont *)font;

@end


@implementation NSString (TFDString)

//- (NSString *)truncateByWordWithLimit:(NSInteger)limit {
//    NSRange r = NSMakeRange(0, self.length);
//    while (r.length > limit) {
//        NSRange r0 = [self rangeOfString:@" " options:NSBackwardsSearch range:r];
//        if (!r0.length) break;
//        r = NSMakeRange(0, r0.location);
//    }
//    if (r.length == self.length) return self;
//    return [[self substringWithRange:r] stringByAppendingString:@"..."];
//}


// function to truncate string with ellipsis (...) based on specified width
- (NSString *)stringByTruncatingString: (NSString *)string toWidth: (CGFloat)width withFont: (UIFont *)font
{
#define ellipsis @"..."
    NSMutableString *truncatedString = [string mutableCopy];
    
    if ([string sizeWithAttributes: @{NSFontAttributeName: font}].width > width) {
        width -= [ellipsis sizeWithAttributes: @{NSFontAttributeName: font}].width;
        
        NSRange range = {truncatedString.length - 1, 1};
        
        while ([truncatedString sizeWithAttributes: @{NSFontAttributeName: font}].width > width) {
            [truncatedString deleteCharactersInRange:range];
            range.location--;
        }
        
        [truncatedString replaceCharactersInRange:range withString:ellipsis];
    }
    
    return truncatedString;
}

@end


#endif /* iCHStringTrunc_h */
