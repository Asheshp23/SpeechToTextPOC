import SwiftUI
import Speech
import AVFoundation

struct QuestionAndAnswerView: View {
    var question: InterviewQuestionModel
    
    @State private var openAnswerTextBox: Bool = false
    @State private var isRecording: Bool = false
    
    @StateObject var speechTranscriber: SpeechTranscriber = SpeechTranscriber()
    
    var recordingButtonView: some View {
        Circle()
            .stroke(Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .padding(.all)
            .frame(width: 100, height: 100)
            .overlay(alignment: .center) {
                Circle()
                    .foregroundColor(Color.red.opacity(0.5))
                Image(systemName: isRecording ? "square.fill" : "mic.fill")
                    .font(.title)
                    .accessibilityLabel(isRecording ? "Recording" : "Not Recording")
                    .foregroundColor(.red)
                    .bold()
            }
    }
    
    var answerView: some View {
        VStack(alignment: .leading) {
            Text("Answer:")
            if openAnswerTextBox {
                TextEditor(text: $speechTranscriber.transcript)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        if !isRecording {
                            Text("Tap to start")
                                .foregroundColor(.red)
                                .bold()
                        }
                        recordingButtonView
                            .onTapGesture {
                                withAnimation {
                                    isRecording.toggle()
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                }
                            }
                    }
                    Spacer()
                }
            } else {
                Button {
                    openAnswerTextBox.toggle()
                } label: {
                    Text("Tap here to answer the question")
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    Color.mint
                )
                .cornerRadius(7.0)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(question.questionText)
                Spacer()
            }
            HStack {
                answerView
                Spacer()
            }
            Spacer()
        }
        .onChange(of: isRecording, initial: false, { oldValue, newValue in
            handleRecordingStateChange(newValue)
        })
        .padding(.all)
        .background(
            Color.indigo.opacity(0.5)
                .cornerRadius(8.0)
        )
        .padding(.all)
    }
    
    private func handleRecordingStateChange(_ isRecording: Bool) {
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    private func startRecording() {
        speechTranscriber.resetTranscript()
        speechTranscriber.startTranscribing()
        isRecording = true
    }
    
    private func stopRecording() {
        speechTranscriber.stopTranscribing()
        isRecording = false
    }
}
