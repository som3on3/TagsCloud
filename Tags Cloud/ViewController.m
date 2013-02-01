//
//  ViewController.m
//  Tags Cloud
//
//  Created by Bogdan Adam on 1/27/13.
//  Copyright (c) 2013 Bogdan Adam. All rights reserved.
//

#import "ViewController.h"
#import "XTagsCloud.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tgc setADelegate:self];
    [self.tgc setTags:[NSArray arrayWithObjects:@"Tags", @"Cloud", nil]]; //add default tags
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)listSelected:(id)sender {
    NSString *list = [[self.tgc tags] componentsJoinedByString:@", "];
    [self.tagslist setText:list];
}

@end
