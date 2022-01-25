//
//  SubscriptionInfoView.swift
//  StoreHelper
//
//  Created by Russell Archer on 07/08/2021.
//
// View hierachy:
// Non-Consumables: [Products].[ProductListView].[ProductListViewRow]......[ProductView]......[if purchased].[PurchaseInfoView].....[PurchaseInfoSheet]
// Consumables:     [Products].[ProductListView].[ProductListViewRow]......[ConsumableView]...[if purchased].[PurchaseInfoView].....[PurchaseInfoSheet]
// Subscriptions:   [Products].[ProductListView].[SubscriptionListViewRow].[SubscriptionView].[if purchased].[SubscriptionInfoView].[SubscriptionInfoSheet]

import SwiftUI
import StoreKit

public struct SubscriptionInfoView: View {
    @EnvironmentObject var storeHelper: StoreHelper
    @State var subscriptionInfoText = ""
    @State private var showSubscriptionInfoSheet = false
    var subscriptionInfo: SubscriptionInfo  // Set by parents
    
    public var body: some View {
        
        let viewModel = SubscriptionInfoViewModel(storeHelper: storeHelper, subscriptionInfo: subscriptionInfo)
        
        #if os(iOS)
        HStack(alignment: .center) {
            Button(action: { withAnimation { showSubscriptionInfoSheet.toggle()}}) {
                HStack {
                    Image(systemName: "creditcard.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    
                    Text(subscriptionInfoText)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .lineLimit(nil)
                }
                .padding()
            }
        }
        .onAppear {
            Task.init { subscriptionInfoText = await viewModel.shortInfo() }
        }
        .sheet(isPresented: $showSubscriptionInfoSheet) {
            if let pid = subscriptionInfo.product?.id {
                SubscriptionInfoSheet(showPurchaseInfoSheet: $showSubscriptionInfoSheet, productId: pid, viewModel: viewModel)
            }
        }
        #elseif os(macOS)
        HStack(alignment: .center) {
            Image(systemName: "creditcard.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
                .frame(height: 30)

            Text(subscriptionInfoText)
                .font(.title3)
                .foregroundColor(.blue)
                .lineLimit(nil)
        }
        .padding()
        .onTapGesture { withAnimation { showSubscriptionInfoSheet.toggle()}}
        .onAppear {
            Task.init { subscriptionInfoText = await viewModel.shortInfo() }
        }
        .sheet(isPresented: $showSubscriptionInfoSheet) {
            if let pid = subscriptionInfo.product?.id {
                SubscriptionInfoSheet(showPurchaseInfoSheet: $showSubscriptionInfoSheet, productId: pid, viewModel: viewModel)
            }
        }
        #endif
    }
}
