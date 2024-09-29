//
//  OConnectGroupHandler.swift
//
//
//  Created by mobileDev on 21/02/24.
//

import Foundation
import ReplayKit
class OconnectGroupHandler:NSObject {

    func checkForClosing(sampleHandler:RPBroadcastSampleHandler){
        let group=UserDefaults(suiteName: "group.com.onpassive.oconnect")
        let closeReplayKitFromFlutter=group!.bool(forKey: "closeReplayKitFromFlutter")
        if(closeReplayKitFromFlutter){
            let userInfo = [NSLocalizedFailureReasonErrorKey: "Screen Sharing has stopped"]
            sampleHandler.finishBroadcastWithError(NSError(domain: "ScreenShare", code: -1, userInfo: userInfo)
            )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.checkForClosing(sampleHandler:sampleHandler)
        }
    
    }
    func startBroadcast(sampleHandler:RPBroadcastSampleHandler){
        self.checkForClosing(sampleHandler:sampleHandler)
    }
 
}
