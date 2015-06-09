//
//  ViewController.h
//  ImageProcessing
//
//  Created by Michael Bao on 5/25/15.
//  Copyright (c) 2015 Michael Bao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showOriginalButton;

@property (weak, nonatomic) IBOutlet UIButton *runFilterButton;

@property (weak, nonatomic) IBOutlet UITextField *runtimeText;
@property (weak, nonatomic) IBOutlet UITextField *imageSelectionText;
@property (weak, nonatomic) IBOutlet UITextField *filterSelectionText;
@property (weak, nonatomic) IBOutlet UITextField *languageSelectionText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

