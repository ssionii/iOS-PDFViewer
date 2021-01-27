//
//  TiledPDFView.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/27.
//

import UIKit

class TiledPDFView: UIView {

	var pdfPage: CGPDFPage?
	var myScale: CGFloat!

	init(frame: CGRect, scale: CGFloat) {
		super.init(frame: frame)

		let tiledLayer = CATiledLayer(layer: self)

		tiledLayer.levelsOfDetail = 4
		tiledLayer.levelsOfDetailBias = 3
		tiledLayer.tileSize = CGSize(width: 512.0, height: 512.0)
		myScale = scale
		layer.borderColor = UIColor.lightGray.cgColor
		layer.borderWidth = 0
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override class var layerClass: AnyClass {
		get {
			return CATiledLayer.self
		}
	}

	override func draw(_ layer: CALayer, in ctx: CGContext){
		ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		ctx.fill(bounds)

		if pdfPage == nil {
			print("page nil")
			return
		}
		ctx.saveGState()

		// Flip the context so that the PDF page is rendered right side up.
		ctx.translateBy(x: 0.0, y: bounds.size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)

		// Scale the context so that the PDF page is rendered at the correct size for the zoom level.
		ctx.scaleBy(x: myScale, y: myScale)

		// draw the page, restore and exit
		ctx.drawPDFPage(pdfPage!)
		ctx.restoreGState()
	}

}
