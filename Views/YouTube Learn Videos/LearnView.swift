//
//  LearnView.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import SwiftUI
import WebKit

struct LearnView: View {


    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Text("Learn")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("Stock Market Basics")
                        .font(.title3)
                        .fontWeight(.bold)
                    YTView(ID: "Xn7KWR9EOGQ")
                        .padding()
                    
                    Text("Technical Analysis")
                        .font(.title3)
                        .fontWeight(.bold)
                    YTView(ID: "j1wuR87r0yU")
                        .padding()

                    Text("Fundamental Analysis")
                        .font(.title3)
                        .fontWeight(.bold)
                    YTView(ID: "PQqfeyUQbyE")
                        .padding()

                    Text("Options Trading for Beginners")
                        .font(.title3)
                        .fontWeight(.bold)
                    YTView(ID: "M86YwBWxygI")
                        .padding()
                }
            }

        }

    }
}


struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}


