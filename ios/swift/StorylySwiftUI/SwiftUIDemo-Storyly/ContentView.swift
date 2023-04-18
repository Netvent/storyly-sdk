//
//  ContentView.swift
//  SwiftUIDemo-Storyly
//
//  Created by appsamurai appsamurai on 13.03.2023.
//

import SwiftUI
import Storyly
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            StorylySwiftUIview(storylyToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
