//
//  ControllerWahl_ViewController.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 14.07.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "ControllerWahl_ViewController.h"
#import "Init_ViewController.h"
#import "UPNPController.h"
#import "UPNPDiscovery.h"



@interface ControllerWahl_ViewController ()

@end


@implementation ControllerWahl_ViewController
{
    BOOL controllerTag;     // YES = controller1
    
    UPNPDiscovery *upnpDisc;
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
    
    upnpDisc = [UPNPDiscovery instance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)btnController1:(id)sender
{
    controllerTag = YES;
    [self performSegueWithIdentifier:@"controller" sender:self];
}

- (IBAction)btnController2:(id)sender
{
    controllerTag = NO;
    [self performSegueWithIdentifier:@"controller" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"controller"])
    {
        Init_ViewController *controller = segue.destinationViewController;
        controller.upnpDisc = upnpDisc;
        
        if (controllerTag)
        {
            controller.controllerTag = YES;
        }
        else
        {
            controller.controllerTag = NO;
        }
    }
}

@end
