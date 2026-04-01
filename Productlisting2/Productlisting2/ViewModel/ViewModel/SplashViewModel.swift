//
// SplashViewModel.swift
// ShopApp
//
// Created by Mac Mini on 26/03/2026.
//
import Foundation
import Combine

final class SplashViewModel: ObservableObject {
@Published var shouldNavigate = false
func start() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
        self?.shouldNavigate = true
    }
}
}
