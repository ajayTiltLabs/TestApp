//
//  ChildCategoryTableCell.swift
//  CategoryApp
//
//  Created by Ajay on 25/03/22.
//

import UIKit


protocol DetailPageFromSubcategoryDelegate {
    func moveToDetailPage(index:Int, selectedSubCategory: Datum)
}

class ChildCategoryTableCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblChildCategory: CustomTableView!
    var subCategoryList: [Datum] = []
    var delegate: DetailPageFromSubcategoryDelegate?
    var categoryName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblChildCategory.delegate = self
        tblChildCategory.dataSource = self
//        tblChildCategory.estimatedRowHeight = 300
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.Cells.childCategoryTableViewCell, for: indexPath) as! ChildCategoryTableViewCell
        cell.lblTitleSubcategory.text = subCategoryList[indexPath.row].name[0].value
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.moveToDetailPage(index: indexPath.row, selectedSubCategory: subCategoryList[indexPath.row])
    }
    


}
