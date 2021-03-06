//
//  MagazineListModels.swift
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

enum MagazineList
{
  // MARK: Use cases
  
  enum FetchMagazines
  {
    struct Request
    {
    }
    struct Response
    {
		var magazines : [Magazine]
    }
    struct ViewModel
    {
		struct DisplayedMagazine {
			var id: Int
			var title: String
			var thumbnail: String
			var pdfUrl: String
		}
		var displayedMagazine : [DisplayedMagazine]
    }
  }
}
