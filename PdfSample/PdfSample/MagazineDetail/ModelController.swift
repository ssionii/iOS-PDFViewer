//
//  ModelController.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/27.
//

import UIKit

class ModelController: NSObject, UIPageViewControllerDataSource {

	var pdf: CGPDFDocument!
	var numberOfPages: Int = 0

	override init(){
		if let pdfURL: URL = Bundle.main.url(forResource: "input_pdf.pdf", withExtension: nil) {
			let documentURL: CFURL = pdfURL as CFURL
			pdf = CGPDFDocument(documentURL)
			numberOfPages = pdf.numberOfPages as Int
			if numberOfPages % 2 == 1 {
				numberOfPages += 1
			}
		} else {
			print("pdf cannot find")
		}
	}

	func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController {
		let vc = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController

		vc.pageNumber = index + 1
		vc.pdf = pdf
		return vc
	}

	func indexOfViewController(_ viewController: DataViewController) -> Int
	{
		// Return the index of the given data view controller.
		// For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
		return viewController.pageNumber - 1
	}



	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
	{
		var index = self.indexOfViewController(viewController as! DataViewController)

		if index == 0 || index == NSNotFound
		{
			return nil
		}

		index -= 1
		return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}



	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
	{
		var index = self.indexOfViewController(viewController as! DataViewController)

		if index == NSNotFound
		{
			return nil
		}

		index += 1

		if index == numberOfPages
		{
			return nil
		}

		return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}

}
