//
//  Init_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 26.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "Init_ViewController.h"
#import "Start_Stop_Searching.h"
#import "Media_TableViewController.h"
#import "OtherFunctions.h"
#import "MediaServer1Device.h"
#import "BasicUPnPService.h"
#import "StateVariableRange.h"
#import "StateVariableList.h"
#import "StateVariableRangeList.h"
#import "ContentDirectory.h"
#import "AVTransport.h"

@interface Init_ViewController ()

@end

@implementation Init_ViewController
{
    Start_Stop_Searching *UPnPInit;
    
    NSTimer *refreshTimer;
}

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
    // Do any additional setup after loading the view.
    
    // start searching upnp devices
    UPnPInit = [[Start_Stop_Searching alloc] init];
    [UPnPInit startUPnPDeviceSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)btnChooseServer:(id)sender
{
    [self saveGlobalVars];
    [self performSegueWithIdentifier:@"server" sender:self];
}

- (IBAction)btnChooseRenderer:(id)sender
{
    [self saveGlobalVars];
    [self performSegueWithIdentifier:@"renderer" sender:self];
}

- (IBAction)btnContentView:(id)sender
{
    [self saveGlobalVars];
    [self performSegueWithIdentifier:@"content" sender:self];
}

- (IBAction)btnControllPlayer:(id)sender
{
    [self saveGlobalVars];
    [self performSegueWithIdentifier:@"control" sender:self];
}

- (IBAction)btnRefresh:(id)sender
{
    [UPnPInit refreshUPnPDeviceSearch];
}

- (IBAction)btnShowGLBVars:(id)sender
{
    /*
    // get min & max values
    NSLog(@"Volume: %@", [StateVariableRangeList getVolumeMinMax]);
    NSLog(@"Channel: %@", [StateVariableRangeList getChannelList]);
    NSLog(@"VolumeDB: %@", [StateVariableRangeList getVolumeDBMinMax]);
     */
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"content"])
    {
        Media_TableViewController *controller = segue.destinationViewController;
        controller.rootID = @"0";
        controller.header = @"root";
    }
}

#pragma mark - other Functions

- (void)saveGlobalVars
{
    // save servers, renderer, devices
    GLB.upnpServers = [UPnPInit.upnpServers copy];
    GLB.upnpRenderer = [UPnPInit.upnpRenderer copy];
    GLB.upnpDevices = [UPnPInit.upnpDevices copy];
}

@end
