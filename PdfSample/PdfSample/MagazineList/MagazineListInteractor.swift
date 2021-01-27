//
//  MagazineListInteractor.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/26.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MagazineListBusinessLogic
{
	func fetchMagazines(request: MagazineList.FetchMagazines.Request)
}

protocol MagazineListDataStore
{
	var magazines: [Magazine] { get set }
}

class MagazineListInteractor: MagazineListBusinessLogic, MagazineListDataStore
{
	var presenter: MagazineListPresentationLogic?
	var magazineWorker = MagazineWorker(magazineStore: MagazineStore())

	var magazines: [Magazine] = []

	// MARK: Fetch magazines

	func fetchMagazines(request: MagazineList.FetchMagazines.Request)
	{
		
		magazineWorker.fetchMagzines { (magazines) -> Void in
			self.magazines = magazines

			let response = MagazineList.FetchMagazines.Response(magazines: magazines)
			self.presenter?.presentMagazines(response: response)

		}
	}
}