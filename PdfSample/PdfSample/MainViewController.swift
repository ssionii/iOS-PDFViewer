//
//  ViewController.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/25.
//

import UIKit
import PDFKit


class MainViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		setPDFView()
		getJson()
	}

	var magazines : [Magazine] = [Magazine]()
	var pdfView : PDFView?


	func setPDFView(){

		pdfView = PDFView(frame: self.view.bounds)
		if pdfView != nil {
			pdfView?.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
			self.view.addSubview(pdfView!)
			pdfView?.autoScales = true
		}
	}

	func getJson(){

		var jsonMagazines = [String : Any]()
		let jsonPath = Bundle.main.path(forResource: "magazine", ofType: "json")

		if let data = try? String(contentsOfFile: jsonPath!).data(using: .utf8){
			let json = try! JSONSerialization.jsonObject(with: data, options:[]) as? [String : Any]
			if json != nil {
				jsonMagazines = json!
			}
		}

		if let magazine = jsonMagazines["magazine"] as? [[String : Any]] {
			for magazineIndex in magazine {
				let m = Magazine(id: magazineIndex["id"] as! Int, title: magazineIndex["title"] as! String, thumnail: magazineIndex["thumbnail"] as! String, pdfUrl: magazineIndex["pdfUrl"] as! String)
				magazines.append(m)

				fetchPDF(title: m.title, pdfUrl: m.pdfUrl)
			}
		}
	}


	func fetchPDF(title: String, pdfUrl: String){
		print("\(title)")

		var fetchFile = false

		do {
			// 파일 가져오기
			let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)

			for url in contents {
				if url.description.contains("\(title).pdf") {
					fetchFile = true
					print("pdf successfully fetched")
					pdfView?.document = PDFDocument(url: url)
				}
			}

			if(!fetchFile) {
				savePDF(title: title, pdfUrl: pdfUrl)
			}

		} catch let e {
			print(e.localizedDescription)
		}
	}

	func savePDF(title: String, pdfUrl: String){

		let url = URL(string: pdfUrl)
		pdfView?.document = PDFDocument(url: url!)

		do {
			let pdfData = try Data.init(contentsOf: url!)
			let resourceDocPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
			let pdfNameFromUrl = "\(title).pdf"
			let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
			do {
					try pdfData.write(to: actualPath, options: .atomic)
					print("pdf successfully saved")
			} catch {
					print("pdf could not be saved")
			}
		} catch let e {
			print(e.localizedDescription)
		}
	}
}

