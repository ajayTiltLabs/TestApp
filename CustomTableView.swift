//
//  CustomTableView.swift
//  CategoryApp
//
//  Created by Ajay on 24/03/22.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        print("ContentSizee \(contentSize)")
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
