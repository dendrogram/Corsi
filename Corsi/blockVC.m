//
//  blockVC.m
//  Corsi
//
//  Created by Jonathan Howell on 28/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//  Minor updates and re-build for distro 2/11/15 jah
//  Minor updates and re-build for distro 9/9/16 jah
//
#import "blockVC.h"
#import "mySingleton.h"

@interface blockVC ()
{
    int start;
    int finish;
    
    float blockSize;
}
@end

@implementation blockVC{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //font attr of seg display, off at present

    //[[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Serifa-Roman" size:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

@synthesize
blockFinishNumLBL,
blockSizeLBL,
blockStartNumLBL,

sizeMinusBTN,
sizePlusBTN,
startMinusBTN,
startPlusBTN,
finishMinusBTN,
finishPlusBTN,

onScreenInfoSWT,
blockRotateSWT,
forwardTestSWT,
animalsSWT,
soundsSWT,
soundsSEG;

-(void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
    soundsSEG.selectedSegmentIndex = singleton.segIndex;

    //switches set
    if(singleton.blockRotation){
        blockRotateSWT.on = YES;
    }else{
        blockRotateSWT.on = NO;
    }
    if(singleton.forwardTestDirection){
        forwardTestSWT.on = YES;
    }else{
        forwardTestSWT.on = NO;
    }
    if(singleton.onScreenInfo){
        onScreenInfoSWT.on = YES;
    }else{
        onScreenInfoSWT.on = NO;
    }
    if(singleton.animals){
        animalsSWT.on = YES;
    }else{
        animalsSWT.on = NO;
    }
    if(singleton.sounds){
        soundsSEG.hidden = NO;
        soundsSWT.on     = YES;
        soundsSEG.selectedSegmentIndex = singleton.segIndex;
    }else{
        soundsSWT.on     = NO;
        soundsSEG.hidden = YES;
    }

    //blocks set
    start       = singleton.start;
    finish      = singleton.finish;
    blockSize   = singleton.blockSize;

    blockFinishNumLBL.text = [NSString stringWithFormat:@"%d",finish];
    blockStartNumLBL.text  = [NSString stringWithFormat:@"%d",start];
    blockSizeLBL.text      = [NSString stringWithFormat:@"%.0f",blockSize];
    [self buttonIncCheck];
}

- (IBAction)soundsSEG:(id)sender{
    //sound effect name to load
        mySingleton *singleton = [mySingleton sharedSingleton];
    long seg = soundsSEG.selectedSegmentIndex;
    switch (seg) {
        case 0:
            singleton.beepEffect = @"KLICK";
            singleton.segIndex   = 0;
            break;
        case 1:
            singleton.beepEffect = @"BEEPPURE";
            singleton.segIndex   = 1;
            break;
        case 2:
            singleton.beepEffect = @"BEEP_FM";
            singleton.segIndex   = 2;
            break;
        case 3:
            singleton.beepEffect = @"BEEPDOUB";
            singleton.segIndex   = 3;
            break;
        case 4:
            singleton.beepEffect = @"AMFMBEEP";
            singleton.segIndex   = 4;
            break;
        case 5:
            singleton.beepEffect = @"BEEPJAZZ";
            singleton.segIndex   = 5;
            break;
        default:
            singleton.beepEffect = @"BEEPJAZZ";
            singleton.segIndex   = 5;
            break;
    }
}

-(void)buttonIncCheck{
    //change alpha value of graphic if range exceeded
    if(start == 3){
        startMinusBTN.alpha  = 0.3;
    }
    if(finish == 9){
        finishPlusBTN.alpha  = 0.3;
    }
    if(finish == 3){
        finishMinusBTN.alpha = 0.3;
    }
    if(start == 9){
        startPlusBTN.alpha   = 0.3;
    }
    if(start == finish){
        startPlusBTN.alpha   = 0.3;
        finishMinusBTN.alpha = 0.3;
    }
    if(blockSize == 55){
        sizePlusBTN.alpha    = 0.3;
    }
    if(blockSize == 10){
        sizeMinusBTN.alpha   = 0.3;
    }
    if(start < finish){
        startPlusBTN.alpha   = 1;
        finishMinusBTN.alpha = 1;
    }
    if(finish > start){
        startPlusBTN.alpha   = 1;
        finishMinusBTN.alpha = 1;
    }
}

- (IBAction)blockStartPlusBTN:(id)sender{
    //increment start
    mySingleton *singleton = [mySingleton sharedSingleton];
    start  = singleton.start;
    finish = singleton.finish;

    start++;
    startMinusBTN.alpha = 1;
    startPlusBTN.alpha  = 1;

    if (start >= 9) {
        start  = 9;
    }
    if (start > finish) {
        start = finish;
    }
    [self buttonIncCheck];
    
    blockStartNumLBL.text  = [NSString stringWithFormat:@"%d",start];
    blockFinishNumLBL.text = [NSString stringWithFormat:@"%d",finish];
    singleton.start  = start;
    singleton.finish = finish;
}

- (IBAction)blockFinishPlusBTN:(id)sender{
    //increment finish
    mySingleton *singleton = [mySingleton sharedSingleton];
    start  = singleton.start;
    finish = singleton.finish;

    finish++;
    finishMinusBTN.alpha = 1;
    finishPlusBTN.alpha  = 1;
    if (finish >= 9) {
        finish  = 9;
    }
    [self buttonIncCheck];
    blockStartNumLBL.text  = [NSString stringWithFormat:@"%d",start];
    blockFinishNumLBL.text = [NSString stringWithFormat:@"%d",finish];
    singleton.start  = start;
    singleton.finish = finish;
}

- (IBAction)blockSizePlusBTN:(id)sender{
    //increment size
    mySingleton *singleton = [mySingleton sharedSingleton];
    blockSize           = singleton.blockSize;
    blockSize = blockSize+5;
    sizeMinusBTN.alpha  = 1;
    sizePlusBTN.alpha   = 1;
    if (blockSize > 55) {
        blockSize       = 55;
    }
    [self buttonIncCheck];
    blockSizeLBL.text      = [NSString stringWithFormat:@"%.0f", blockSize];
    singleton.blockSize    = blockSize;
}

- (IBAction)blockStartMinusBTN:(id)sender{
    //decrement start
    mySingleton *singleton = [mySingleton sharedSingleton];
    start  = singleton.start;
    finish = singleton.finish;

    start--;
    startMinusBTN.alpha = 1;
    startPlusBTN.alpha  = 1;

    if (start <= 3) {
        start  = 3;
    }
    [self buttonIncCheck];
    blockStartNumLBL.text  = [NSString stringWithFormat:@"%d",start];
    blockFinishNumLBL.text = [NSString stringWithFormat:@"%d",finish];
    singleton.start  = start;
    singleton.finish = finish;
}

- (IBAction)blockFinishMinusBTN:(id)sender{
    //decrement finish
    mySingleton *singleton = [mySingleton sharedSingleton];
    start  = singleton.start;
    finish = singleton.finish;

    finish--;
    finishMinusBTN.alpha = 1;
    finishPlusBTN.alpha  = 1;

    if (finish <= 3) {
          finish = 3;
    }
    if (finish < start) {
        finish = start;
     }

    [self buttonIncCheck];
    blockStartNumLBL.text  = [NSString stringWithFormat:@"%d",start];
    blockFinishNumLBL.text = [NSString stringWithFormat:@"%d",finish];
    singleton.start  = start;
    singleton.finish = finish;
}

- (IBAction)blockSizeMinusBTN:(id)sender{
    //decrement size
    mySingleton *singleton = [mySingleton sharedSingleton];

    blockSize           = singleton.blockSize;
    blockSize           = blockSize-5;
    sizeMinusBTN.alpha  = 1;
    sizePlusBTN.alpha   = 1;

    if (blockSize < 10) {
        blockSize = 10;
    }

    [self buttonIncCheck];
    blockSizeLBL.text   = [NSString stringWithFormat:@"%.0f", blockSize];
    singleton.blockSize = blockSize;
}

- (IBAction)forwardTestSWT:(id)sender{
    //test direction switch
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL forwardTestDirection;
    if(forwardTestSWT.isOn){
        forwardTestDirection = YES;
    }else{
        forwardTestDirection = NO;
    }
    singleton.forwardTestDirection = forwardTestDirection;
}

- (IBAction)onScreenInfoSWT:(id)sender{
    //information messages switch
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    BOOL screenInfoDisplayed;
    
    if(onScreenInfoSWT.isOn){
        screenInfoDisplayed = YES;
    } else {
        screenInfoDisplayed = NO;
    }
    singleton.onScreenInfo  = screenInfoDisplayed;
}

- (IBAction)blockRotateSWT:(id)sender{
    //block rotation switch
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL rotate;
    if (blockRotateSWT.isOn)
        {
        rotate = YES;
        } else {
        rotate = NO;
        }
    singleton.blockRotation = rotate;
}

- (IBAction)animalsSWT:(id)sender{
    //animals graphics switch
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL animals;
    if (animalsSWT.isOn)
    {
        animals = YES;
    } else {
        animals = NO;
    }
    singleton.animals = animals;
}

- (IBAction)soundsSWT:(id)sender{
    //feedback sounds switch
    mySingleton *singleton = [mySingleton sharedSingleton];
    BOOL sounds;
    if (soundsSWT.isOn)
    {
        sounds = YES;
        soundsSEG.hidden=NO;
    } else {
        sounds = NO;
        soundsSEG.hidden=YES;
    }
    singleton.sounds = sounds;
}
@end
