//
//  colourSelVC.h
//  Corsi
//
//  Created by Jon Howell on 24/11/2014.
//  Copyright (c) 2014 Manchester Metropolitan Univers
//  Minor updates and re-build for distro 9/9/16 jahity - ESS - essmobile. All rights reserved.
//  Minor updates and re-build for distro 2/11/15 jah
//

#import <UIKit/UIKit.h>

@interface colourSelVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIPickerView *backPicker;
    IBOutlet UIPickerView *showPicker;
    IBOutlet UIPickerView *blockPicker;
}

@property (strong, nonatomic) IBOutlet UIPickerView * backPicker;
@property (strong, nonatomic) IBOutlet UIPickerView * showPicker;
@property (strong, nonatomic) IBOutlet UIPickerView * blockPicker;
@property (strong, nonatomic) IBOutlet UITextView   * messageTextView;

@property (strong, nonatomic) IBOutlet UIImageView  * backCol;
@property (strong, nonatomic) IBOutlet UIImageView  * showCol;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol1;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol2;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol3;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol4;
@property (strong, nonatomic) IBOutlet UIImageView  * blockCol5;

@property (strong, nonatomic)          NSArray      * colourArrayBack;
@property (strong, nonatomic)          NSArray      * colourArrayShow;
@property (strong, nonatomic)          NSArray      * colourArrayBlock;
@property (strong, nonatomic)          NSArray      * imageNames;
@property (strong, nonatomic)          NSMutableArray * images;

@property (strong, nonatomic) IBOutlet UIButton * backBTN;
@end
