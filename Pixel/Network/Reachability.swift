//
//  Reachability.swift
//  Pixel
//
//  Created by Anna Zislina on 18/05/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import Foundation

class Reachability {
    
    let reachability = Reachability

    reachability.whenReachable = { reachability in
    if reachability.isReachableViaWiFi() {
     let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)

    } else {
        let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)
        }
      }
    reachability.whenUnreachable = { reachability in
    let alertController = UIAlertController(title: "Alert", message: "Not Reachable", preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    reachability.startNotifier()

}
