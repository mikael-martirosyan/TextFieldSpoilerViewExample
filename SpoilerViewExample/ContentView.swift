//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

struct ContentView: View {
  
  @State var spoilerIsOn = true
  @State var text = ""
  
  var body: some View {
    VStack {
      HStack {
        ZStack(alignment: .leading) {
          TextField(text: $text) {
            Text(text)
          }
          .foregroundStyle(spoilerIsOn ? .clear : .black)
          .overlay {
            RoundedRectangle(cornerRadius: 5)
              .stroke(lineWidth: 1)
              .tint(.gray)
          }
          .zIndex(spoilerIsOn ? 0 : 1)
          
          
          
          if !text.isEmpty {
            Text(text)
              .foregroundStyle(.clear)
              .lineLimit(1)
              .multilineTextAlignment(.leading)
              .if(spoilerIsOn) { view in
                view.spoiler(text: $text, isOn: $spoilerIsOn)
              }
              .zIndex(spoilerIsOn ? 1 : 0)
          }
        }
        
        Button {
          spoilerIsOn.toggle()
        } label: {
          Image(systemName: spoilerIsOn == false ? "eye" : "eye.slash")
        }
      }
      .frame(width: 300)
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView()
  }
  
}

