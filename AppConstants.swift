//
//  AppConstants.swift
//  CategoryApp
//
//  Created by Ajay on 24/03/22.
//

import Foundation

// MARK: - Reuse Identifiers -

/// Defines the reuse identifiers
struct ReuseIdentifiers {
    
    /// Defines the reuse identifiers of the ViewControllers
    struct ViewControllers {
        
    }
    
    /// Defines the reuse identifiers of the Cells
    struct Cells {
        static let expandableTableViewCell  = "ExpandableTableViewCell"
        static let subcategoryCell          = "SubcategoryCell"
        static let childCategoryTableCell   = "ChildCategoryTableCell"
        static let childCategoryTableViewCell = "ChildCategoryTableViewCell"
    }
    
    /// Defines the reuse identifiers of the Segues
    struct Segues {
        static let categoryDetailSegue      = "CategoryDetailSegue"
        static let segueToSubCategories     = "segueToSubCategories"
        static let subcategoryDetailSegue   = "subcategoryDetailSegue"
    }
}
