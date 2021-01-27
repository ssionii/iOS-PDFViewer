//
//  RootViewController.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/27.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

	var pageViewController: UIPageViewController!
	var modelController: ModelController!


	override func viewDidLoad()
	{
		super.viewDidLoad()

		// insantiate our ModelController
		modelController = ModelController()

		// Do any additional setup after loading the view, typically from a nib.
		// Configure the page view controller and add it as a child view controller.

		pageViewController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.pageCurl, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
		pageViewController.delegate = self

		let startingViewController = modelController.viewControllerAtIndex(0, storyboard: self.storyboard!) as DataViewController
		let viewControllers:[DataViewController] = [startingViewController]

		pageViewController.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

		pageViewController.dataSource = modelController

		self.addChild(pageViewController)
		self.view.addSubview(pageViewController.view)

		// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
		let pageViewRect = self.view.bounds
		pageViewController.view.frame = pageViewRect
		pageViewController.didMove(toParent: self)

		// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
		self.view.gestureRecognizers = pageViewController.gestureRecognizers

	}



	func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation
	{
		if orientation.isPortrait || UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
		{
			// In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.

			let currentViewController = pageViewController.viewControllers![0] as UIViewController
			let viewControllers = [currentViewController]
			pageViewController.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
			pageViewController.isDoubleSided = false
			return UIPageViewController.SpineLocation.min
		}

		// In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
		let currentViewController = pageViewController.viewControllers?[0] as! DataViewController

		var viewControllers:[UIViewController] = []
		let indexOfCurrentViewController = modelController.indexOfViewController(currentViewController)

		if indexOfCurrentViewController % 2 == 0
		{
			let nextViewController: UIViewController = modelController.pageViewController(pageViewController, viewControllerAfter: currentViewController)!
			viewControllers = [currentViewController, nextViewController]
		}
		else
		{
			let previousViewController: UIViewController = modelController.pageViewController(pageViewController, viewControllerBefore: currentViewController)!
			viewControllers = [previousViewController, currentViewController]
		}

		pageViewController.setViewControllers(viewControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)

		return UIPageViewController.SpineLocation.mid
	}

}
