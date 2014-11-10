//
//  testVC.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "testVC.h"
#import "mySingleton.h"

#define kEmail      @"emailAddress"
#define kTester     @"testerName"
#define kSubject    @"subjectName"

@interface testVC ()
{
    NSNumber *box[10];
    UIImageView *card[11];
    int startcounter;
    int finishcounter;
    int stageCounter;
    int xcounter;
    int ncounter;
    
    BOOL isFinished;
    BOOL isCalculating;
    BOOL isAlertFinished;
    BOOL stageEnded;
    BOOL resultsSaved;
    BOOL infoShow;
    BOOL reverseTest;
    float blockSize1;
    BOOL rotateBlocks;
    BOOL animals;
    
    int xAdj[10];
    int yAdj[10];
    int angle[10];
    int total;
    float percent;
    float flash2;
    NSString *order[12];
    NSString *guess[12];
    NSString *reverse[12];
    NSString *beepName;
    NSString *subjectName;
    NSString *email;
    NSString *testerName;
    NSString *tempStartMessage;
    int score;
    int pressNo;
    NSString *orderStr[12];
    NSString *reverseStr[12];
    NSString *guessStr[12];
    NSString *correct[12];
    Float32 testTime[7][12];
    Float32 testTimer[7][12];
    int testNo;
    int timingCalc;
    int reply1;
    long tm;
    BOOL analysisFlag;
    Float32 timeGuess[7][12];
    int start;
    int finish;
    float waitTime;
    float startTime;
    float showTime;
    float messageTime;

    UIColor *currentBlockColour;
    UIColor *currentShowColour;
    UIColor *currentBackgroundColour;
    UIColor *currentStatusColour;
    NSArray *totalCorrect;
}
@end

@implementation testVC
@synthesize
    box1iv,
    backgroundMusicPlayer, //for sounds
    blkLBL,
    blkNoLBL,
    blkTotalLBL,
    blkOfLBL,
    box1BTN,
    box1image,
    box2BTN,
    box2image,
    box3BTN,
    box3image,
    box4BTN,
    box4image,
    box5BTN,
    box5image,
    box6BTN,
    box6image,
    box7BTN,
    box7image,
    box8BTN,
    box8image,
    box9BTN,
    box9image,
    setLBL,
    setNoLBL,
    setOfLBL,
    setTotalLBL,
    startBTN,
    statusMessageLBL,
    headingLBL,
    MessageTextView,
    MessageView,
    scaleFactor,
    testViewerView,
    stopTestNowBTN
    ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    stopTestNowBTN.hidden=YES;
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //sound stuff
    backIsStarted=false;
    
    beepName=singleton.beepEffect;
    NSString *backgroundMusicPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *backgroundMusicURL=[NSURL fileURLWithPath:backgroundMusicPath];
    NSError *error;
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [backgroundMusicPlayer setNumberOfLoops:3]; //-1 = forever
    //prepare to play
    NSString *mySoundEffectPath=[[NSBundle mainBundle]pathForResource:beepName ofType:@"caf"];
    NSURL *mySoundEffectURL=[NSURL fileURLWithPath:mySoundEffectPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(mySoundEffectURL),&mySoundEffect);
    
    infoShow=singleton.onScreenInfo;

    flash2 = 0.25;// flash button when pressed
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }
}

-(void)startStop{
    //toggle the background sounds on/off
    if (backIsStarted) {
        [backgroundMusicPlayer stop];
    }else{
        [backgroundMusicPlayer prepareToPlay];
        [backgroundMusicPlayer play];
    }
    backIsStarted=!backIsStarted;
}

-(void)setVolumeValue{
    //set the volume of the sound
    [backgroundMusicPlayer setVolume:5];
}

-(void)playMyEffect{
    //make a noise, if the flag is on for sound
        mySingleton *singleton = [mySingleton sharedSingleton];
    if (singleton.sounds) {
        AudioServicesPlaySystemSound(mySoundEffect);
    }
}

-(void)initialiseBlocks{
    statusMessageLBL.text = @"CORSI Block Test";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //check for direction of test and title the test appropiately
    if (singleton.forwardTestDirection) {
        headingLBL.text=@"CORSI FORWARD BLOCK TEST";
    }else{
        headingLBL.text=@"CORSI REVERSE BLOCK TEST";
    }

    animals=singleton.animals;
    
    [self putAnimals]; //place the correct random animal in the view
    
    [self setColours];
    
    [self allButtonsBackgroundReset];
    
    [self putBlocksInPlace];
    
    int sizeb=0;
    if (!singleton.blockRotation) {
        box1image.transform = CGAffineTransformTranslate(box1image.transform,[self randomPt]-sizeb, [self randomPt]);
        box2image.transform = CGAffineTransformTranslate(box2image.transform,[self randomPt]-sizeb, [self randomPt]);
        box3image.transform = CGAffineTransformTranslate(box3image.transform,[self randomPt]-sizeb, [self randomPt]);
        box4image.transform = CGAffineTransformTranslate(box4image.transform,[self randomPt]-sizeb, [self randomPt]);
        box5image.transform = CGAffineTransformTranslate(box5image.transform,[self randomPt]-sizeb, [self randomPt]);
        box6image.transform = CGAffineTransformTranslate(box6image.transform,[self randomPt]-sizeb, [self randomPt]);
        box7image.transform = CGAffineTransformTranslate(box7image.transform,[self randomPt]-sizeb, [self randomPt]);
        box8image.transform = CGAffineTransformTranslate(box8image.transform,[self randomPt]-sizeb, [self randomPt]);
        box9image.transform = CGAffineTransformTranslate(box9image.transform,[self randomPt]-sizeb, [self randomPt]);
    }
    
    infoShow=singleton.onScreenInfo;
    
    //make 9 sets of number strings
    for (int x=1; x<10; x++) {
        order[x]=[self make9order];
        reverse[x]=[self rev9Order:order[x]];
        NSLog(@"Order returned for Set: %d is:%@, reverse:%@",x, order[x], reverse[x]);
    }
    // don't bother, too difficult to do yet //[self rotAllBlocks];
}

-(void)putAnimals{
    if (animals) {
        //draw an animal picture in the view
        int ani[22];
        NSLog(@"start");
        for (int b=0; b<22; b++) {
            ani[b]=b;
            NSLog(@"animal:%d", ani[b]);
        }
        int temp=0;
        int tt=0;
        for (int b=0; b<2541; b++) {
            tt=[self random22];
            temp=ani[tt-1];
            ani[tt-1]=ani[tt];
            ani[tt]=temp;
        }
        NSLog(@"mix");
        for (int b=0; b<22; b++) {
            NSLog(@"animal:%d", ani[b]);
        }
        NSLog(@"end");
        box1image.image = [self getAnimal:ani[1]];
        box2image.image = [self getAnimal:ani[3]];
        box3image.image = [self getAnimal:ani[5]];
        box4image.image = [self getAnimal:ani[7]];
        box5image.image = [self getAnimal:ani[8]];
        box6image.image = [self getAnimal:ani[0]];
        box7image.image = [self getAnimal:ani[2]];
        box8image.image = [self getAnimal:ani[4]];
        box9image.image = [self getAnimal:ani[6]];
    }
}

-(UIImage*)getAnimal:(int)animalNo{
    //pick an animal and return its image
    UIImage *animal;
    switch (animalNo) {
        case 1:
            animal = [UIImage imageNamed:@"Elephant"];
            break;
        case 2:
            animal = [UIImage imageNamed:@"Donkey"];
            break;
        case 3:
            animal = [UIImage imageNamed:@"Frog"];
            break;
        case 4:
            animal = [UIImage imageNamed:@"Fox"];
            break;
        case 5:
            animal = [UIImage imageNamed:@"Goat"];
            break;
        case 6:
            animal = [UIImage imageNamed:@"Crab"];
            break;
        case 7:
            animal = [UIImage imageNamed:@"Bear"];
            break;
        case 8:
            animal = [UIImage imageNamed:@"Bird"];
            break;
        case 9:
            animal = [UIImage imageNamed:@"Duck"];
            break;
        case 10:
            animal = [UIImage imageNamed:@"Croc"];
            break;
        case 11:
            animal = [UIImage imageNamed:@"Cow"];
            break;
        case 12:
            animal = [UIImage imageNamed:@"Butterfly"];
            break;
        case 13:
            animal = [UIImage imageNamed:@"Lion"];
            break;
        case 14:
            animal = [UIImage imageNamed:@"Lama"];
            break;
        case 15:
            animal = [UIImage imageNamed:@"Penguin"];
            break;
        case 16:
            animal = [UIImage imageNamed:@"Fish"];
            break;
        case 17:
            animal = [UIImage imageNamed:@"Seal"];
            break;
        case 18:
            animal = [UIImage imageNamed:@"Tortoise"];
            break;
        case 19:
            animal = [UIImage imageNamed:@"Rabbit"];
            break;
        case 20:
            animal = [UIImage imageNamed:@"Pig"];
            break;
        case 21:
            animal = [UIImage imageNamed:@"Squirel"];
            break;
        default:
            animal = [UIImage imageNamed:@"Cat"];
            break;
    }
    return animal;
}

-(NSString*) rev9Order:(NSString*)forOrder{
    NSString *revOrder;
    revOrder=@"";//blank
    for (int t=8; t>-1; t--) {
        revOrder= [revOrder stringByAppendingString:[forOrder substringWithRange:NSMakeRange(t, 1)]];
    }
    return revOrder;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //an alert was detected, get the text filelds and update the singleton
        mySingleton *singleton = [mySingleton sharedSingleton];
    NSString * testerEmail =[[alertView textFieldAtIndex:0] text];
    NSString * participant =[[alertView textFieldAtIndex:1] text];
        NSLog(@"Tester Email    : %@", testerEmail);
        NSLog(@"Participant     : %@", participant);

    //test for blank names and details
    if ([testerEmail isEqualToString:@""]) {
        testerEmail=singleton.email;
    }
    if ([participant isEqualToString:@""]) {
        testerEmail=singleton.subjectName;
    }

    //update singleton
    singleton.email=testerEmail;
    singleton.subjectName=participant;

    //save to plist root
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *defaultPrefsFile = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
   [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //email name
        [defaults setObject:testerEmail forKey:kEmail];
    //subject name
        [defaults setObject:participant forKey:kSubject];

    isAlertFinished=YES;
}

-(void)participantEntry{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //do a text input for the participant
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Enter Tester Email and Participant Code"
                                                    delegate:self
                                           cancelButtonTitle:nil //@"Cancel"
                                           otherButtonTitles:@"Continue", nil];

    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;


    UITextField * alertTextField1 = [alert textFieldAtIndex:0];
    alertTextField1.keyboardType = UIKeyboardTypeEmailAddress;
    alertTextField1.placeholder = singleton.email;


    UITextField * alertTextField2 = [alert textFieldAtIndex:1];
    alertTextField2.secureTextEntry=NO;
    alertTextField2.keyboardType = UIKeyboardTypeDefault;
    //if blank, add temp name, else add the current one
    if ([singleton.subjectName isEqualToString:@""]) {
        alertTextField2.placeholder = @"Participant Code";
    }else{
        alertTextField2.placeholder = singleton.subjectName;
    }

    [alert show];
}

-(IBAction)startTest:sender{
    isAlertFinished=NO;

    [self participantEntry];
    [self startTestPart2];
}

-(void)startTestPart2{
    //this will be looped until the text alert popup is finished
    mySingleton *singleton = [mySingleton sharedSingleton];

    if (isAlertFinished) {

    [self playMyEffect];


    //blank out the tab bar during the test, no end until done now
    self.tabBarController.tabBar.hidden = YES;
    stopTestNowBTN.hidden=NO;
    NSLog(@"Test has started");
    statusMessageLBL.text = @"The Test Has Started";

    startBTN.hidden   = YES;
    headingLBL.hidden = YES;

    [self setColours];

    start       = singleton.start;
    finish      = singleton.finish;
    
    startTime   =[self delayDelay];
    showTime    =[self delayShow];
    waitTime    =[self delayWait];
    messageTime =[self delayMessage];

    //[self hide_blocks];
    
    [self hideInfo];
    
    MessageTextView.hidden=YES;
    
    //start the timer
    //[self.startDate = [NSDate date];
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(boxInit) userInfo:nil repeats:NO];

    MessageView.hidden=NO;
    } else {
        //participant alert not yet finished, loop
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startTestPart2) userInfo:nil repeats:NO];
    }
}

-(float)randomDegrees359
{
    float degrees = 0;
    degrees = arc4random_uniform(359); //was 359 //returns a value from 0 to 359, not 360;

    //NSLog(@"Degs=%f",degrees);
    return degrees;
}

-(void)putBlocksInPlace{
    {
    mySingleton *singleton = [mySingleton sharedSingleton];
    // Do any additional setup after loading the view.

    //colour the blocks
    [self updateBlockColours];

    blockSize1 = singleton.blockSize;
        blockSize1 = blockSize1 / 55; // 55.00; //size picked against max size allowed here
    if( blockSize1 <= 0.2){
        blockSize1 = 0.2;
    }
    if( blockSize1 >= 1){
        blockSize1 = 1;
    }

    scaleFactor = blockSize1;

    if(singleton.blockRotation){
        for (int t = 0; t < 10; t++) {
            angle[t] = self.randomDegrees359;
        }
    } else {
        for (int t = 0; t < 10; t++) {
                angle[t] = 0;
        }
    }
        
    //UITouch *touch = [touches anyObject];//some old example code if you used a touch rather than an image reference
    //make sure rotation is about the centre axis. 0,0 is bot left, .5,.5 is ctr, 1,1 is top rt, 1,.5 is mid right.
        
        box1image.layer.anchorPoint = CGPointMake(.5,.5);
        box2image.layer.anchorPoint = CGPointMake(.5,.5);
        box3image.layer.anchorPoint = CGPointMake(.5,.5);
        box4image.layer.anchorPoint = CGPointMake(.5,.5);
        box5image.layer.anchorPoint = CGPointMake(.5,.5);
        box6image.layer.anchorPoint = CGPointMake(.5,.5);
        box7image.layer.anchorPoint = CGPointMake(.5,.5);
        box8image.layer.anchorPoint = CGPointMake(.5,.5);
        box9image.layer.anchorPoint = CGPointMake(.5,.5);
      
    [UIView animateWithDuration:1.0
                        delay:0.0
                         options:UIViewAnimationOptionCurveEaseInOut
 
                     animations:^{
                         
                         CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scaleFactor, scaleFactor);

                         CGAffineTransform rotateTrans1 = CGAffineTransformMakeRotation(angle[1] * M_PI / 180);
                         CGAffineTransform rotateTrans2 = CGAffineTransformMakeRotation(angle[2] * M_PI / 180);
                         CGAffineTransform rotateTrans3 = CGAffineTransformMakeRotation(angle[3] * M_PI / 180);
                         CGAffineTransform rotateTrans4 = CGAffineTransformMakeRotation(angle[4] * M_PI / 180);
                         CGAffineTransform rotateTrans5 = CGAffineTransformMakeRotation(angle[5] * M_PI / 180);
                         CGAffineTransform rotateTrans6 = CGAffineTransformMakeRotation(angle[6] * M_PI / 180);
                         CGAffineTransform rotateTrans7 = CGAffineTransformMakeRotation(angle[7] * M_PI / 180);
                         CGAffineTransform rotateTrans8 = CGAffineTransformMakeRotation(angle[8] * M_PI / 180);
                         CGAffineTransform rotateTrans9 = CGAffineTransformMakeRotation(angle[9] * M_PI / 180);
                         
                      
                         box1image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans1);
                         box2image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans2);
                         box3image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans3);
                         box4image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans4);
                         box5image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans5);
                         box6image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans6);
                         box7image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans7);
                         box8image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans8);
                         box9image.transform = CGAffineTransformConcat(scaleTrans, rotateTrans9);
                         
                     }completion:nil];
    }
}

-(NSString*) make9order{
    //makes a string of numbers, each one only once
    NSString *nums[11];
    NSString *orderz;
    //make numbers 1=9
    for (int n=1;n<10;n++){
        nums[n]=[NSString stringWithFormat:@"%i",n ];
    }
    //shuffle the array of numbers
    NSString *temp;
    for (int x=0;x<12531;x++){
        for(int n=1;n<9;n++){
            int boxz = (arc4random() % 8)+1;
            
            if(boxz==0||boxz>9){
                boxz=1;
            }
            
            if(boxz>=5){
                temp = nums[n];
                nums[n]=nums[n+1];
                nums[n+1]=temp;
            }
        }
    }
    //format the string from the parts and return it
    orderz=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",nums[1],nums[3],nums[2],nums[5],nums[4],nums[7],nums[6],nums[9],nums[8]];
    return orderz;
}

-(int) whichBlock: (int) number :(int) stage{
    //read the order from the array and pick the n'th char
    //int stringNo = [order[stage] characterAtIndex:number]; //returns character number
    NSString *stringNo = [order[stage] substringWithRange:NSMakeRange(number-1, 1)];
    int block = [stringNo intValue];
    return block;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
UIImage *testImage      = [UIImage imageNamed:@"test.png"];
UIImage *testImageSel   = [UIImage imageNamed:@"testSel.png"];
testImage               = [testImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
testImageSel            = [testImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
self.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];

self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Test" image:testImage selectedImage: testImageSel];
    
    MessageTextView.hidden=YES;
    [self initialiseBlocks];

    mySingleton *singleton = [mySingleton sharedSingleton];

    [self allButtonsBackgroundReset];
    //hide unhide labels, screens and buttons

    startBTN.hidden  = NO;
    headingLBL.hidden= NO;

    [self hideInfo];

    testViewerView.backgroundColor=singleton.currentBackgroundColour;
    currentBackgroundColour = singleton.currentBackgroundColour;
    currentBlockColour      = singleton.currentBlockColour;
    currentShowColour       = singleton.currentShowColour;
    currentStatusColour     = singleton.currentStatusColour;
    
    [self setColours];
    
    tempStartMessage=@"You will be shown a sequence of blocks, observe the order when prompted, \n and recall the sequence when prompted. \n\nThe test will proceed until all the sections are completed.\n\nYou will exit the test if you select any other tab menu item during the test.\n\nOnly completed tests are valid and available for analysis or email.";
    
    MessageTextView.text=tempStartMessage;
    //MessageTextView.font=[UIFont fontWithName:@"Serifa-Roman" size:(14.0f)];
    //MessageTextView.textAlignment = UITextAlignmentCenter;
    MessageTextView.hidden=NO;
    MessageView.hidden=YES;
    startBTN.hidden=NO;

    //initialise images for messages on messageview
    card[0] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_start3.png"]];
    card[1] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_finish3.png"]];
    card[2] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-start.png"]];
    card[3] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-stage-end.png"]];
    card[4] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_calc3.png"]];
    card[5] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi-touch-blocks2.png"]];
    card[6] = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"corsi_results3.png"]];
}

-(IBAction)stopTestNow:(id)sender{
    self.tabBarController.tabBar.hidden = NO;
}

//
-(void)awakeFromNib {
    statusMessageLBL.text=@"The App is Awake...";
 }

//
-(float) delayDelay
{//start delay, once only
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayDelay1;
    delayDelay1  = singleton.startTime/1000;
    return delayDelay1;
}

-(float) delayWait
{//wait delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayWait1;
    delayWait1 = singleton.waitTime/1000;
    return delayWait1;
}

-(float) delayShow
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayShow1;
    delayShow1 = singleton.showTime/1000;
    return delayShow1;
}

-(float) delayMessage
{//show delay, after each box display
    mySingleton *singleton = [mySingleton sharedSingleton];
    float delayMessage1;
    delayMessage1 = singleton.messageTime/1000;
    return delayMessage1;
}

-(void)display_blocks{
    //show the blocks
    box1image.hidden = false;
    box2image.hidden = false;
    box3image.hidden = false;
    box4image.hidden = false;
    box5image.hidden = false;
    box6image.hidden = false;
    box7image.hidden = false;
    box8image.hidden = false;
    box9image.hidden = false;
    //show the buttons on the top
    box1BTN.hidden   = false;
    box2BTN.hidden   = false;
    box3BTN.hidden   = false;
    box4BTN.hidden   = false;
    box5BTN.hidden   = false;
    box6BTN.hidden   = false;
    box7BTN.hidden   = false;
    box8BTN.hidden   = false;
    box9BTN.hidden   = false;
}

-(void)hide_blocks{
    //hide the blocks
    box1image.hidden = true;
    box2image.hidden = true;
    box3image.hidden = true;
    box4image.hidden = true;
    box5image.hidden = true;
    box6image.hidden = true;
    box7image.hidden = true;
    box8image.hidden = true;
    box9image.hidden = true;
    //hide the buttons on the top
    box1BTN.hidden   = true;
    box2BTN.hidden   = true;
    box3BTN.hidden   = true;
    box4BTN.hidden   = true;
    box5BTN.hidden   = true;
    box6BTN.hidden   = true;
    box7BTN.hidden   = true;
    box8BTN.hidden   = true;
    box9BTN.hidden   = true;
}

-(void)showInfo{
    //show the messages and status
    blkLBL.hidden      = false;
    blkNoLBL.hidden    = false;
    blkOfLBL.hidden    = false;
    blkTotalLBL.hidden = false;
    setLBL.hidden      = false;
    setTotalLBL.hidden = false;
    setOfLBL.hidden    = false;
    setNoLBL.hidden    = false;
    statusMessageLBL.hidden
                       = false;
}
-(void)hideInfo{
    //hide the messages and status
    blkLBL.hidden      = true;
    blkNoLBL.hidden    = true;
    blkOfLBL.hidden    = true;
    blkTotalLBL.hidden = true;
    setLBL.hidden      = true;
    setTotalLBL.hidden = true;
    setOfLBL.hidden    = true;
    setNoLBL.hidden    = true;
    statusMessageLBL.hidden
                       = true;
}

-(void)boxInit {
    NSLog(@"box init");

    if (infoShow) {
        statusMessageLBL.text = @"Observe Blocks, Start of Test";
    }else{
        statusMessageLBL.text = @"";
    }
    
    [self display_blocks];
    
    [self hideInfo];
    [self allButtonsBackgroundReset];// background colour reset to std

    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    isFinished=NO;
    isCalculating=NO;
    [self showInfo];
    
    //zero counters
    xcounter = start; //default is 3 but could be 3-9 range depending on settings
    ncounter = 1;
    pressNo  = 0; //set initial no of presses
    
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", 0];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-2];

    [self buttonsDisable];
    
    [MessageView setImage: card[0].image];
    [NSTimer scheduledTimerWithTimeInterval:(messageTime*1.5) target:self selector:@selector(startTestMSG) userInfo:nil repeats:NO];
}

-(void)stageChecks {
    if (isFinished) { //definitely ended, to catch second round of checks
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }
    //check for stage and test end
    if ((xcounter == finish) && (ncounter >= xcounter)) {
        //test is ended
        //update all counters
    ncounter = ncounter+1;   //block number 3-9 range
    
    if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
        xcounter=xcounter+1; //stage counter 3-9 range
        ncounter=0;
    }
        isFinished=YES;
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(finalStageEndMSG) userInfo:nil repeats:NO];
    }else{
        if(ncounter>=xcounter){
            //not finished, but ended a stage
            //update all counters
            ncounter = ncounter+1;   //block number 3-9 range

            if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
                xcounter=xcounter+1; //stage counter 3-9 range
                ncounter=0;
            }
            [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageEndMSG) userInfo:nil repeats:NO];
        }else{
            //not ended, carry on
            //update all counters
            ncounter = ncounter+1;   //block number 3-9 range

            if(ncounter>=xcounter+1){ //starts at 3 for 3 blocks, end stage, then new set, 3 for 4 blocks etc.
                xcounter=xcounter+1; //stage counter 3-9 range
                ncounter=0;
            }
            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(box1) userInfo:nil repeats:NO];
        }
    }
}

-(void)buttonsEnable{
    box1BTN.enabled=YES;
    box2BTN.enabled=YES;
    box3BTN.enabled=YES;
    box4BTN.enabled=YES;
    box5BTN.enabled=YES;
    box6BTN.enabled=YES;
    box7BTN.enabled=YES;
    box8BTN.enabled=YES;
    box9BTN.enabled=YES;
}

-(void)buttonsDisable{
    box1BTN.enabled=NO;
    box2BTN.enabled=NO;
    box3BTN.enabled=NO;
    box4BTN.enabled=NO;
    box5BTN.enabled=NO;
    box6BTN.enabled=NO;
    box7BTN.enabled=NO;
    box8BTN.enabled=NO;
    box9BTN.enabled=NO;
}

-(void)box1 {
    //block button inputs for now, re-enable after stage end.
    [self buttonsDisable];
    
    //display status
    blkTotalLBL.text = [NSString stringWithFormat:@"%d", xcounter];
    blkNoLBL.text    = [NSString stringWithFormat:@"%d", ncounter];
    setNoLBL.text    = [NSString stringWithFormat:@"%d", xcounter-2];
    setTotalLBL.text = [NSString stringWithFormat:@"%d", finish-2];
    [self showInfo];
    //hide all messages except blocks
    MessageTextView.hidden=YES;
    MessageView.hidden=YES;
    startBTN.hidden=YES;
    
    //display blocks
    [self display_blocks];

    if (infoShow) {
        statusMessageLBL.text = @"Observe Block Sequence";
    }else{
        statusMessageLBL.text = @"Observe";
    }

    int t=[self whichBlock:ncounter :xcounter];
    NSLog(@"block showing : %i seq : %i set : %i", t, ncounter, xcounter);
    //show the t block
    switch (t) {
        case 1:
            box1image.backgroundColor=currentShowColour;
            break;
        case 2:
            box2image.backgroundColor=currentShowColour;
            break;
        case 3:
            box3image.backgroundColor=currentShowColour;
            break;
        case 4:
            box4image.backgroundColor=currentShowColour;
            break;
        case 5:
            box5image.backgroundColor=currentShowColour;
            break;
        case 6:
            box6image.backgroundColor=currentShowColour;
            break;
        case 7:
            box7image.backgroundColor=currentShowColour;
            break;
        case 8:
            box8image.backgroundColor=currentShowColour;
            break;
        case 9:
            box9image.backgroundColor=currentShowColour;
            break;
        default:
            [self allButtonsBackgroundReset];// background colour reset to std.
            break;
    }
    [NSTimer scheduledTimerWithTimeInterval:showTime target:self selector:@selector(but1) userInfo:nil repeats:NO];
}

-(void)but1 {
    [self buttonsDisable];
    //clears the block, waits and then sends to check to see if any end, stage or flag is passed
    [self allButtonsBackgroundReset];// background colour reset to std
    [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
}

-(void)allButtonsBackgroundReset {
    box1image.backgroundColor=currentBlockColour;
    box2image.backgroundColor=currentBlockColour;
    box3image.backgroundColor=currentBlockColour;
    box4image.backgroundColor=currentBlockColour;
    box5image.backgroundColor=currentBlockColour;
    box6image.backgroundColor=currentBlockColour;
    box7image.backgroundColor=currentBlockColour;
    box8image.backgroundColor=currentBlockColour;
    box9image.backgroundColor=currentBlockColour;
}

-(void)statusUpdate:(int)press{
    if (infoShow) {

    switch (press) {
        case 1:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@",guess[1]];
            break;
        case 2:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@",guess[1],guess[2]];
            break;
        case 3:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@",guess[1],guess[2],guess[3]];
            break;
        case 4:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@",guess[1],guess[2],guess[3],guess[4]];
            break;
        case 5:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5]];
            break;
        case 6:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6]];
            break;
        case 7:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7]];
            break;
        case 8:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8]];
            break;
        case 9:
            statusMessageLBL.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
            break;

        default:
            statusMessageLBL.text = @"Touch the blocks in sequence";
            break;
    }
    }else{
        statusMessageLBL.text = @"Recall";
    }
        //guessStr[xcounter]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
}

-(void)waiting{
    //do nothing, wiat for a new key press after flashing the button
}

-(IBAction)blk1BUT:(id)sender{
    //button 1 pressed
    box1image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"1";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut1) userInfo:nil repeats:NO];
}

-(void)blankMSGbut1 {
    box1image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut2 {
    box2image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut3 {
    box3image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut4 {
    box4image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut5 {
    box5image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut6 {
    box6image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut7 {
    box7image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut8 {
    box8image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}
-(void)blankMSGbut9 {
    box9image.backgroundColor=currentBlockColour;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}

-(IBAction)blk2BUT:(id)sender{
    //button 2 pressed
    box2image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"2";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut2) userInfo:nil repeats:NO];
}


-(IBAction)blk3BUT:(id)sender{
    //button 3 pressed
    box3image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"3";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut3) userInfo:nil repeats:NO];
}

-(IBAction)blk4BUT:(id)sender{
    //button 4 pressed
    box4image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"4";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut4) userInfo:nil repeats:NO];
}

-(IBAction)blk5BUT:(id)sender{
    //button 5 pressed
    box5image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"5";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut5) userInfo:nil repeats:NO];
}

-(IBAction)blk6BUT:(id)sender{
    //button 6 pressed
    box6image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"6";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut6) userInfo:nil repeats:NO];
}

-(IBAction)blk7BUT:(id)sender{
    //button 7 pressed
    box7image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"7";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut7) userInfo:nil repeats:NO];
}

-(IBAction)blk8BUT:(id)sender{
    //button 8 pressed
    box8image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"8";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut8) userInfo:nil repeats:NO];
}

-(IBAction)blk9BUT:(id)sender{
    //button 9 pressed
    box9image.backgroundColor=currentShowColour;
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self playMyEffect];
    guess[pressNo+1]=@"9";
    blkNoLBL.text = [NSString stringWithFormat:@"%i",pressNo+1];
    [self statusUpdate:pressNo+1];
    pressNo=pressNo+1;
    if(pressNo >= xcounter-1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval: flash2 target:self selector:@selector(blankMSGbut9) userInfo:nil repeats:NO];
}

-(void)getGuesses {
    [self buttonsEnable];
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }

    NSLog(@"Press The Blocks in Order");
    
    if(pressNo >= xcounter+1){
        pressNo=0;
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(blankMSG3) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)getFinalGuesses {
    [self buttonsEnable];
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    //turns on the buttons, collects the xcounter guesses, forms a string, saves it and carries on with next stage
    if (infoShow) {
        statusMessageLBL.text = @"Recall The Sequence, touch the blocks.";
    }else{
        statusMessageLBL.text = @"Recall";
    }
    NSLog(@"Press The Blocks in Order");
   
    if((pressNo >= xcounter+1)&&(isFinished==YES)){
        [self buttonsDisable];
        [NSTimer scheduledTimerWithTimeInterval: (messageTime/2) target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(self) userInfo:nil repeats:NO];
    }
}

-(void)guessMSG {
    blkNoLBL.text = [NSString stringWithFormat:@"%i",0];
    NSLog(@"Guess Now");

        statusMessageLBL.text = @"";

    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getGuesses) userInfo:nil repeats:NO];
}

-(void)finalGuessMSG {
        blkNoLBL.text = [NSString stringWithFormat:@"%i",0];

        statusMessageLBL.text = @"";

    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(getFinalGuesses) userInfo:nil repeats:NO];
}

-(void)stageEndMSG {
    [self buttonsDisable];
    NSLog(@"Stage Ending");
    if (infoShow) {
        statusMessageLBL.text = @"";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(guessMSG) userInfo:nil repeats:NO];
}

-(void)finalStageEndMSG {
    [self buttonsDisable];
    NSLog(@"Final Stage Ending");
    isFinished=YES;
    if (infoShow) {
        statusMessageLBL.text = @"";
    }else{
        statusMessageLBL.text = @"";
    }
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(finalGuessMSG) userInfo:nil repeats:NO];
}

-(void)nextStageMSG {
    [self buttonsDisable];
    NSLog(@"Stage Starting");
    if (infoShow) {
        statusMessageLBL.text = @"Observe the Blocks";
    }else{
        statusMessageLBL.text = @"Observe";
    }
    pressNo=0;
    [NSTimer scheduledTimerWithTimeInterval: messageTime target:self selector:@selector(blankMSG) userInfo:nil repeats:NO];
}

-(void)startTestMSG {
    //Start of Test Message
    [self buttonsDisable];
    NSLog(@"Start Test");

    if (reverseTest) {
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the reverse order.";
        }else{
            statusMessageLBL.text = @"Reverse Test";
        }
    }else{
        if (infoShow) {
            statusMessageLBL.text = @"Observe the sequence, recall in the same order.";
        }else{
            statusMessageLBL.text = @"Forward Test";
        }
    }
    [MessageView setImage: card[0].image];
    MessageView.hidden=YES;
    [self animateMessageView];
   
    [NSTimer scheduledTimerWithTimeInterval: 5 target:self selector:@selector(blankMSG2) userInfo:nil repeats:NO];
}

-(void)animateMessageView{
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(animateMessageViewIN) userInfo:nil repeats:NO];
}

-(void)animateMessageViewIN{
    MessageView.alpha = 0.0;
    MessageView.hidden=NO;
    [[MessageView superview] bringSubviewToFront:MessageView];
    
    //[UIView animateKeyframesWithDuration:1 delay:1 options:1 animations:^(){MessageView.alpha = 1.0;} completion:nil];
    [UIView animateWithDuration:1
                          delay:0  /* do not add a delay because we will use performSelector. */
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         MessageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animateMessageViewOUT) userInfo:nil repeats:NO];
                                          }];
    [UIView commitAnimations];
    
}

-(void)animateMessageViewOUT{
    
    [[MessageView superview] bringSubviewToFront:MessageView];

    [UIView animateWithDuration:1
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         if (isCalculating) {
                             MessageView.alpha = 1.0;
                         }else{
                             MessageView.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [UIView commitAnimations];
    //[MessageView removeFromSuperview];
}

-(void)endTestMSG {
    //End of Test Message
    [self buttonsDisable];
    NSLog(@"End Test");
    stopTestNowBTN.hidden=YES;
    isFinished=YES;
    if (infoShow) {
        statusMessageLBL.text = @"The test has now finished.";
    }else{
        statusMessageLBL.text = @"Finished";
    }
    [self hideInfo];
    [self hide_blocks];
    [MessageView setImage: card[1].image];
    MessageView.hidden=NO;
    [self animateMessageView];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(calculatingMSG) userInfo:nil repeats:NO];
}

-(void)calculatingMSG {
    //Calculate stats and outputs
    [self buttonsDisable];
    isFinished=YES;
    NSLog(@"Calculating Test Results");
    if (infoShow) {
      statusMessageLBL.text = @"The test results are being calculated.";
    }else{
        statusMessageLBL.text = @"";
    }
    [self hide_blocks];
    [self hideInfo];
    [MessageView setImage: card[4].image];
    MessageView.hidden=NO;
    [self animateMessageView];

    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(calculations) userInfo:nil repeats:NO];
}

-(void)blankMSG {
    [self buttonsDisable];
    NSLog(@"(blankmsg)");
    MessageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
}

-(void)blankMSG2 {
    [self buttonsDisable];
    NSLog(@"(blankmsg2)");
    [self display_blocks];
    MessageView.hidden=YES;//maybe messagetime--v
    [NSTimer scheduledTimerWithTimeInterval:startTime target:self selector:@selector(box1) userInfo:nil repeats:NO];
}

-(void)jumpToResultsView {
    [self buttonsDisable];
    NSLog(@"(jumpToResultsView)");
    [self hide_blocks];
    [MessageView setImage: card[6].image];
    MessageView.hidden=NO;
    isCalculating=YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self animateMessageView];

    //jump to selector ResultsVC
    //[self.tabBarController setSelectedIndex:4]; needs to be able to jump as well
    //manual selection at present on tab bar
}

-(void)blankMSG3 {
    [self buttonsDisable];
    guessStr[xcounter-1]= [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",guess[1],guess[2],guess[3],guess[4],guess[5],guess[6],guess[7],guess[8],guess[9]];
    [self statusUpdate:xcounter-1];
    NSLog(@"(blank3 after buttons input %@)",guessStr[xcounter-1]);
    [self display_blocks];
    MessageView.hidden=YES;
    if (isFinished) {
        NSLog(@"(blank3 endtestmsg)");
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endTestMSG) userInfo:nil repeats:NO];
    }else{
        NSLog(@"(blank3 stagechecks)");
        statusMessageLBL.text = @"";
        [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(stageChecks) userInfo:nil repeats:NO];
    }
}

-(float)random9
{
    float num = 1;
    for (int r=1; r<+arc4random_uniform(321); r++)
        {
        while (num>0)
            {
            num = arc4random_uniform(10); //1-9
            }
        }
    return num;
}

-(int)random22
{
    int num1 = 1;
            num1 = arc4random_uniform(22); //1-21
    if (num1<1) {
        num1=1;
    }
    if (num1>21) {
        num1=21;
    }
    return num1;
}

-(int)randomPt
{
    mySingleton *singleton = [mySingleton sharedSingleton];
    int range1;
    
    switch ((int)singleton.blockSize) {
        case 10:
            range1=45;
            break;
        case 15:
            range1=40;
            break;
        case 20:
            range1=35;
            break;
        case 25:
            range1=30;
            break;
        case 30:
            range1=25;
            break;
        case 35:
            range1=20;
            break;
        case 40:
            range1=15;
            break;
        case 45:
            range1=10;
            break;
        case 50:
            range1=7;
            break;
        case 55:
            range1=5;
            break;
        default:
            range1=5;
            break;
    }
    float split1=0;
    if (arc4random_uniform(11)>5.5)
        {
        split1=-1;
        }
    else
        {
        split1=1;
        }
    
    int posrand=0;
    
    posrand=(float)arc4random_uniform(range1)*split1;
    
    NSLog(@"Random Pt:%i",posrand);
    //*********************************************
    return posrand;
}

-(void)updateBlockColours{
    mySingleton *singleton = [mySingleton sharedSingleton];

    currentBlockColour     = singleton.currentBlockColour;
    currentBackgroundColour= singleton.currentBackgroundColour;
    currentShowColour      = singleton.currentShowColour;

    self.testViewerView.backgroundColor=singleton.currentBackgroundColour;

    self.box1image.backgroundColor=currentBlockColour;
    self.box2image.backgroundColor=currentBlockColour;
    self.box3image.backgroundColor=currentBlockColour;
    self.box4image.backgroundColor=currentBlockColour;
    self.box5image.backgroundColor=currentShowColour;
    self.box6image.backgroundColor=currentBlockColour;
    self.box7image.backgroundColor=currentBlockColour;
    self.box8image.backgroundColor=currentBlockColour;
    self.box9image.backgroundColor=currentBlockColour;
}

-(NSString*)getCurrentDate{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yy"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];

    return retStr;
}

-(NSString*)getCurrentTime{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];

    return retStr;
}
-(void)calculations{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSLog(@"Calculations have started.");

    //clear arrays for results strings
    [singleton.resultStringRows removeAllObjects];
    [singleton.resultStringRows removeAllObjects];

    //clear output strings
    singleton.resultStrings=@"";
    singleton.displayStrings=@"";

    singleton.testTime=[self getCurrentTime];
    singleton.testDate=[self getCurrentDate];

    NSLog(@"Results array cleared, new results ready..");
    
    NSLog(@"String 1 was:%@, your guess:%@",order[1],guessStr[1]);
    NSLog(@"String 2 was:%@, your guess:%@",order[2],guessStr[2]);
    NSLog(@"String 3 was:%@, your guess:%@",order[3],guessStr[3]);
    NSLog(@"String 4 was:%@, your guess:%@",order[4],guessStr[4]);
    NSLog(@"String 5 was:%@, your guess:%@",order[5],guessStr[5]);
    NSLog(@"String 6 was:%@, your guess:%@",order[6],guessStr[6]);
    NSLog(@"String 7 was:%@, your guess:%@",order[7],guessStr[7]);
    NSLog(@"String 8 was:%@, your guess:%@",order[8],guessStr[8]);
    NSLog(@"String 9 was:%@, your guess:%@",order[9],guessStr[9]);

    NSString * tempString;
    NSString * tempString2;
    NSString * tempString3;
    NSString * tempString4;

    int cor;
    int wro;
    int totcor=0;
    int totwro=0;

    NSString *ee;
    NSString *ff;

    //headers
    tempString=[NSString stringWithFormat:@"Corsi Block Tapping Test Results"];
    [singleton.resultStringRows addObject: tempString];
    [singleton.displayStringRows addObject: tempString];

    tempString=[NSString stringWithFormat:@""];
    [singleton.displayStringRows addObject:tempString];
    [singleton.resultStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@"Date: %@, Time: %@", singleton.testDate, singleton.testTime];
    tempString2=[NSString stringWithFormat:@"Test Date: %@, Test Time: %@", singleton.testDate, singleton.testTime];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString2];

    tempString=[NSString stringWithFormat:@""];
    [singleton.displayStringRows addObject:tempString];
    [singleton.resultStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@"Tester:     %@", singleton.testerName];
    [singleton.resultStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Participant:%@", singleton.subjectName];
    [singleton.resultStringRows addObject:tempString];

    tempString2=[NSString stringWithFormat:@"Tester Name:       %@", singleton.testerName];
    [singleton.displayStringRows addObject:tempString2];
    tempString2=[NSString stringWithFormat:@"Participant Code: %@", singleton.subjectName];
    [singleton.displayStringRows addObject:tempString2];

    tempString=[NSString stringWithFormat:@""];
    [singleton.displayStringRows addObject:tempString];
    [singleton.resultStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@"Message Time: %2.0f ms",singleton.startTime];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"   Wait Time: %2.0f ms",singleton.waitTime];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"   Show Time: %2.0f ms",singleton.showTime];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@"Canvas: %@",[self colourUIToString:(singleton.currentBackgroundColour)]];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Block:    %@",[self colourUIToString:(singleton.currentBlockColour)]];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Show:    %@",[self colourUIToString:(singleton.currentShowColour)]];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    NSString *rot;
    NSString *ani;
    NSString *forw;
    NSString *beep;
    NSString *beep2;

    NSString *ans;
    NSString *ans2;
    
    if (singleton.animals) {
        ani=@"YES, Random";
    }else{
        ani=@"NO, Plain";
    }
    if (singleton.blockRotation) {
        rot=@"YES, Random";
    }else{
        rot=@"NO, 90 degrees";
    }
    if (singleton.forwardTestDirection) {
        forw=@"YES, Normal Test";
    }else{
        forw=@"NO, Reverse Test";
    }
    if (singleton.sounds) {
        beep=@"Beep ON";
        beep2=singleton.beepEffect;
    }else{
        beep=@"Beep Off";
        beep2=@"(none)";
    }
    beep2=singleton.beepEffect;

    tempString=[NSString stringWithFormat:@"Forward Test:   %@", forw];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Block Size:       %2.0f",singleton.blockSize];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Block Rotation: %@",rot];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Block Animals:  %@", ani];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Beep Que         %@", beep];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"Beep Name       %@", beep2];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];


    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];


    tempString=[NSString stringWithFormat:@"(1 = correct number in correct sequence, 0 = wrong number in sequence)"];
    [singleton.displayStringRows addObject:tempString];
    [singleton.resultStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@""];
    [singleton.displayStringRows addObject:tempString];
    [singleton.resultStringRows addObject:tempString];


    tempString=[NSString stringWithFormat:@"Test No,Sequence,Response,1,2,3,4,5,6,7,8,9,Correct,Wrong"];
    tempString2=[NSString stringWithFormat:@"Test No                 _ 1_ 2_ 3_ 4_ 5_ 6_ 7_ 8_ 9_ C_ W"];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString2];

    //body of results
    //reset tempstring before building a line of data
    tempString=@"";

    //loop for test no
    for (int xx=start; xx<finish+1; xx++) {
        //for stage no
    //add a few blanks to the strings to enable it to run over the 9 chars
            order[xx]=[order[xx] stringByAppendingString:@"xxx"];
            guessStr[xx]=[guessStr[xx] stringByAppendingString:@"xxx"];
        //for order and guess
        if (xx<finish){
            tempString3 = [NSString stringWithFormat:@"%d", xx-2];
            tempString4 = [NSString stringWithFormat:@" _ %d __  ", xx-2];
        }
        ee=[order[xx] substringWithRange:NSMakeRange(0, xx)];
        ff=[guessStr[xx] substringWithRange:NSMakeRange(0, xx)];

        tempString = [NSString stringWithFormat:@"%@,%@,%@", ee, ff,tempString3];
        tempString2 = [NSString stringWithFormat:@"%@ _ %@_%@",ee, ff,tempString4];
        cor=0;
        wro=0;
        ans=@"";
        ans2=@"";

        //loop for test in line
        for (int q=0; q<xx; q++) {
            //swap order for the reverse order if that was selected
            if (!singleton.forwardTestDirection) {
                order[q]=reverse[q];
            }



            //get the character at a position in the strings
            ee=[order[xx] substringWithRange:NSMakeRange(q, 1)];
            ff=[guessStr[xx] substringWithRange:NSMakeRange(q, 1)];
            
            //check for same digits in order and guess and count
            if ([ee isEqualToString: ff]) {
                cor=cor+1;
                totcor=totcor+1;
                ans=@"1";
                ans2=@" _ 1";
            }else{
                wro=wro+1;
                totwro=totwro+1;
                ans=@"0";
                ans2=@" _ 0";
            }
            //put the individual components csv in string
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@",%@", ans]];
            tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@"%@", ans2]];
        }

        //add some commas
        for (int y=1; y<11-xx; y++) {
            tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@","]];
            tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@" _  "]];
        }
        
        //finish off string from loop
        tempString = [NSString stringWithFormat:@"%@%@", tempString, [NSString stringWithFormat:@"%d,%d", cor, wro]];
        tempString2 = [NSString stringWithFormat:@"%@%@", tempString2, [NSString stringWithFormat:@"_ %d _ %d", cor, wro]];
        [singleton.resultStringRows addObject:tempString];
        [singleton.displayStringRows addObject:tempString2];

        //blankline
        tempString=[NSString stringWithFormat:@""];
        [singleton.resultStringRows addObject:tempString];
        [singleton.displayStringRows addObject:tempString];

    }
    //blankline
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    //put final totals
    tempString=[NSString stringWithFormat:@"Total Possible = %d", totcor+totwro];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    //blankline
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    tempString=[NSString stringWithFormat:@"Total Correct = %d, Total Wrong = %d",totcor, totwro];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    //end of results save
    tempString=[NSString stringWithFormat:@""];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    //end
    tempString=[NSString stringWithFormat:@"End of Corsi Test Results"];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    //blank
    tempString=[NSString stringWithFormat:@"(c) MMU 2014 EES"];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];
    tempString=[NSString stringWithFormat:@"- www.ess.mmu.ac.uk/apps/corsi"];
    [singleton.resultStringRows addObject:tempString];
    [singleton.displayStringRows addObject:tempString];

    //jump to the results page
    [NSTimer scheduledTimerWithTimeInterval: 0 target:self selector:@selector(jumpToResultsView) userInfo:nil repeats:NO];
}

-(void)setColours{
    mySingleton *singleton = [mySingleton sharedSingleton];
    testViewerView.backgroundColor=singleton.currentBackgroundColour;
    currentBackgroundColour = singleton.currentBackgroundColour;
    currentBlockColour      = singleton.currentBlockColour;
    currentShowColour       = singleton.currentShowColour;

    currentStatusColour     = singleton.currentStatusColour;
    statusMessageLBL.textColor=currentStatusColour;
    statusMessageLBL.alpha=0.70;

    if (singleton.onScreenInfo) {
        blkNoLBL.textColor      = singleton.currentStatusColour;
        blkLBL.textColor        = singleton.currentStatusColour;
        blkOfLBL.textColor      = singleton.currentStatusColour;
        blkTotalLBL.textColor   = singleton.currentStatusColour;
        setLBL.textColor        = singleton.currentStatusColour;
        setNoLBL.textColor      = singleton.currentStatusColour;
        setOfLBL.textColor      = singleton.currentStatusColour;
        setTotalLBL.textColor   = singleton.currentStatusColour;
    } else {
        blkNoLBL.textColor      = singleton.currentBackgroundColour;
        blkLBL.textColor        = singleton.currentBackgroundColour;
        blkOfLBL.textColor      = singleton.currentBackgroundColour;
        blkTotalLBL.textColor   = singleton.currentBackgroundColour;
        setLBL.textColor        = singleton.currentBackgroundColour;
        setNoLBL.textColor      = singleton.currentBackgroundColour;
        setOfLBL.textColor      = singleton.currentBackgroundColour;
        setTotalLBL.textColor   = singleton.currentBackgroundColour;
    }
}

-(NSString*)colourUIToString:(UIColor*)myUIColour{
    NSString * myColour;

    //make an array of colour names
    NSArray *items = @[
                       [UIColor blackColor],
                       [UIColor blueColor],
                       [UIColor greenColor],
                       [UIColor redColor],
                       [UIColor cyanColor],
                       [UIColor whiteColor],
                       [UIColor yellowColor],
                       [UIColor magentaColor],
                       [UIColor grayColor],
                       [UIColor orangeColor],
                       [UIColor brownColor],
                       [UIColor purpleColor],
                       [UIColor darkGrayColor],
                       [UIColor lightGrayColor]
                       ];
    //find the index value of each
    long item = [items indexOfObject: myUIColour];

    //select the item number
    switch (item) {
        case 0:
            // Item 1
            myColour = @"Black";
            break;
        case 1:
            // Item 2
            myColour = @"Blue";
            break;
        case 2:
            // Item 3
            myColour = @"Green";
            break;
        case 3:
            // Item 4
            myColour = @"Red";
            break;
        case 4:
            // Item 5
            myColour = @"Cyan";
            break;
        case 5:
            // Item 6
            myColour = @"White";
            break;
        case 6:
            // Item 7
            myColour = @"Yellow";
            break;
        case 7:
            // Item 8
            myColour = @"Magenta";
            break;
        case 8:
            // Item 9
            myColour = @"Grey";
            break;
        case 9:
            // Item 10
            myColour = @"Orange";
            break;
        case 10:
            // Item 11
            myColour = @"Brown";
            break;
        case 11:
            // Item 12
            myColour = @"Purple";
            break;
        case 12:
            // Item 13
            myColour = @"Dark Grey";
            break;
        case 13:
            // Item 14
            myColour = @"Light Grey";
            break;
        default:
            myColour = @"Orange";
            break;
    }
    return myColour;
}
@end
