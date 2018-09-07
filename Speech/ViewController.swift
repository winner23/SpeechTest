//
//  ViewController.swift
//  Speech
//
//  Created by Volodymyr Viniarskyi on 9/6/18.
//  Copyright © 2018 Volodymyr Viniarskyi. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate{

    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recognizedTextLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func recordAndRecognizeSpeech() {
        //Initial defenition and preparation
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in
            self.request.append(buffer)
        }
        //Prepare engine to start
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        //Use to detect availability of speech recognizer
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable {
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.recognizedTextLabel.text = result.bestTranscription.formattedString
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func startStopButtonTouched(_ sender: UIButton) {
        recordAndRecognizeSpeech()
    }
}
