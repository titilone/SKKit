//
//  Untitled.swift
//  OleLife
//
//  Created by Admin on 2025/2/12.
//

import Foundation
import Alamofire
import Combine

//SKNetworkReachability 使用了单例模式（static let shared），确保在整个应用中只存在一个实例。这样可以避免多个实例导致的状态不一致问题。

//在 @main 入口中，使用 @StateObject 创建 SKNetworkReachability 实例，并通过.environmentObject 注入到环境中。

//在需要访问网络状态的视图中，使用 @EnvironmentObject 获取 SKNetworkReachability 实例。
//@EnvironmentObject var reachability: SKNetworkReachability

class SKReachability: ObservableObject {
    static let shared = SKReachability() // 单例模式

    private var reachability: NetworkReachabilityManager?

    @Published var isReachable: Bool = true // 网络是否可达

    private init() {
        startListening()
    }

    // 开始监听网络状态
    private func startListening() {
        reachability = NetworkReachabilityManager.default
        reachability?.startListening { status in
            switch status {
            case .reachable(.cellular), .reachable(.ethernetOrWiFi):
                self.isReachable = true
            case .notReachable, .unknown:
                self.isReachable = false
            }
        }
    }
    
    // Whether the network is currently reachable over the cellular interface.
    func isReachableOnCellular()->Bool{
        return reachability?.isReachableOnCellular ?? false
    }
    
    // Whether the network is currently reachable over Ethernet or WiFi interface.
    func isReachableOnEthernetOrWiFi()->Bool{
        return reachability?.isReachableOnEthernetOrWiFi ?? false
    }

    // 停止监听网络状态
    func stopListening() {
        reachability?.stopListening()
    }
}
