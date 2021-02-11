//
//  RestaurantCarouselView.swift
//  TravelDiscovery
//
//  Created by Владимир on 11.02.2021.
//


import SwiftUI
import Kingfisher

struct RestaurantCarouselView: UIViewControllerRepresentable {
    
    let imageUrlStrings: [String]
    let selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pvc = CarouselPageViewController(imageUrlStrings: imageUrlStrings, selectedIndex: selectedIndex)
        return pvc
    }
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

class CarouselPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        self.selectedIndex
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
    
    var allControllers: [UIViewController] = []
    var selectedIndex: Int
    
    init(imageUrlStrings: [String], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        // pages that we swipe through
        allControllers = imageUrlStrings.map({ imageName in
            let hostingController =
                UIHostingController(rootView:
                                        ZStack {
                                            Color.black
                                            KFImage(URL(string: imageName))
                                            .resizable()
                                            .scaledToFit()
                                        }
                                        
                )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        if selectedIndex < allControllers.count {
            setViewControllers([allControllers[selectedIndex]], direction: .forward, animated: true, completion: nil)
        }
        
//        if let first = allControllers.first {
//            setViewControllers([first], direction: .forward, animated: true, completion: nil)
//        }
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct RestaurantCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCarouselView(imageUrlStrings: ["https://images.unsplash.com/photo-1593642532744-d377ab507dc8?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80", "https://images.unsplash.com/photo-1612877927939-1c9078b1114a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80", "https://images.unsplash.com/photo-1612934238529-206675793fe3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=975&q=80"], selectedIndex: 2)
            .frame(height: 300)
    }
}
