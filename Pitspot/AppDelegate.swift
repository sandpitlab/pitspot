//
//  AppDelegate.swift
//  Pitspot
//
//  Created by Mateusz Zatorski on 23/09/2014.
//  Copyright (c) 2014 knowbody. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
            
            let uuidString = "D57092AC-DFAA-446C-8EF3-C81AA22815B5"
            let beaconIdentifier = "SandpitLab"
            let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)
            let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
                identifier: beaconIdentifier)
            
            
            // setting up CLLocationManager for foreground and/or background ranging and monitoring
            locationManager = CLLocationManager()
            
            if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
                locationManager!.requestAlwaysAuthorization()
            }
            
            locationManager!.delegate = self
            locationManager!.pausesLocationUpdatesAutomatically = false
            
            locationManager!.startMonitoringForRegion(beaconRegion)
            locationManager!.startRangingBeaconsInRegion(beaconRegion)
            locationManager!.startUpdatingLocation()
            
            
            // on iOS7 works fine, if iOS8 then asks for permission to send notification
            // TODO: in production error handling for declined permissions should be handled
            if(application.respondsToSelector("registerUserNotificationSettings:")) {
                application.registerUserNotificationSettings(
                    UIUserNotificationSettings(
                        forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                        categories: nil
                    )
                )
            }
            
            
            return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


// defining what happens when the region is entered
extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            
//            viewController.tableView!.reloadData()
            
            
            NSLog("didRangeBeacons");
            var message:String = ""
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "Far away from the beacon"
                case CLProximity.Near:
                    message = "Near the beacon"
                case CLProximity.Immediate:
                    message = "Very close to the beacon"
                case CLProximity.Unknown:
                    return
                }
            } else {
                message = "No beacons around"
            }
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message)
            
            // message to the UI (status label)
            let viewController:ViewController = window!.rootViewController as ViewController
            viewController.statusLbl.text = message
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("In the region")
            sendLocalNotificationWithMessage("In the region")
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("Out of the region")
            sendLocalNotificationWithMessage("Out of the region")
    }
    
}

