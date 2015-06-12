//
//  ViewController.m
//  ImageProcessing
//
//  Created by Michael Bao on 5/25/15.
//  Copyright (c) 2015 Michael Bao. All rights reserved.
//

#import "ViewController.h"
#import "Dispatch.h"
#include <Foundation/Foundation.h>
#include <UIKit/UIPickerView.h>

@interface ViewController()
@end

@implementation ViewController {
    UIPickerView* imagePicker;
    UIPickerView* filterPicker;
    UIPickerView* languagePicker;

    NSArray* imageOptions;
    NSArray* filterOptions;
    NSArray* languageOptions;

    NSBundle* imageBundle;
    
    Dispatch* dispatcher;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    [_imageSelectionText resignFirstResponder];
    [_filterSelectionText resignFirstResponder];
    [_languageSelectionText resignFirstResponder];
    [self refreshView];
}

- (void)refreshView {
    _imageSelectionText.text = [imageOptions objectAtIndex:[imagePicker selectedRowInComponent:0]];
    _filterSelectionText.text = [filterOptions objectAtIndex:[filterPicker selectedRowInComponent:0]];
    _languageSelectionText.text = [languageOptions objectAtIndex:[languagePicker selectedRowInComponent:0]];
    _runtimeText.text = @"Runtime:";

    [self loadCurrentOriginalImage];
}

- (void)loadCurrentOriginalImage {
    NSString* imageName = [imageBundle pathForResource:_imageSelectionText.text ofType:@"jpg"];
    UIImage* loadedImage = [[UIImage alloc] initWithContentsOfFile:imageName];
    [_imageView setImage:loadedImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatcher = [[Dispatch alloc] init];

    imageOptions = @[@"Hecarim", @"Gnar", @"Rumble", @"Ryze"];
    filterOptions = [Dispatch GetSupportedFilters];
    languageOptions = [Dispatch GetSupportedLanguages];

    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"Images" ofType:@"bundle"];
    imageBundle = [NSBundle bundleWithPath:bundlePath];

    UITapGestureRecognizer* imageTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [imageTap setNumberOfTapsRequired: 2];
    imageTap.delegate = self;

    UITapGestureRecognizer* filterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [filterTap setNumberOfTapsRequired: 2];
    filterTap.delegate = self;
    
    UITapGestureRecognizer* languageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [languageTap setNumberOfTapsRequired: 2];
    languageTap.delegate = self;

    imagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    imagePicker.showsSelectionIndicator = YES;
    imagePicker.dataSource = self;
    imagePicker.delegate = self;
    [imagePicker addGestureRecognizer: imageTap];
    _imageSelectionText.inputView = imagePicker;

    filterPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    filterPicker.showsSelectionIndicator = YES;
    filterPicker.dataSource = self;
    filterPicker.delegate = self;
    [filterPicker addGestureRecognizer: filterTap];
    _filterSelectionText.inputView = filterPicker;

    languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    languagePicker.showsSelectionIndicator = YES;
    languagePicker.dataSource = self;
    languagePicker.delegate = self;
    [languagePicker addGestureRecognizer: languageTap];
    _languageSelectionText.inputView = languagePicker;

    [self refreshView];
    [self loadCurrentOriginalImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == imagePicker) {
        return imageOptions.count;
    } else if (pickerView == filterPicker) {
        return filterOptions.count;
    } else if (pickerView == languagePicker) {
        return languageOptions.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
             forComponent:(NSInteger)component {
    if (pickerView == imagePicker) {
        return [imageOptions objectAtIndex:row];
    } else if (pickerView == filterPicker) {
        return [filterOptions objectAtIndex:row];
    } else if (pickerView == languagePicker) {
        return [languageOptions objectAtIndex:row];
    }
    return @""; 
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (IBAction)showOriginalButtonClick:(id)sender {
    [self loadCurrentOriginalImage];
}

- (IBAction)runFilterButtonClick:(id)sender {
    // Time how long the filter runs for (maybe better to not get any overhead associated with the dispatch but that should hopefully be ~neglible~
    NSDate* start = [NSDate date];
    UIImage* newImage = [dispatcher RunFilterOnImage:_imageView.image WithFilter:_filterSelectionText.text Language:_languageSelectionText.text];
    NSDate* end = [NSDate date];

    NSTimeInterval totalTime = [end timeIntervalSinceDate:start];
    _runtimeText.text = [NSString stringWithFormat:@"Runtime: %f seconds", totalTime];

    if (newImage == NULL) {
        NSLog(@"Error: Return image is NULL");
        return;
    }
    [_imageView setImage:newImage];
}

@end
