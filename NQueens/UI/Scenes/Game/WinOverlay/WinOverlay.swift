//
//  WinOverlay.swift
//  NQueens
//
//  Created by Romuald Szauer on 22/3/26.
//

import SwiftUI

extension WinOverlay {
    enum Style {
        case first
        case newRecord
        case solved
        
        var title: String {
            switch self {
            case .first: "Puzzle cracked"
            case .newRecord: "New record"
            case .solved: "Victory secured"
            }
        }
        
        var systemImageName: String {
            switch self {
            case .first: "checkmark.seal.fill"
            case .newRecord: "stopwatch.fill"
            case .solved: "medal.fill"
            }
        }

        var subtitle: String {
            switch self {
            case .first: "You found the solution!\nNow, can you do it even faster?"
            case .newRecord: "You've set a new personal best!\nYour pattern recognition is getting sharper."
            case .solved: "Success is a habit.\nStay sharp and go for that record on the next round."
            }
        }
    }
}

struct WinOverlay: View {
    let style: Style
    var onDismiss: (() -> Void)?
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text(style.title)
                    .font(Font.system(size: 24, weight: .black))
                
                Image(systemName: style.systemImageName)
                    .foregroundStyle(.greenDark)
                    .font(.system(size: 56))
                    .rotationEffect(.degrees(isAnimating ? -5 : 5))
                    .animation(.easeInOut(duration: 1.4).repeatForever(), value: isAnimating)
                    .scaleEffect(isAnimating ? 1.5 : 1)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: isAnimating)
                    .padding(56)
                    .background {
                        raysBackground
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                .linear(duration: 100).repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                            .scaleEffect(isAnimating ? 1.5 : 1)
                            .animation(.linear(duration: 3).repeatForever(), value: isAnimating)
                    }
                
                Text(style.subtitle)
                    .font(Font.system(size: 12, weight: .light))
                    .multilineTextAlignment(.center)
                
                Button(action: { onDismiss?() }) {
                    Text("Continue".localizedUppercase)
                        .font(.system(size: 16, weight: .bold))
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(24)
            .foregroundStyle(.white)
            .background(Color.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: 300)
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private var raysBackground: some View {
        GeometryReader { geometry in
            let sliceCount: Int = 12
            let size = geometry.size
            let radius = max(size.width, size.height) / 2
            
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let anglePerSlice = (2 * Double.pi) / Double(sliceCount * 2)
                
                for i in 0 ..< sliceCount {
                    let startAngle = Double(i) * anglePerSlice * 2 - Double.pi / 2
                    let endAngle = startAngle + anglePerSlice
                    
                    var path = Path()
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: .radians(startAngle),
                        endAngle: .radians(endAngle),
                        clockwise: false
                    )
                    path.closeSubpath()
                    
                    context.fill(path, with: .color(.white))
                }
            }
            .mask {
                RadialGradient(
                    gradient: Gradient(colors: [.white.opacity(0.05), .white.opacity(0.0)]),
                    center: .center,
                    startRadius: 0,
                    endRadius: radius
                )
            }
            
        }
    }
    
    @inlinable
    func onDismiss(_ onDismiss: @escaping (() -> Void)) -> some View {
        var view = self
        view.onDismiss = onDismiss
        return view
    }
}

#Preview("First") {
    Color.background
        .ignoresSafeArea()
        .overlay {
            WinOverlay(style: .first)
        }
}

#Preview("New record") {
    Color.background
        .ignoresSafeArea()
        .overlay {
            WinOverlay(style: .newRecord)
        }
}

#Preview("Solved") {
    Color.background
        .ignoresSafeArea()
        .overlay {
            WinOverlay(style: .solved)
        }
}
