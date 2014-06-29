//
//  GlobalVars.h
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaServer1Device.h"
#import "MediaRenderer1Device.h"
#import "MediaServer1BasicObject.h"

#define GLB  [GlobalVars sharedInstance]   

@interface GlobalVars : NSObject

@property (nonatomic, strong) MediaServer1Device *server;
@property (nonatomic, strong) MediaRenderer1Device *renderer;

@property (nonatomic, strong) NSArray *upnpDevices;
@property (nonatomic, strong) NSMutableArray *upnpServers;
@property (nonatomic, strong) NSMutableArray *upnpRenderer;

@property (nonatomic, strong) MediaServer1BasicObject *currentServerBasicObject;

+ (GlobalVars *)sharedInstance;

@end
