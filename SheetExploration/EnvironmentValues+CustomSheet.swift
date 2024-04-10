//
//  EnvironmentValues+CustomSheet.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/5/24.
//

import SwiftUI

private struct CustomIsPresentedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct DismissCustomSheetKey: EnvironmentKey {
    static let defaultValue = CustomDismissAction()
}

public struct CustomDismissAction {
    var dismiss: (() -> Void)?
    
    func callAsFunction() {
        dismiss?()
    }
}

extension EnvironmentValues {
    var customDismiss: CustomDismissAction {
        get { self[DismissCustomSheetKey.self] }
        set { self[DismissCustomSheetKey.self] = newValue }
    }
    
    var customIsPresented: Bool {
        get { self[CustomIsPresentedKey.self] }
        set { self[CustomIsPresentedKey.self] = newValue }
    }
}
