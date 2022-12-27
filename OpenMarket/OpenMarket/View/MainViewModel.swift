//
//  MainViewModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
  @Published var currentTab: Tab = .home
  @Published var currentMenu: String = "All"
}
 
