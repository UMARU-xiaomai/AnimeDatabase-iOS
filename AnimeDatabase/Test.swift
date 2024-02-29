import SwiftUI

struct TestView: View {
    @State private var isTextVisible = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if isTextVisible {
                        Text("This is a long text. You can scroll left to reveal the entire text.")
                            .font(.title)
                            .padding()
                    }
                }
            }
            .frame(height: 50)
            .background(Color.gray.opacity(0.2))
            
            Spacer()
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width < -30 {
                        isTextVisible = true
                    }
                }
                .onEnded { value in
                    if value.translation.width > -30 {
                        isTextVisible = false
                    }
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
