//
//  ViewController.h
//  Tags Cloud
//
//  Created by Bogdan Adam on 1/27/13.
//  Copyright (c) 2013 Bogdan Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTagsCloud;

@interface ViewController : UIViewController

- (IBAction)listSelected:(id)sender;

@property (strong, nonatomic) IBOutlet XTagsCloud *tgc;
@property (weak, nonatomic) IBOutlet UILabel *tagslist;

@end
