//
//  PurchaseButton.swift
//  StoreHelper
//
//  Created by Russell Archer on 21/06/2021.
//

import SwiftUI
import StoreKit

/// Provides a button that enables the user to purchase a product.
/// The product's price is also displayed in the localized currency.
@available(tvOS 15.0, *)
public struct PurchaseButton: View {
    
    @EnvironmentObject var storeHelper: StoreHelper
    @Binding var purchaseState: PurchaseState
    
    var productId: ProductId
    var price: String

    public init(purchaseState: PurchaseState, productId: ProductId, price: String) {
        self.purchaseState = purchaseState
        self.productId = productId
        self.price = price
    }

    public var body: some View {
        
        let product = storeHelper.product(from: productId)
        if product == nil {
            
            StoreErrorView()
            
        } else {
            
            HStack {
                
                if product!.type == .consumable {
                    
                    if purchaseState != .purchased { withAnimation { BadgeView(purchaseState: $purchaseState) }}
                    PriceView(purchaseState: $purchaseState, productId: productId, price: price, product: product!)
                    
                } else {
                    
                    withAnimation { BadgeView(purchaseState: $purchaseState) }
                    if purchaseState != .purchased { PriceView(purchaseState: $purchaseState, productId: productId, price: price, product: product!) }
                }
            }
        }
    }
}

@available(tvOS 15.0, *)
struct PurchaseButton_Previews: PreviewProvider {
    static var previews: some View {

        @StateObject var storeHelper = StoreHelper()
        @State var purchaseState: PurchaseState = .inProgress

        return PurchaseButton(purchaseState: $purchaseState,
                              productId: "nonconsumable.flowers-large",
                              price: "£1.99")
            .environmentObject(storeHelper)
    }
}
