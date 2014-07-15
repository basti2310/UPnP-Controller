//
//  Media_TableViewController.h
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1BasicObject.h"
#import "MediaServer1Device.h"
#import "MediaRenderer1Device.h"
//#import "UPnPController.h"
#import "SonosUPnPController.h"

@interface Media_TableViewController : UITableViewController

@property (nonatomic, strong) NSString *rootID;
@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) UPNPController *upnpCon;

@property (nonatomic) int deviceType;

@end
