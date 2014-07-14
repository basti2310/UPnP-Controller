//
//  Server_TableViewController.h
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 26.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1Device.h"

@interface Server_TableViewController : UITableViewController

@property (nonatomic, strong) NSArray *servers;
@property (nonatomic, strong) MediaServer1Device *server;

@end
