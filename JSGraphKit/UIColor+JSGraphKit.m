//
//  UIColor+JSGraphKit.m
//  Example
//
//  Created by John Setting on 3/6/15.
//  Copyright (c) 2015 John Setting. All rights reserved.
//


#import "UIColor+JSGraphKit.h"

@implementation UIColor (JSGraphKit)

+ (UIColor *)js_turquoiseColor {
    return [UIColor js_colorFromHexCode:@"1ABC9C"];
}

+ (UIColor *)js_greenSeaColor {
    return [UIColor js_colorFromHexCode:@"16A085"];
}

+ (UIColor *)js_emerlandColor {
    return [UIColor js_colorFromHexCode:@"2ECC71"];
}

+ (UIColor *)js_nephritisColor {
    return [UIColor js_colorFromHexCode:@"27AE60"];
}

+ (UIColor *)js_peterRiverColor {
    return [UIColor js_colorFromHexCode:@"3498DB"];
}

+ (UIColor *)js_belizeHoleColor {
    return [UIColor js_colorFromHexCode:@"2980B9"];
}

+ (UIColor *)js_amethystColor {
    return [UIColor js_colorFromHexCode:@"9B59B6"];
}

+ (UIColor *)js_wisteriaColor {
    return [UIColor js_colorFromHexCode:@"8E44AD"];
}

+ (UIColor *)js_wetAsphaltColor {
    return [UIColor js_colorFromHexCode:@"34495E"];
}

+ (UIColor *)js_midnightBlueColor {
    return [UIColor js_colorFromHexCode:@"2C3E50"];
}

+ (UIColor *)js_sunflowerColor {
    return [UIColor js_colorFromHexCode:@"F1C40F"];
}

+ (UIColor *)js_orangeColor {
    return [UIColor js_colorFromHexCode:@"F39C12"];
}

+ (UIColor *)js_carrotColor {
    return [UIColor js_colorFromHexCode:@"E67E22"];
}

+ (UIColor *)js_pumpkinColor {
    return [UIColor js_colorFromHexCode:@"D35400"];
}

+ (UIColor *)js_alizarinColor {
    return [UIColor js_colorFromHexCode:@"E74C3C"];
}

+ (UIColor *)js_pomegranateColor {
    return [UIColor js_colorFromHexCode:@"C0392B"];
}

+ (UIColor *)js_cloudsColor {
    return [UIColor js_colorFromHexCode:@"ECF0F1"];
}

+ (UIColor *)js_silverColor {
    return [UIColor js_colorFromHexCode:@"BDC3C7"];
}

+ (UIColor *)js_concreteColor {
    return [UIColor js_colorFromHexCode:@"95A5A6"];
}

+ (UIColor *)js_asbestosColor {
    return [UIColor js_colorFromHexCode:@"7F8C8D"];
}

+ (UIColor *)js_colorFromHexCode:(NSString *)hex {
    
    /*
     source: http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
     */
    
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
