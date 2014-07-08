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
#import "MediaServer1ContainerObject.h"

#define GLB  [GlobalVars sharedInstance]   

@interface GlobalVars : NSObject

@property (nonatomic, strong) MediaServer1Device *server;
@property (nonatomic, strong) MediaRenderer1Device *renderer;

@property (nonatomic, strong) NSArray *upnpDevices;
@property (nonatomic, strong) NSMutableArray *upnpServers;
@property (nonatomic, strong) NSMutableArray *upnpRenderer;

@property (nonatomic, strong) MediaServer1BasicObject *currentServerBasicObject;
@property (nonatomic, strong) MediaServer1ContainerObject *currentServerContainerObject;

@property (nonatomic, strong) NSArray *currentPlaylist;
@property (nonatomic, readwrite) int currentTrackNumber;

@property (nonatomic, strong) NSString *currentQueueUri;

+ (GlobalVars *)sharedInstance;

@end
