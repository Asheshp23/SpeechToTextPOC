import SwiftUI
import Speech
import AVFoundation
import DSWaveformImage
import DSWaveformImageViews

struct QuestionAndAnswerView: View {
    var question: InterviewQuestionModel
    private static let colors = [UIColor.systemPink, UIColor.systemBlue, UIColor.systemGreen]
    private static var randomColor: UIColor { colors.randomElement()! }
    
    @State private var openAnswerTextBox: Bool = false
    @State private var fullTranscript: String = ""
    @State private var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .red, width: 3, spacing: 3)), damping: .init(percentage: 0.05,sides: .both)
    )
    @State private var silence: Bool = true
    
    @StateObject var speechTranscriber: SpeechTranscriber = SpeechTranscriber()
    
    var recordingButtonView: some View {
        Circle()
            .stroke(Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .padding(.all)
            .frame(width: 100, height: 100)
            .overlay(alignment: .center) {
                Circle()
                    .foregroundColor(Color.red.opacity(0.5))
                Image(systemName: speechTranscriber.isRecording ? "square.fill" : "mic.fill")
                    .font(.title)
                    .accessibilityLabel(speechTranscriber.isRecording ? "Recording" : "Not Recording")
                    .foregroundColor(.red)
                    .bold()
            }
    }
    
    var answerView: some View {
        VStack(alignment: .leading) {
            Text("Answer:")
            if openAnswerTextBox {
                if speechTranscriber.isRecording {
                    Text(computeFullTranscript())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                    
                    WaveformLiveCanvas(
                        samples: speechTranscriber.channelDataValueArray,
                        configuration: liveConfiguration,
                        renderer: LinearWaveformRenderer(),
                        shouldDrawSilencePadding: silence
                    )
                } else {
                    TextEditor(text: $fullTranscript)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        if !speechTranscriber.isRecording {
                            Text("Tap to start")
                                .foregroundColor(.red)
                                .bold()
                        }
                        recordingButtonView
                            .onTapGesture {
                                withAnimation {
                                    speechTranscriber.isRecording.toggle()
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
        .onChange(of: speechTranscriber.isRecording, initial: false, { oldValue, newValue in
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
    }
    
    fileprivate func computeFullTranscript() -> String {
        if fullTranscript.isEmpty {
            return speechTranscriber.transcript
        } else {
            return fullTranscript + ((fullTranscript.last == ".") ? "" : "." + "\n\(speechTranscriber.transcript)")
        }
    }
    
    private func stopRecording() {
        fullTranscript = computeFullTranscript()
        speechTranscriber.stopTranscribing()
    }
}
