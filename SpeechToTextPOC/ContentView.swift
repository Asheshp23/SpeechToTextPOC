import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(InterviewQuestionModel.previewData){ quetion in
                NavigationLink {
                    QuestionAndAnswerView(question: quetion)
                } label: {
                    Text(quetion.questionText)
    
                }
                .listRowBackground(
                    Color.indigo.opacity(0.5)
                        .cornerRadius(8.0)
                )
            }
            .listRowSpacing(8.0)
            .listStyle(.grouped)
            .padding(.all)
        }
    }
}

#Preview {
    ContentView()
}
