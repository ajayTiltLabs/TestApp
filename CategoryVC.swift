//
//  CategoryVC.swift
//  CategoryApp
//
//  Created by Ajay on 24/03/22.
//

import UIKit

class CategoryVC: UIViewController,UISearchBarDelegate, UITableViewDelegate, moveToSubcategoryDelegate, UITableViewDataSource, DetailPageFromSubcategoryDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblCategoryList: CustomTableView!
    var response: Welcome?
    var mainCategoryList:[Datum] = []
    var selectedCategory:Datum?
    var selectedSubCategory: [Datum] = []
    var selectedIndex:Int?
    var filtered:[Datum] = []
    var searchActive : Bool = false
    var indexValue = 0
    var fm = FileManager.default
    var mainCategoryName = ""
    var subUrl: URL?
    var mainUrl: URL? = Bundle.main.url(forResource: "TestCategoryData", withExtension: "json")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".json")
        handleJsonData()
        searchBar.showsCancelButton = false
        searchBar.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func copyFilesFromBundleToDocumentsFolderWith(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    if let documentsURL = documentsURL {
                        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                        let destURL = documentsURL.appendingPathComponent(fileName)
                        do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    }
                }
            } catch { }
        }
    }
    
    
    func handleJsonData() {
        do {
            let documentDirectory = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            subUrl = documentDirectory.appendingPathComponent("TestCategoryData.json")
            if fm.fileExists(atPath: subUrl!.path) {
                loadFromDocumentURL(mainPath: mainUrl!, subPath: subUrl!)
            } else {
                loadJsonData()
            }
        } catch {
            
        }
    }
    
    func loadFromDocumentURL(mainPath: URL, subPath: URL){
            if FileManager().fileExists(atPath: mainPath.path){
                do {
                    let data = try Data(contentsOf: mainPath)
                    guard let categoryList = try? JSONDecoder().decode(Welcome.self, from: data) else {
                        return
                    }
                    response = categoryList
                    response?.data.map {
                        let newItem = $0
                        if $0.parentID == "0" {
                            var subcategoriesList:[Datum] = []
                            response?.data.map {
                                if $0.parentID == newItem.categoryID {
                                  subcategoriesList.append($0)
                                }
                          }
                            var tempCategory = $0
                            tempCategory.subCategory = subcategoriesList
                            mainCategoryList.append(tempCategory)
                            mainCategoryList = mainCategoryList.sorted(by: { $0.name[0].value < $1.name[0].value})
                        }
                    }
                } catch {
                    
                }
            } else {
                
        }
    }
    
    func loadJsonData() {
        guard let url = Bundle.main.url(forResource: "TestCategoryData", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let categoryList = try? JSONDecoder().decode(Welcome.self, from: data) else {
                return
            }
            response = categoryList
            response?.data.map {
                let newItem = $0
                if $0.parentID == "0" {
                    var subcategoriesList:[Datum] = []
                    response?.data.map {
                        if $0.parentID == newItem.categoryID {
                          subcategoriesList.append($0)
                        }
                  }
                    var tempCategory = $0
                    tempCategory.subCategory = subcategoriesList
                    mainCategoryList.append(tempCategory)
                    mainCategoryList = mainCategoryList.sorted(by: { $0.name[0].value < $1.name[0].value})
                }
            }
        } catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ReuseIdentifiers.Segues.categoryDetailSegue {
            if let destinationVC = segue.destination as? CategoryDetailVC {
                destinationVC.selectedCategory = selectedCategory
                destinationVC.mainCategory = mainCategoryName
            }
        } else if segue.identifier == ReuseIdentifiers.Segues.subcategoryDetailSegue {
            if let destinationVC = segue.destination as? CategoryDetailVC {
                destinationVC.selectedCategory = selectedCategory
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = false
        }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchActive = false
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        filtered = []
        // Hide the cancel button
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = []
        self.searchActive = true
        self.searchBar.showsCancelButton = true
        filtered  = mainCategoryList.filter { $0.datumDescription.contains(searchText)}
        if(filtered.count == 0){
            self.searchActive = false;
        } else {
            self.searchActive = true;
        }
        if searchText == "" {
            filtered = []
            searchBar.resignFirstResponder()
            self.searchActive = false
        }
        self.tblCategoryList.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == indexValue && mainCategoryList[section].subCategory!.count > 0 {
            return 2
        } else {
            return 1
        }
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//        default:
//            return 0
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.Cells.expandableTableViewCell, for: indexPath) as! ExpandableTableViewCell
            if searchActive {
                if filtered[indexPath.section].subCategory!.count > 0 {
                    cell.btnArrow.isHidden = false
                } else {
                    cell.btnArrow.isHidden = true
                }
                cell.currentIndex = indexPath.section
                cell.categoryTitleLabel.text = filtered[indexPath.section].slug.capitalized
                cell.selectedCategory = filtered[indexPath.section]
                cell.delegate = self
                return cell
            } else {
                if mainCategoryList[indexPath.section].subCategory!.count > 0 {
                    cell.btnArrow.isHidden = false
                } else {
                    cell.btnArrow.isHidden = true
                }
                cell.currentIndex = indexPath.section
                cell.categoryTitleLabel.text = mainCategoryList[indexPath.section].name[0].value
                cell.selectedCategory = mainCategoryList[indexPath.section]
                cell.delegate = self
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.Cells.childCategoryTableCell, for: indexPath) as! ChildCategoryTableCell
            cell.subCategoryList = mainCategoryList[indexPath.section].subCategory ?? []
            cell.delegate = self
            cell.tblChildCategory.reloadData()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 200
        default:
            return 100
        }
    }
    
    
    func moveToDetailPage(index: Int, selectedSubCategory: Datum) {
        selectedCategory = selectedSubCategory
        performSegue(withIdentifier: ReuseIdentifiers.Segues.subcategoryDetailSegue, sender: selectedSubCategory)
    }
    



    func moveToSubcategory(selectedCategory: Datum, index: Int) {
        self.selectedCategory = selectedCategory
        indexValue = index
        self.tblCategoryList.reloadData()
//        self.performSegue(withIdentifier: ReuseIdentifiers.Segues.segueToSubCategories, sender: self.selectedCategory)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searchActive {
            selectedCategory = mainCategoryList[indexPath.section]
            mainCategoryName = (selectedCategory?.name[0].value)!
            self.performSegue(withIdentifier: ReuseIdentifiers.Segues.categoryDetailSegue, sender: selectedCategory)
        } else {
            selectedCategory = filtered[indexPath.section]
            self.performSegue(withIdentifier: ReuseIdentifiers.Segues.categoryDetailSegue, sender: selectedCategory)
        }
    }
    

}

