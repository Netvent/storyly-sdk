//
//  StorylyView.swift
//  SwiftUIDemo-Storyly
//
//  Created by appsamurai appsamurai on 14.03.2023.
//
//
import Foundation
import SwiftUI
import Storyly

struct StorylySwiftUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = StorylyViewController
    var storylyToken: String
    
    func makeUIViewController(context: Context) -> StorylyViewController {
        let vc = StorylyViewController()
        vc.initStoryly(token: storylyToken)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: StorylyViewController, context: Context) { }
}
