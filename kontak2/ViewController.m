//
//  ViewController.m
//  kontak2
//
//  Created by Jens Andersen on 23/07/14.
//  Copyright (c) 2014 com.appcoda. All rights reserved.
//

#import "ViewController.h"
#import "BeaconManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.client = [KTKClient new];
        [self.client setApiKey:@"xxxxxxx"];
        
        NSError *error = nil;
        NSDictionary *venuesDictionary = [self.client getVenuesChangedSince:0 error:&error];
	    //AW God stil altid at tjekke error
	    if(error) {
		    //Something went wrong
		    NSLog(@"Error getting venues: %@",error);
	    }


        NSArray *addedVenues = venuesDictionary[kKTKAdded];

	    error = nil;
        NSArray *getRegionsError = [self.client getRegionsError:&error];
	    if (error) {
		    NSLog(@"Error getting regions: %@",error);
	    }
	    else {
		    NSLog(@"getRegionsError %@", getRegionsError);
	    }

        dispatch_sync(dispatch_get_main_queue(), ^{
	        NSError *error1 = nil;
            NSDictionary *beaconData = [self.client getBeaconsForVenues:addedVenues changedSince:0 error:&error1];
	        if(error1) {
		        NSLog(@"Error getting beacons for venues: %@",error1);
	        }
	        else {
		        NSLog(@"addedVenues: %@", addedVenues);
		        NSLog(@"beaconData %@", beaconData);
	        }
        });
    });

	//AW Sådan sætter du regions op.
	NSError *error;
	NSArray *regions = [self.client getRegionsError:&error];

	if ([KTKLocationManager canMonitorBeacons]) {
        self.locationManager = [KTKLocationManager new];
        self.locationManager.delegate = self;
        [self.locationManager setRegions:regions];
        [self.locationManager startMonitoringBeacons];
    }
    _beaconManager = [BeaconManager new];
    [_beaconManager startFindingDevices];

	[self.beaconManager reloadDevices]; //Tells the manager to forget all devices and start searching again.
    


}

- (KTKBeaconManager *)beaconManager {
	//Lazy loading, så første gang du skal bruge den, bliver den sat op automatisk
	if(!_beaconManager) {
		_beaconManager = [BeaconManager new];
		_beaconManager.delegate = self;
	}
	return _beaconManager;
}

- (KTKActionManager *)actionManager {

	//Lazy loading, så første gang du skal bruge den, bliver den sat op automatisk
	if(!_actionManager) {
		_actionManager = [[KTKActionManager alloc] init];
		_actionManager.delegate = self;
	}
	return _actionManager;
}


#pragma mark - KTKLocationManagerDelegate method

- (void)locationManager:(KTKLocationManager *)locationManager
        didRangeBeacons:(NSArray *)beacons {
    
    // Det dette her jeg ikke kan få til at virke, jeg vil gerne have denne action fra kontakt.io webpanel
    // men jeg får aldrig denne her - (void)locationManager: til at starte
    
    NSLog(@"didRangeBeacons");
    
    NSMutableDictionary *beaconsData = [NSMutableDictionary new];
    for (CLBeacon *beacon in beacons) {
	    //AW _getDataForBeacon returnerer et NSDictionary, og du regner vist med et KTKBeacon object
        KTKBeacon *beaconData = [self _getDataForBeacon:beacon];
        if (beaconData) beaconsData[beacon] = beaconData;
    }
    [self.actionManager processBeacons:beacons withData:beaconsData];
}

// Det var noget jeg fandt på nettet, men ved ikke om det er den måde man får fat i action på?
-(NSDictionary *)_getDataForBeacon:(CLBeacon *)beacon
{
	NSLog(@"%@",beacon);

	//AW Har ændret til at den spørger kontakt.io om den specifikke beacon i stedet for en hardcodet som der stod.
	NSData * jsonData = [NSData dataWithContentsOfURL:[NSURL
			URLWithString:[NSString
					stringWithFormat:@"https://api.kontakt.io/beacon?proximity=%@&major=%@&minor=%@",
					                 beacon.proximityUUID,
					                 beacon.major,
					                 beacon.minor]
	]];
    NSError * error=nil;
    NSDictionary *dic = [NSJSONSerialization
                         JSONObjectWithData:jsonData options:0 error:&error];
    NSLog(@"%@",dic);
    
    NSArray *array = @[beacon];
	error = nil;
    NSDictionary *data = [self.client getActionsForBeacons:array changedSince:0 error:&error]; //##It crashes here##

	//AW Error check
	if(error) {
		NSLog(@"Error getActionsForBeacons: %@",error);
		return nil; //Bail out
	}
    NSLog(@"%@",data);
    
    return data;
}

- (void)locationManager:(KTKLocationManager *)locationManager didExitRegion:(KTKRegion *)region
{
    NSLog(@"didExitRegion %@", region.uuid);
}

- (void)locationManager:(KTKLocationManager *)locationManager didEnterRegion:(KTKRegion *)region
{
    NSLog(@"didEnterRegion %@", region);
}

- (void)locationManager:(KTKLocationManager *)locationManager didChangeState:(KTKLocationManagerState)state withError:(NSError *)error
{
    NSLog(@"didChangeState");
}

- (void)bluetoothManager:(KTKBluetoothManager *)bluetoothManager didChangeDevices:(NSSet *)devices {
	     //TODO
}


@end
