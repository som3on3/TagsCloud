//
//  XTagsCloud.h
//  Tags Cloud
//
//  Created by Bogdan Adam on 1/27/13.
//  Copyright (c) 2013 Bogdan Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTagsCloud : UIScrollView <UIScrollViewDelegate, UITextFieldDelegate>

- (IBAction)addTag:(id)sender;
- (NSArray *)tags;
- (void)setTags:(NSArray *)list;

@property (strong, nonatomic) IBOutlet UITextField *tagsField;
@property (strong, nonatomic) IBOutlet UIView *textBar;
@property (weak) id aDelegate;

@end
