//
//  ContentView.swift
//  ButtonReel
//
//  Created by Alise Serhiienko on 04.12.2023.
//

import SwiftUI

struct ButtonView: View {
    
    private enum Position {
        case start, finish
    }
    
    @State private var containerSize: CGSize = .zero
    @State private var xOffset = 0.0
    
    let title: String
    let resetText: String
    
    @Binding var isReset: Bool
    
    private var currentTitle: String {
        isReset ? title : resetText
    }
    
    private var borderColor: UIColor {
        isReset ? .clear : .systemGray5
    }
    
    private var accentTitleColor: Color {
        isReset ? .white : .nightBlack
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Text(currentTitle)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(accentTitleColor)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background {
                    if isReset {
                        Color.palatinateBlue
                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
                    } else {
                        Color.white
                    }
                }
                .clipShape(.capsule)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(uiColor: borderColor), style: .init(lineWidth: 1))
                }
                .overlay {
                    if !isReset {
                        Image(systemName: "xmark" )
                            .padding()
                            .background(Color.palatinateBlue)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .position(x: xOffset, y: containerSize.height / 2)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.green)
                                    .clipShape(Circle())
                                    .position(x: xOffset, y: 30)
                                    .opacity(xOffset == 32 ? 1 : 0)
                            }
                            .animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0), value: xOffset)
                    }
                    
                    
                }
                .gesture(
                    DragGesture()
                        .onChanged(dragOnChange)
                        .onEnded(gestureIsFinished)
                    
                )
                .onAppear {
                    containerSize = proxy.size
                    setCursorPosition(.start)
                }
                .onChange(of: proxy.size) { _, finalSize in
                    containerSize = finalSize
                    setCursorPosition(.start)
                }
        }
        .frame(height: 60)
        .onTapGesture {
            startInteractiveMode()
        }
        
    }
    
    private func dragOnChange(_ value: DragGesture.Value) {
        xOffset = max(min(containerSize.width - 32, value.location.x), 32)
    }
    
    private func startInteractiveMode() {
        guard isReset else { return }
        setCursorPosition(.start)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring()) {
                isReset.toggle()
            }
        }
    }
    
    private func setCursorPosition(_ position: Position) {
        withAnimation {
            switch position {
            case .start:
                xOffset = containerSize.width - 32
                print("Set starting position \(xOffset), width: \(containerSize.width)")
            case .finish:
                xOffset = 32
            }
        } completion: {
            if position == .finish {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isReset = true
                    }
                }
            }
        }
        
    }
    
    private func gestureIsFinished(_ value: DragGesture.Value) {
        guard value.location.x > 45 else {
            setCursorPosition(.finish)
            return
        }
        
        let velocity = CGSize(
            width:  value.predictedEndLocation.x - value.location.x,
            height: value.predictedEndLocation.y - value.location.y
        )
        
        if velocity.width < 0, abs(velocity.width) > 150 {
            setCursorPosition(.finish)
        } else {
            setCursorPosition(.start)
        }
    }
    
}


#Preview {
    ButtonView( title: "Tap me 🔥", resetText: "Reset Me", isReset: .constant(false))
            .padding(.horizontal, 16)
    
   
}
