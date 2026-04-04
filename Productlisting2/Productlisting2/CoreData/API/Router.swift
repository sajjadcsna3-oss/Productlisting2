//
//  Router.swift
//  Productlisting2
//
//  Created by Mac Mini on 02/04/2026.
//
import Foundation
import SwiftUI
import Combine

final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
