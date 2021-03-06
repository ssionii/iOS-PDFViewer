//
//  MagazineListPresenter.swift
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

protocol MagazineListPresentationLogic
{
	func presentMagazines(response: MagazineList.FetchMagazines.Response)
}

class MagazineListPresenter: MagazineListPresentationLogic
{
	weak var viewController: MagazineListDisplayLogic?

	// MARK: present magazines

	func presentMagazines(response: MagazineList.FetchMagazines.Response)
	{

		var displayedMagazines = [MagazineList.FetchMagazines.ViewModel.DisplayedMagazine]()

		for magazine in response.magazines {
			let displayedMagazine = MagazineList.FetchMagazines.ViewModel.DisplayedMagazine(id: magazine.id, title: magazine.title, thumbnail: magazine.thumnail, pdfUrl: magazine.pdfUrl)

			displayedMagazines.append(displayedMagazine)
		}

		let viewModel = MagazineList.FetchMagazines.ViewModel(displayedMagazine: displayedMagazines)

		viewController?.displayMagazines(viewModel: viewModel)
	}
}
