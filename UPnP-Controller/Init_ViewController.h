//
//  Init_ViewController.h
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 26.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1BasicObject.h"
#import "SonosUPNPController.h"
#import "UPNPDiscovery.h"

@interface Init_ViewController : UIViewController

@property (nonatomic, strong) UPNPController *upnpCon;
@property (nonatomic, strong) UPNPDiscovery *upnpDisc;

@property (nonatomic) BOOL controllerTag;

@end
