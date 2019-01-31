//
//  RecorddSoundsViewController.swift
//  PitchPerfect
//
//  Created by worood on 10/19/18.
//  Copyright © 2018 worood. All rights reserved.
//

import UIKit
import AVFoundation

class RecorddSoundsViewController : UIViewController , AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view WillAppear")
    }
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        setButtons(forRecording: true)
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let recodingName = "recordedVoice.wav"
    let pathArry = [dirPath, recodingName]
        let filePath = URL(string:pathArry.joined(separator: "/"))
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
    try! audioRecorder = AVAudioRecorder(url: filePath! , settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
        
    }
    
    func setButtons(forRecording recording: Bool) {
        stopRecordButton.isEnabled = recording
        recordButton.isEnabled = !recording
        RecordingLabel.text = recording ? "Recording..." : "Tap to record"
    }
    @IBAction func stopRecording(_ sender: AnyObject) {
        setButtons(forRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender:audioRecorder.url )
        } else{
                print("record was not secceass")
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundesVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundesVC.recordedAudioURL = recordedAudioURL
        }
    }
}

