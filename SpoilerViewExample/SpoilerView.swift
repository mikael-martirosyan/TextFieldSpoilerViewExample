//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

final class EmitterView: UIView {
  
  override class var layerClass: AnyClass {
    CAEmitterLayer.self
  }
  
  override var layer: CAEmitterLayer {
    super.layer as! CAEmitterLayer
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.emitterPosition = .init(x: bounds.size.width / 2,
                                  y: bounds.size.height / 2)
    layer.emitterSize = bounds.size
  }
}

/// Based on [InvisibleInkDustNode.swift](https://github.com/TelegramMessenger/Telegram-iOS/blob/930d1fcc46e39830e6d590986a6a838c3ff49e27/submodules/InvisibleInkDustNode/Sources/InvisibleInkDustNode.swift#L97-L109)
struct SpoilerView: UIViewRepresentable {
  
  var text: String
  var isOn: Bool
  
  private var birthRate: Float {
    let resultWithCoeff = Float(text.count) * 50 * 3.3
    let plainResult: Float = 2000
    
    return (text.count > 10) ? plainResult : resultWithCoeff
  }
  
  func makeUIView(context: Context) -> EmitterView {
    let emitterView = EmitterView()
    
    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "textSpeckle_Normal")?.cgImage
    emitterCell.color = UIColor.black.cgColor
    emitterCell.contentsScale = 1.8
    emitterCell.emissionRange = .pi * 2
    emitterCell.lifetime = 1
    emitterCell.scale = 0.5
    emitterCell.velocityRange = 20
    emitterCell.alphaRange = 1
    emitterCell.birthRate = 1
    
    emitterView.layer.emitterShape = .rectangle
    emitterView.layer.emitterCells = [emitterCell]
    
    return emitterView
  }
  
  func updateUIView(_ uiView: EmitterView, context: Context) {
    if !isOn {
      uiView.layer.beginTime = CACurrentMediaTime()
      uiView.layer.birthRate = 0
    } else {
      uiView.layer.birthRate = birthRate
    }
  }
  
}

struct SpoilerModifier: ViewModifier {
  
  let text: String
  let isOn: Bool
  
  func body(content: Content) -> some View {
    content.overlay {
      SpoilerView(
        text: text,
        isOn: isOn
      )
    }
  }
  
}

extension View {
  
  @ViewBuilder
  func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
  
  func spoiler(
    text: Binding<String>,
    isOn: Binding<Bool>
  ) -> some View {
    self
      .modifier(
        SpoilerModifier(
          text: text.wrappedValue,
          isOn: isOn.wrappedValue
        )
      )
  }
  
}
