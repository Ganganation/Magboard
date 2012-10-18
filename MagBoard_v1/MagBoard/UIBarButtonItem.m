//
//  UIBarButtonItem.m
//  MagBoard
//
//  Created by Dennis de Jong on 17-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "UIBarButtonItem.h"
#import "UIButton.h"

@implementation UIBarButtonItem (StyledButton)

+ (UIBarButtonItem *)styledBackBarButtonItemWithTarget:(id)target selector:(SEL)selector;
{
    UIImage *image = [UIImage imageNamed:@"back_button_top"];
    //image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
    
    NSString *title = NSLocalizedString(@"", nil);
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
    button.titleLabel.textColor = [UIColor blackColor];
    
    CGSize textSize = [title sizeWithFont:font];
    CGFloat margin = (button.frame.size.height - textSize.height) / 2;
    CGFloat marginRight = 7.0f;
    CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginLeft, margin, marginRight)];
    [button setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:77.0f/255.0f blue:99.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledCancelBarButtonItemWithTarget:(id)target selector:(SEL)selector;
{
    UIImage *image = [UIImage imageNamed:@"button_square"];
    image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
    
    NSString *title = NSLocalizedString(@"Cancel", nil);
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:77.0f/255.0f blue:99.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledSubmitBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
{
    UIImage *image = [UIImage imageNamed:@"button_submit"];
    image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end