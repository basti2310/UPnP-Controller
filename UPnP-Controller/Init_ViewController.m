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
    
    //NSString *unescapedString = @"/getaa?u=x-file-cifs%3a%2f%2fMACBOOK-8016EA%2fiTunes%2fiTunes%2520Media%2fMusic%2fThe%2520Chainsmokers%2f%2523SELFIE%2f01%2520%2523SELFIE%2520(Club%2520Mix).mp3&v=7";
    //NSLog(@"// url: %@", escapedUrlString);
    
    NSString *encoded = @"http://192.168.1.136:1400/getaa?u=x-file-cifs%3a%2f%2fMACBOOK-8016EA%2fiTunes%2fiTunes%2520Media%2fMusic%2fSteve%2520Aoki%2520feat.%2520Kid%2520Cudi%2520%2526%2520Travis%2520Barker%2fWonderland%2f10%252010A%2520Cudi%2520the%2520Kid%2520(Original%2520Mix).mp3&v=7";
    NSString *decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)encoded, CFSTR(""), kCFStringEncodingUTF8);
    NSLog(@"decodedString %@", decoded);
    // http://192.168.1.136:1400/getaa?u=x-file-cifs://MACBOOK-8016EA/iTunes/iTunes%20Media/Music/Steve%20Aoki%20feat.%20Kid%20Cudi%20%26%20Travis%20Barker/Wonderland/10%2010A%20Cudi%20the%20Kid%20(Original%20Mix).mp3&v=7
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
