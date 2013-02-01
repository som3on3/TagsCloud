//
//  XTagsCloud.m
//  Tags Cloud
//
//  Created by Bogdan Adam on 1/27/13.
//  Copyright (c) 2013 Bogdan Adam. All rights reserved.
//

#import "XTagsCloud.h"
#include <stdlib.h>

#define MINSIZE 12
#define MAXSIZE 18
#define SEPARATOR 10.0
#define DEFCOLOR [UIColor blackColor]
#define SELCOLOR [UIColor redColor]

@interface XTagsCloud() {
    BOOL keyboardShown;
    CGPoint lastPoint;
}

@property (strong, nonatomic) NSMutableArray *my_tags;
@property (strong, nonatomic) NSMutableArray *selectedTags;

@end

@implementation XTagsCloud

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildDefaults];
    }
    return self;
}

- (void)buildDefaults {
    self.my_tags = [[NSMutableArray alloc] init];
    self.selectedTags = [[NSMutableArray alloc] init];
    
    keyboardShown = NO;
    lastPoint = CGPointMake(0.0, 0.0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self addTag:nil];
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    if (!keyboardShown) {
        NSDictionary *info = [aNotification userInfo];
        
        NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = self.frame;
        CGRect kbFrame = self.textBar.frame;
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
            //frame.origin.y -= keyboardSize.height-50;
            frame.size.height -= keyboardSize.height;
            
            kbFrame.origin.y -= keyboardSize.height;
        } else {
            //frame.origin.y -= keyboardSize.width-50;
            frame.size.height -= keyboardSize.width;
            
            kbFrame.origin.y -= keyboardSize.width;
        }
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = frame;
        self.textBar.frame = kbFrame;
        [UIView commitAnimations];
        
        keyboardShown = YES;
    }
}

- (void)keyboardWasHidden:(NSNotification *)aNotification {
    if (keyboardShown) {
        NSDictionary *info = [aNotification userInfo];
        NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        CGRect kbFrame = self.textBar.frame;
        
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = self.frame;
        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
            frame.size.height += keyboardSize.height;
            
            kbFrame.origin.y += keyboardSize.height;
        } else {
            //frame.origin.y += keyboardSize.width-50;
            frame.size.height += keyboardSize.width;
            
            kbFrame.origin.y += keyboardSize.width;
        }
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame = frame;
        self.textBar.frame = kbFrame;
        [UIView commitAnimations];
        
        keyboardShown = NO;
    }
}

- (CGSize)getSizeOfText:(NSString *)text withFont:(UIFont *)font {
    return [text sizeWithFont: font constrainedToSize:CGSizeMake(self.frame.size.width, 40)];
}

- (void)addTag:(id)sender {
    NSString *tagText = [[self.tagsField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tagText.length == 0) {
        return;
    }
    
    [self.tagsField setText:@""];
    
    if ([self.my_tags containsObject:tagText]) {
        return;
    }
    
    [self.my_tags addObject:tagText];
    
    int fsize = (int)(arc4random()%(MAXSIZE-MINSIZE))+MINSIZE;
    float rsize = (float)fsize;
    
    UIFont *f = [UIFont systemFontOfSize:rsize];
    
    tagText = [NSString stringWithFormat:@"#%@", tagText];
    
    CGSize s = [self getSizeOfText:tagText withFont:f];
    
    
    CGRect theFrame = CGRectMake(lastPoint.x,
                                 lastPoint.y + MAXSIZE + 10.0 - s.height,
                                 floor(s.width),
                                 s.height);
    
    UIButton *nextTag = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextTag setFrame:theFrame];
    [nextTag setTitle:tagText forState:UIControlStateNormal];
    [nextTag setTitleColor:DEFCOLOR forState:UIControlStateNormal];
    [nextTag setTitleColor:SELCOLOR forState:UIControlStateSelected];
    [nextTag.titleLabel setFont:f];
    
    [self addSubview:nextTag];
    
    [nextTag addTarget:self action:@selector(choosedTag:) forControlEvents:UIControlEventTouchUpInside];
    
    lastPoint.x += s.width;
    lastPoint.x += SEPARATOR;
    
    if (lastPoint.x > self.frame.size.width) {
        lastPoint.x = 0.0;
        lastPoint.y += MAXSIZE + SEPARATOR;
        
        theFrame = CGRectMake(lastPoint.x,
                              lastPoint.y + MAXSIZE + 10.0 - s.height,
                              floor(s.width),
                              s.height);
        [nextTag setFrame:theFrame];
        
        lastPoint.x += s.width;
        lastPoint.x += SEPARATOR;
    }
    
    CGRect newFrame = nextTag.frame;
    newFrame.origin.y -= nextTag.titleLabel.font.descender;
    nextTag.frame = newFrame;
    
    CGSize cSize = self.contentSize;
    if (cSize.height == 0.0) {
        cSize = self.frame.size;
    }
    if (lastPoint.y + MAXSIZE + SEPARATOR > cSize.height) {
        cSize.height += MAXSIZE + SEPARATOR;
        cSize.width = self.frame.size.width;
        
        [self setContentSize:cSize];
        
        [self scrollRectToVisible:CGRectMake(10.0, cSize.height - 5.0, 1.0, 1.0) animated:YES];
    }
    
    [self addSubview:nextTag];
}

- (void)choosedTag:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (btn.isSelected) {
        [self.selectedTags removeObject:[btn.titleLabel.text substringFromIndex:1]];
    } else {
        [self.selectedTags addObject:[btn.titleLabel.text substringFromIndex:1]];
    }
    
    [btn setSelected:!btn.isSelected];
}

- (NSArray *)tags {
    return [NSArray arrayWithArray:self.selectedTags];
}

- (void)setTags:(NSArray *)list {
    for (NSString *tag in list) {
        [self.tagsField setText:tag];
        [self addTag:nil];
        [self.tagsField setText:@""];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
