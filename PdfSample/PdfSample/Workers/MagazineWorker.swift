//
//  MagazineWorker.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/26.
//

import Foundation
import PDFKit

class MagazineWorker {

	var magazineStore: MagazineStore

	init(magazineStore: MagazineStore)
	{
		self.magazineStore = magazineStore
	}

	func fetchMagzines(completionHandler: @escaping ([Magazine]) -> Void){

		magazineStore.fetchMagazines { (magazines: () throws -> [Magazine])
			-> Void in
			do {
				let magazines = try magazines()
				DispatchQueue.main.async {
					completionHandler(magazines)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler([])
				}
			}

		}
	}

	func fetchMagazine(id: Int, pdfUrl: String, completionHandler: @escaping (PDFDocument?) -> Void ){
		magazineStore.fetchMagazine(id: id, pdfUrl: pdfUrl) { (magazine : () throws -> PDFDocument?)
			-> Void in
			do {
				let magazine = try magazine()
				DispatchQueue.main.async {
					completionHandler(magazine!)
				}
			} catch {
				DispatchQueue.main.async {
					completionHandler(nil)
				}
			}
		}
	}
}


// MARK: - Magzine store API

protocol MagazineStoreProtocol
{
	func fetchMagazines(completionHandler: @escaping (() throws -> [Magazine]) -> Void)
	func fetchMagazine(id: Int, pdfUrl: String, completionHandler: @escaping (() throws -> PDFDocument?) -> Void)
}
