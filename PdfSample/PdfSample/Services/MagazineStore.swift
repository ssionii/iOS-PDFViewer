//
//  MagazineStore.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/26.
//

import Foundation
import PDFKit

class MagazineStore : MagazineStoreProtocol {

	func fetchMagazines(completionHandler: @escaping (() throws -> [Magazine]) -> Void) {

		var magazines = [Magazine]()

		var magazineJson = [String : Any]()
		let jsonPath = Bundle.main.path(forResource: "magazine", ofType: "json")

		if let data = try? String(contentsOfFile: jsonPath!).data(using: .utf8) {
			let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
			if json != nil {
				magazineJson = json!
			}
		}

		if let jsons = magazineJson["magazine"] as? [[String : Any]] {
			for magazine in jsons {
				let m = Magazine(id: magazine["id"] as! Int, title: magazine["title"] as! String, thumnail: magazine["thumbnail"] as! String, pdfUrl: magazine["pdfUrl"] as! String)

				magazines.append(m)
			}
		}

		completionHandler { return magazines }
	}

	func fetchMagazine(id: Int, pdfUrl: String, completionHandler: @escaping (() throws -> PDFDocument?) -> Void){

		var fetchFile = false
		var pdfDocument : PDFDocument?

		do {
			// 파일 가져오기
			let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)

			for url in contents {
				if url.description.contains("\(id).pdf") {
					fetchFile = true
					print("pdf successfully fetched")
					pdfDocument = PDFDocument(url: url)
				}
			}

			if(!fetchFile) {
				let url = URL(string: pdfUrl)
				pdfDocument = PDFDocument(url: url!)

				DispatchQueue.global().async {
					self.savePDF(id: id, url: url!)
				}
			}

		} catch let e {
			print(e.localizedDescription)
		}

		completionHandler { return pdfDocument }

	}

	func savePDF(id: Int, url: URL) {
		do {
			let pdfData = try Data.init(contentsOf: url)
			let resourceDocPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
			let pdfNameFromUrl = "\(id).pdf"
			let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
			print(actualPath)
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
