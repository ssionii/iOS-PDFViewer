//
//  TiledPDFScrollView.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/27.
//

import UIKit

class TiledPDFScrollView: UIScrollView, UIScrollViewDelegate {

	var pageRect = CGRect()
	var backgroundImageView: UIView!
	var tiledPDFView: TiledPDFView!
	var oldTiledPDFView: TiledPDFView!

	var PDFScale = CGFloat()
	var tiledPDFPage: CGPDFPage!

	func initialize() {
		decelerationRate = UIScrollView.DecelerationRate.fast
		delegate = self
		layer.borderColor = UIColor.lightGray.cgColor
		layer.borderWidth = 2
		minimumZoomScale = 0.25
		maximumZoomScale = 5
		backgroundImageView = UIView(frame: frame)
		oldTiledPDFView = TiledPDFView(frame: pageRect, scale: PDFScale)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}


	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}



	func setPDFPage(_ newPDFPage: CGPDFPage?) {

		tiledPDFPage = newPDFPage

		if tiledPDFPage == nil {
			pageRect = bounds
		} else {
			pageRect = tiledPDFPage.getBoxRect(CGPDFBox.mediaBox)

			PDFScale = frame.size.width / pageRect.size.width
			pageRect = CGRect(x: pageRect.origin.x, y: pageRect.origin.y, width: pageRect.size.width * PDFScale, height: pageRect.size.height * PDFScale)
		}

		replaceTiledPDFViewWithFrame(pageRect)
	}


	override func layoutSubviews()
	{
		super.layoutSubviews()

		let boundsSize:CGSize = bounds.size
		var frameToCenter:CGRect = tiledPDFView.frame

		if frameToCenter.size.width < boundsSize.width {
			frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
		} else {
			frameToCenter.origin.x = 0
		}

		if frameToCenter.size.height < boundsSize.height {
			frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
		} else {
			frameToCenter.origin.y = 0
		}

		tiledPDFView.frame = frameToCenter
		backgroundImageView.frame = frameToCenter
		tiledPDFView.contentScaleFactor = 1.0
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
	   return tiledPDFView
	}



	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		// Remove back tiled view.
		oldTiledPDFView.removeFromSuperview()

		// Set the current TiledPDFView to be the old view.
		oldTiledPDFView = tiledPDFView
	}


	/*
	 A UIScrollView delegate callback, called when the user begins zooming.
	 When the user begins zooming, remove the old TiledPDFView and set the current TiledPDFView to be the old view so we can create a new TiledPDFView when the zooming ends.
	 */
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		// Set the new scale factor for the TiledPDFView.
		PDFScale *= scale

		replaceTiledPDFViewWithFrame(oldTiledPDFView.frame)
	}

	func replaceTiledPDFViewWithFrame(_ frame: CGRect) {
		// Create a new tiled PDF View at the new scale
		let newTiledPDFView = TiledPDFView(frame: frame, scale: PDFScale)
		newTiledPDFView.pdfPage = tiledPDFPage

		// Add the new TiledPDFView to the PDFScrollView.
		addSubview(newTiledPDFView)
		tiledPDFView = newTiledPDFView
	}

}
