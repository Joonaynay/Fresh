//
//  SearchBarView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/27/21.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var textFieldText: String
    
    @EnvironmentObject private var vm: SearchBar2Test
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search...", text: $textFieldText)
            Button(action: { vm.searchButton = true }, label: {
                Text("Search")
                    .background(Color.blue)
            })
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .background(Color.theme.secondaryText)
        .foregroundColor(Color.theme.accent)
        .padding()
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .padding()
                .offset(x: -20)
                .foregroundColor(Color.theme.accent)
                .opacity(textFieldText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    textFieldText = ""
                }
            
            , alignment: .trailing
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(textFieldText: .constant("Sup Jilda"))
            .environmentObject(SearchBar2Test())
    }
}
