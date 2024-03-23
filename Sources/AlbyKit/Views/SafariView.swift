//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Rademaker on 12/14/23.
//

import SwiftUI
@preconcurrency import SafariServices

public struct SafariView: UIViewControllerRepresentable, Sendable {
    let url: URL
    var delegate: SFSafariViewControllerDelegate?
    var preferredControlerTintColor: UIColor?
    var preferredBarTintColor: UIColor?
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = delegate
        safariVC.preferredControlTintColor = preferredControlerTintColor
        safariVC.preferredBarTintColor = preferredBarTintColor
        return safariVC
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Update the controller if needed.
    }
}
