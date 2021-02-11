//
//  DestinationHeaderContainer.swift
//  TravelDiscovery
//
//  Created by Владимир on 10.02.2021.
//

import SwiftUI
import Kingfisher

struct DestinationHeaderContainer: UIViewControllerRepresentable {
    let imageUrlStrings: [String]
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pvc = CustomPageViewController(imageUrlStrings: imageUrlStrings)
        return pvc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

class CustomPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else { return nil }
        
        if index == 0 { return nil }
        return allControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else { return nil }
        
        if index == allControllers.count - 1 { return nil }
        return allControllers[index + 1]
    }
    
//    let firstVC = UIHostingController(rootView: Text("First VC"))
//    let secondVC = UIHostingController(rootView: Text("Second VC"))
//    let thirdVC = UIHostingController(rootView: Text("Third VC"))
//    lazy var allControllers: [UIViewController] = [
//        firstVC, secondVC, thirdVC
//    ]
    var allControllers: [UIViewController] = []
    
    init(imageUrlStrings: [String]) {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemPink
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        allControllers = imageUrlStrings.map({imageName in
            let hostingController = UIHostingController(rootView:
//                For images as url links
                    KFImage(URL(string: imageName))
                        .resizable()
                        .scaledToFill()
//                For local images assets:
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
            )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        if let first = allControllers.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            self.dataSource = self
            self.delegate = self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct DestinationHeaderContainer_Previews: PreviewProvider {
    static var previews: some View {
        DestinationHeaderContainer(imageUrlStrings: ["https://images.unsplash.com/photo-1593642532744-d377ab507dc8?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80", "https://images.unsplash.com/photo-1612877927939-1c9078b1114a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80", "https://images.unsplash.com/photo-1612934238529-206675793fe3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=975&q=80"])
            .frame(height: 300)
    }
}
