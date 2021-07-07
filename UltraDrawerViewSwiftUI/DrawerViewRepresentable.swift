//
//  DrawierViewRepresentable.swift
//  TestDrawerView
//
//  Created by Admin on 23/02/2021.
//

import UIKit
import SwiftUI
import UltraDrawerView

enum Layout {
    static let topInsetPortrait: CGFloat = 0
    static let topInsetLandscape: CGFloat = 30
    static let middleInsetFromBottom: CGFloat = 280
    static let headerHeight: CGFloat = 64
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Float = 0.2
    static let shadowOffset = CGSize.zero
}

struct DrawerViewRepresentable<Header: View, Content: View>: UIViewRepresentable {
    //@Binding var top: CGFloat
    var header: () -> Header
    var content: () -> Content
    var uiScrollView: UIScrollView
    var headerView: Header { header() }
    var contentView: Content { content() }
    var listener: Listener
    @State var changed: Bool
    @State var scrollViewObservations: [NSKeyValueObservation]
    
    init(header: @escaping () -> Header, content: @escaping () -> Content) {
        self.header = header
        self.content = content
        uiScrollView = UIScrollView()
        listener = Listener(uiScrollView: uiScrollView)
        _scrollViewObservations = State(initialValue: [])
        _changed = State(initialValue: false)
        
    }
    func change() {
        print("changement")
        changed.toggle()
    }
    func makeUIView(context: Context) -> some DrawerView {
        let hostingHeader = UIHostingController(rootView: headerView)
        hostingHeader.view.translatesAutoresizingMaskIntoConstraints = false
        hostingHeader.view.heightAnchor.constraint(equalToConstant: Layout.headerHeight).isActive = true

        let hosting = UIHostingController(rootView: contentView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.addSubview(hosting.view)
        let constraints = [
            hosting.view.leadingAnchor.constraint(equalTo: uiScrollView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: uiScrollView.trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.bottomAnchor),
            hosting.view.widthAnchor.constraint(equalTo: uiScrollView.widthAnchor)
        ]
        uiScrollView.addConstraints(constraints)
        uiScrollView.contentSize = hosting.view.intrinsicContentSize
        
        let dView = DrawerView(scrollView: uiScrollView, delegate: context.coordinator, headerView: hostingHeader.view)
        dView.middlePosition = .fromBottom(Layout.middleInsetFromBottom)
        dView.topPosition = .fromTop(Layout.topInsetPortrait)
        dView.cornerRadius = Layout.cornerRadius
        dView.containerView.backgroundColor = .white
        dView.layer.shadowRadius = Layout.shadowRadius
        dView.layer.shadowOpacity = Layout.shadowOpacity
        dView.layer.shadowOffset = Layout.shadowOffset
        dView.setState(.middle, animated: false)
        dView.addListener(listener)
        dView.content.addListener(listener)
        //dView.content.removeListener(dView)
        return dView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //uiScrollView = UIScrollView()
       
        let hosting = UIHostingController(rootView: contentView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.subviews.forEach({ $0.removeFromSuperview() })
        uiScrollView.addSubview(hosting.view)

        let constraints = [
            hosting.view.leadingAnchor.constraint(equalTo: uiScrollView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: uiScrollView.trailingAnchor),
            hosting.view.topAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: uiScrollView.contentLayoutGuide.bottomAnchor),
            hosting.view.widthAnchor.constraint(equalTo: uiScrollView.widthAnchor)
        ]
        uiScrollView.addConstraints(constraints)


        uiScrollView.addObserver(context.coordinator, forKeyPath: "contentSize",
                                 options: .new,
                                 context: nil)
        let orientation = UIDevice.current.orientation
        
        if orientation.isLandscape {
            print("landscape")
            uiView.topPosition = .fromTop(Layout.topInsetLandscape)
            uiView.availableStates = [.top, .bottom]
        } else if orientation.isPortrait {
            uiView.topPosition = .fromTop(Layout.topInsetPortrait)
            uiView.availableStates = [.top, .middle, .bottom]
        }
        //uiView.setState(.bottom, animated: false)
        uiView.addListener(listener)
        uiView.content.addListener(listener)
        //uiView.content.removeListener(uiView)
        print("update : \(uiView.origin)")

        //uiView.
    }
    
    func makeCoordinator() -> some DrawerViewCoordinator<Header,Content> {
        return DrawerViewCoordinator(parent: self)
    }
    
//    private var drawerView: DrawerView!
//    private var isFirstLayout = true
//    private var portraitConstraints: [NSLayoutConstraint] = []
//    private var landscapeConstraints: [NSLayoutConstraint] = []
    
//    private func setupLayout() {
//        drawerView.translatesAutoresizingMaskIntoConstraints = false
//
//        portraitConstraints = [
//            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
//            drawerView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            drawerView.rightAnchor.constraint(equalTo: view.rightAnchor),
//        ]
//
//        let landscapeLeftAnchor: NSLayoutXAxisAnchor
//        if #available(iOS 11.0, *) {
//            landscapeLeftAnchor = view.safeAreaLayoutGuide.leftAnchor
//        } else {
//            landscapeLeftAnchor = view.leftAnchor
//        }
//
//        landscapeConstraints = [
//            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
//            drawerView.leftAnchor.constraint(equalTo: landscapeLeftAnchor, constant: 16),
//            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            drawerView.widthAnchor.constraint(equalToConstant: 320),
//        ]
//    }
    
//    private func updateLayoutWithCurrentOrientation() {
//        let orientation = UIDevice.current.orientation
//
//        if orientation.isLandscape {
//            portraitConstraints.forEach { $0.isActive = false }
//            landscapeConstraints.forEach { $0.isActive = true }
//            drawerView.topPosition = .fromTop(Layout.topInsetLandscape)
//            drawerView.availableStates = [.top, .bottom]
//        } else if orientation.isPortrait {
//            landscapeConstraints.forEach { $0.isActive = false }
//            portraitConstraints.forEach { $0.isActive = true }
//            drawerView.topPosition = .fromTop(Layout.topInsetPortrait)
//            drawerView.availableStates = [.top, .middle, .bottom]
//        }
//    }
}

class Listener: DrawerViewListener {
    var uiScrollView: UIScrollView
    init(uiScrollView: UIScrollView) {
        self.uiScrollView = uiScrollView
    }
    func drawerView(_ drawerView: DrawerView, willBeginUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        print("willBeginUpdatingOrigin")
    }
    
    func drawerView(_ drawerView: DrawerView, didUpdateOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        print("didUpdateOrigin : \(drawerView.origin)")
    
    }
    
    func drawerView(_ drawerView: DrawerView, didEndUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        print("didEndUpdatingOrigin")

    }
    
    func drawerView(_ drawerView: DrawerView, didChangeState state: DrawerView.State?) {
        print("didChangeState")

    }
    
    func drawerView(_ drawerView: DrawerView, willBeginAnimationToState state: DrawerView.State?, source: DrawerOriginChangeSource) {
        print("willBeginAnimationToState")

    }
    
    
}

extension Listener: DrawerViewContentListener {
    func drawerViewContent(_ drawerViewContent: DrawerViewContent, didChangeContentSize contentSize: CGSize) {
        print("lol")
    }
    
    func drawerViewContent(_ drawerViewContent: DrawerViewContent, didChangeContentInset contentInset: UIEdgeInsets) {
        
    }
    
    func drawerViewContentDidScroll(_ drawerViewContent: DrawerViewContent) {
        //print("héhéhé")
    }
    
    func drawerViewContentWillBeginDragging(_ drawerViewContent: DrawerViewContent) {
        
    }
    
    func drawerViewContentWillEndDragging(_ drawerViewContent: DrawerViewContent, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    
}

class DrawerViewCoordinator<Header: View, Content: View>: NSObject, UIScrollViewDelegate {
    var parent: DrawerViewRepresentable<Header, Content>
    init(parent: DrawerViewRepresentable<Header, Content>) {
        self.parent = parent
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("chan")
        if let obj = object as? UIScrollView,
           obj == self.parent.uiScrollView &&
                        keyPath == "contentSize" {
            parent.change()
                    }
                
    }
}

extension UIResponder {
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}
