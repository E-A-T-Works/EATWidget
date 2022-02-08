//
//  AppGroup.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 2/8/22.
//

import Foundation

public enum AppGroup: String {
  case base = "group.akropoint.EATWidget"

  public var containerURL: URL {
    switch self {
    case .base:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
