//
//  Localization+ext.swift
//  Shopy
//
//  Created by Amin on 12/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: self, comment: self)
    }
}
