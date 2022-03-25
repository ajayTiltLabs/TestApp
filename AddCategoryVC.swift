//
//  AddCategoryVC.swift
//  CategoryApp
//
//  Created by Ajay on 23/03/22.
//

import UIKit

class AddCategoryVC: UIViewController,ImagePickerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var txtHindi: UITextField!
    @IBOutlet weak var txtEnglish: UITextField!
    @IBOutlet weak var btnNonFeatured: RadioButton!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var btnFeatured: RadioButton!
    @IBOutlet weak var imgCategoryImage: UIImageView!
    var isFeatured = true
    var isNonFeatured = false
    let pickerView = UIPickerView()
    var imagePicker: ImagePicker!
    var response: Welcome?
    var mainCategoryList:[Datum] = []
    var newJsonData:[String: Any] = [:]
    var jsonData = [Datum]()
    var addjsonData:Datum?
    var name:[Name]?
    var fm = FileManager.default
    var subUrl: URL?
    var mainUrl: URL? = Bundle.main.url(forResource: "TestCategoryData", withExtension: "json")
    
    
    override func viewWillAppear(_ animated: Bool) {
        createDocumentUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAddItemView()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        txtCategory.inputView = pickerView
        pickerView.delegate = self
    }
    fileprivate func configureAddItemView() {

        btnNonFeatured.setImage(UIImage(named: "radio-normal"), for: .normal)
        btnFeatured.setImage(UIImage(named: "radio-normal"), for: .normal)
        btnNonFeatured.setImage(UIImage(named: "radio-selected"), for: .selected)
        btnFeatured.setImage(UIImage(named: "radio-selected"), for: .selected)
        btnNonFeatured.isSelected = false
        btnFeatured.isSelected = false
    }
    
    func createDocumentUrl() {
        do {
            let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            subUrl = documentDirectory.appendingPathComponent("TestCategoryData.json")
            loadFile(mainPath: mainUrl!, subPath: subUrl!)
        } catch {
            print(error)
        }
    }
    
    func loadFile(mainPath: URL, subPath: URL){
        if fm.fileExists(atPath: subPath.path){
                
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
                        }
                    }
                } catch {
                    
                }
            } else {
                
            }
        }
    
    // MARK: UIPickerView Delegation

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainCategoryList.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainCategoryList[row].name[0].value
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategory.text = mainCategoryList[row].name[0].value
    }
    
    @IBAction func btnRadioCategoryTapped(_ sender: UIButton) {
        switch sender {
        case btnFeatured:
            btnFeatured.setImage(UIImage(named: "radio-selected"), for: .normal)
            btnFeatured.setImage(UIImage(named: "radio-selected"), for: .selected)
            btnNonFeatured.setImage(UIImage(named: "radio-normal"), for: .normal)
            btnNonFeatured.setImage(UIImage(named: "radio-normal"), for: .selected)
            isFeatured = true
            isNonFeatured = false
        case btnNonFeatured:
            btnNonFeatured.setImage(UIImage(named: "radio-selected"), for: .normal)
            btnNonFeatured.setImage(UIImage(named: "radio-selected"), for: .selected)
            btnFeatured.setImage(UIImage(named: "radio-normal"), for: .normal)
            btnFeatured.setImage(UIImage(named: "radio-normal"), for: .selected)
            isFeatured = false
            isNonFeatured = true
        default:
            debugPrint("default case")
        }
    }
    
    @IBAction func btnTappedSave(_ sender: Any) {
        
        
        
        if txtEnglish.text != "" && txtHindi.text != "" {
            name = [Name(id: "", language: .en, value: "Test1")]

            addjsonData = Datum(categoryID: "", name: name!, slug: "", datumDescription: "", parentID: "", type: 0, attributeSet: "", categoryNumber: 112, level: 0, featured: true, icon: "", image: [], status: true, createDate: "")
            
            jsonData.append(addjsonData!)

                do {
                
                    let encoder = JSONEncoder()
                    try encoder.encode(addjsonData).write(to: subUrl!)
                } catch {
                    print(error.localizedDescription)
                }

            
            
            
            
            //self.navigationController?.popViewController(animated: true)
           
        } else {
            
        }
    }
    func writeToFile(location: URL) {
        
        
        
        
        
        
        
            do{
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                try encoder.encode(jsonData).write(to: location)

            }catch{}
        }
    func writeJSON(_ entry: Datum) {
        mainCategoryList.append(entry)

        do {
            let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("TestCategoryData.json")

            let encoder = JSONEncoder()
            try encoder.encode(entry).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    

    
    @IBAction func btnTappedImageUpload(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    func didSelect(image: UIImage?) {
        if image != nil {
            self.imgCategoryImage.image = image
            updateProfile(image: image)
        }
    }

    func updateProfile(image:UIImage?) {

    }
    
}

//MARK: - Text Field Delegate Methods
extension AddCategoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtHindi.resignFirstResponder()
        txtEnglish.resignFirstResponder()
        txtCategory.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtHindi.layer.borderWidth = 0
        txtEnglish.layer.borderWidth = 0
        txtCategory.layer.borderWidth = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
