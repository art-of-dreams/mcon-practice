//
//  Systems.swift
//  Sky (iOS)
//
//  Created by Dan Vasilev on 13.08.2022.
//

import Foundation

actor Systems {
  private(set) var systems: [ScanSystem]

  init(_ localSystem: ScanSystem) {
    systems = [localSystem]
  }

  var localSystem: ScanSystem { systems[0] }

  func addSystem(name: String, service: ScanTransport) {
    removeSystem(name: name)
    let newSystem = ScanSystem(name: name, service: service)
    systems.append(newSystem)
  }

  func removeSystem(name: String) {
    systems.removeAll { $0.name == name }
  }

  func firstAvailableSystem() async -> ScanSystem {
    while true {
      for nextSystem in systems where await nextSystem.count < 4 {
        await nextSystem.commit()
        return nextSystem
      }
      await Task.sleep(seconds: 0.1)
    }
    fatalError("Will never execute")
  }
}
