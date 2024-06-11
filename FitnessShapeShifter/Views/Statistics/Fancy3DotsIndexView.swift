
import SwiftUI

struct Fancy3DotsIndexView: View {
  
  
  let numberOfPages: Int
  let currentIndex: Int
  
  
  private let circleSize: CGFloat = 12
  private let circleSpacing: CGFloat = 12
  
  private let primaryColor = Color.white
  private let secondaryColor = Color.white.opacity(0.6)
  
  private let smallScale: CGFloat = 0.6
  
  
  // MARK: - Body
  
    var body: some View {
        VStack{
            Spacer()
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages) { index in // 1
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? Color.accentColor2 : .gray) // 2
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                    
                        .frame(width: circleSize, height: circleSize)
                    
                        .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                    
                        .id(index) // 4
                }
            }
        }
    }
        .frame(height: 340)
  }
  
  
  // MARK: - Private Methods
  
  func shouldShowIndex(_ index: Int) -> Bool {
    ((currentIndex - 1)...(currentIndex + 1)).contains(index)
  }
}
