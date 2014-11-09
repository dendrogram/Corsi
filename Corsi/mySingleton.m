//
//  mySingleton.m
//  Corsi
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
    
}

// eg::: @synthesize offset;
@synthesize
            currentShowColour,
            currentBlockColour,
            currentBackgroundColour,
            currentStatusColour,
            blockSize,
            bl1,
            bl2,
            bl3,
            bl4,
            bl5,
            bl6,
            bl7,
            bl8,
            bl9,
            showTime,
            start,
            startTime,
            finish,
            timerTime,
            waitTime,
            messageTime,
            oldSubjectName,
            subjectName,
            testerName,
            testDate,
            testTime,
            resultStrings,
            resultStringRows,
            email,
            forwardTestDirection,
            blockRotation,
            onScreenInfo,
            animals,
            sounds,
            beepEffect,
            displayStringRows,
            displayStrings,
            segIndex;

#pragma mark -
#pragma mark Singleton Methods

+ (mySingleton *) sharedSingleton {
    if(sharedSingleton==nil) {
        sharedSingleton = [[super allocWithZone:NULL]init];
    }
    return sharedSingleton;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedSingleton];
}

- (id)copyWithZone:(NSZone *) zone {
    return self;
}

- (id) init {
    if(self = [super init]) {
        
        //eg:::       offset=30;
        currentBackgroundColour = [UIColor blackColor];
        currentBlockColour = [UIColor darkGrayColor];
        currentShowColour  = [UIColor orangeColor];
        currentStatusColour= [UIColor yellowColor];
        start       = 3;
        finish      = 9;
        blockSize   = 40.00;
        blockSize   = 30.00;
        waitTime    = 1500;
        startTime   = 1500;
        showTime    = 600;
        messageTime = 2000; //for on screen instructions and messages in time interval delay
        timerTime   = 0.0;
        blockRotation = YES;
        onScreenInfo  = YES;
        animals       = NO;
        sounds        = NO;
        beepEffect    = @"KLICK";
        segIndex      = 0;
        forwardTestDirection = YES;
        oldSubjectName    = @"Participant 1";
        subjectName       = @"Participant 1";
        resultStrings     = @"";
        displayStrings    = @"";
        resultStringRows  = [[NSMutableArray alloc]initWithObjects: nil];
        displayStringRows = [[NSMutableArray alloc]initWithObjects: nil];
        email             = @"test@test.com";
        }
    return self;
}
@end
