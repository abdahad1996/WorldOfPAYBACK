//
//  FloatingView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation

import SwiftUI

public struct FloatingView: View {
    
    @Binding var count: Int

    public init(count: Binding<Int>) {
        self._count = count
    }
    
    public var body: some View {
        VStack {
            Text("Total Amount: \(count)")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FloatingView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingView(count: .constant(2))
    }
}
