//
//  AppDelegate.m
//  Corsi
//
//  Created by Jon Howell on 02/09/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//  Minor updates and re-build for distro 2/11/15 jah
//  Minor updates and re-build for distro 9/9/16 jah
//

#import "AppDelegate.h"

@implementation AppDelegate{
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //start the main App with a message

    // wait while the user looks at the logos.... and enjoys them...?
    sleep(2);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Corsi Block Tapping Test"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Continue"
                                              otherButtonTitles:nil];
    
    UILabel *txtField = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 180, 230)];
    
    //[txtField setFont:[UIFont fontWithName:@"Serifa-Roman" size:(16.0f)]];
    
    txtField.numberOfLines = 8;
    txtField.textColor = [UIColor darkGrayColor];
    txtField.backgroundColor = [UIColor clearColor];
    txtField.textAlignment = NSTextAlignmentCenter;
    
    txtField.text = @"To see details on how to \nuse this Application\n and adjust its settings, \nplease read the notes in \nthe 'Information' section.\n\nThis Application is NOT \nfor clinical use. v1.4.3 - 7.2.17";

    [alertView setValue:txtField forKeyPath:@"accessoryView"]; //for ios 7 and above

    [alertView show];

    // set all labels to Serifa Font 24

    // UIFont *serifa12 = [UIFont fontWithName:@"Serifa-Roman" size:14];

    // [[UILabel appearance] setFont:serifa12];
    // [[UIButton appearance] setFont:serifa12];//ignore warning as easiest way to alter all button fonts in one go

       return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
