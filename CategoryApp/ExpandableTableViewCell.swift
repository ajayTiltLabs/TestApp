//
//  ExpandableTableViewCell.swift
//  CategoryApp
//
//  Created by Ajay on 24/03/22.
//

import UIKit

protocol moveToSubcategoryDelegate {
    func moveToSubcategory(selectedCategory:Datum, index:Int)
}

class ExpandableTableViewCell: UITableViewCell {
    
    typealias arrowButtonTappedBlock = (_ btnArrow:UIButton) -> Void
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    var delegate: moveToSubcategoryDelegate?
    var selectedCategory:Datum?
    var arrowButtonTapped : arrowButtonTappedBlock!
    var currentIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        categoryTitleLabel.text = selectedCategory?.name[0].value.capitalized
        
    }

    @IBAction func btnTappedExpand(_ sender: Any) {
        delegate?.moveToSubcategory(selectedCategory: selectedCategory!, index: currentIndex ?? 0)
    }
    
}
