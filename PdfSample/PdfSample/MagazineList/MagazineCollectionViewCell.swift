//
//  MagazineCollectionViewCell.swift
//  PdfSample
//
//  Created by 60058232 on 2021/01/26.
//

import UIKit

class MagazineCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!

	func bindData(thumbnail: String, title: String){

		DispatchQueue.global().async{
			var data : Data?
			do {
				let imageUrl = URL(string: thumbnail)
				data = try Data(contentsOf: imageUrl!)
				self.thumbnailImageView.image = UIImage(data: data!)
			} catch let e {
				print(e.localizedDescription)
			}
		}

		titleLabel.text = title
	}
}
