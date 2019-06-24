//
//  ReaderSettingsViewController.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/18/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit

class ModeratorSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @objc static let lightGrey = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
    @objc static let darkGrey = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
    
    @objc let roundPickerData = [
        ["Set 1", "Set 2", "Set 3", "Set 4", "Set 5", "Set 6", "Set 7", "Set 8", "Set 9"],
        ["Round 1", "Round 2", "Round 3", "Round 4", "Round 5", "Round 6", "Round 7", "Round 8", "Round 9", "Round 10", "Round 11", "Round 12", "Round 13", "Round 14", "Round 15", "Round 16", "Round 17"]
    ]
    
    @objc let tossupTimePickerData = [["5 Seconds", "10 Seconds", "15 Seconds"]]
    @objc let bonusTimePickerData = [["20 Seconds", "25 Seconds", "30 Seconds", "35 Seconds", "40 Seconds"]]
    @objc var scrollView: UIScrollView = UIScrollView()
    
    @objc lazy var mainMenuButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        button.setTitle(" Menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
        button.addTarget(self, action: #selector(ModeratorSettingsViewController.returnMainMenu), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var setChooserHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose a Question Set:"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var setRoundPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        picker.layer.cornerRadius = 10
        return picker
    }()
    
    
    @objc lazy var startSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Set", for: .normal)
        button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 63.0/255.0, alpha: 0.5)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ModeratorSettingsViewController.startReaderMode), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var timePickerHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select Round Time Limits:"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var tossupTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tossup:"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var tossupTimePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        picker.layer.cornerRadius = 10
        return picker
    }()
    
    @objc lazy var bonusTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bonus:"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var bonusTimePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        picker.layer.cornerRadius = 10
        return picker
    }()
    
    @objc lazy var roundTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8 Minute Halves:"
        label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        return label
    }()
    
    @objc lazy var roundTimerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Off", for: .normal)
        button.setTitle("On", for: .selected)
        button.setBackgroundColor(color: ModeratorSettingsViewController.lightGrey, forState: .normal)
        button.setBackgroundColor(color: ModeratorSettingsViewController.darkGrey, forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ModeratorSettingsViewController.toggleRoundTimer), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = mainMenuButton
        self.navigationItem.title = "Reader Mode"
        view.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.automaticallyAdjustsScrollViewInsets = false
        setRoundPicker.delegate = self
        setRoundPicker.dataSource = self
        tossupTimePicker.delegate = self
        tossupTimePicker.dataSource = self
        bonusTimePicker.delegate = self
        bonusTimePicker.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(setChooserHeader)
        NSLayoutConstraint.activate([
            setChooserHeader.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            setChooserHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(setRoundPicker)
        NSLayoutConstraint.activate([
            setRoundPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            setRoundPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            setRoundPicker.topAnchor.constraint(equalTo: setChooserHeader.bottomAnchor, constant: 10),
            setRoundPicker.heightAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
        
        scrollView.addSubview(timePickerHeader)
        NSLayoutConstraint.activate([
            timePickerHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePickerHeader.topAnchor.constraint(equalTo: setRoundPicker.bottomAnchor, constant: 10)
        ])
        
        scrollView.addSubview(tossupTimeLabel)
        NSLayoutConstraint.activate([
            tossupTimeLabel.leadingAnchor.constraint(equalTo: timePickerHeader.leadingAnchor, constant: 20),
            tossupTimeLabel.topAnchor.constraint(equalTo: timePickerHeader.bottomAnchor, constant: 20)
        ])
        
        scrollView.addSubview(tossupTimePicker)
        NSLayoutConstraint.activate([
            tossupTimePicker.widthAnchor.constraint(equalToConstant: 100),
            tossupTimePicker.heightAnchor.constraint(equalToConstant: 50),
            tossupTimePicker.trailingAnchor.constraint(equalTo: timePickerHeader.trailingAnchor, constant: -20),
            tossupTimePicker.centerYAnchor.constraint(equalTo: tossupTimeLabel.centerYAnchor)
        ])
        
        scrollView.addSubview(bonusTimeLabel)
        NSLayoutConstraint.activate([
            bonusTimeLabel.leadingAnchor.constraint(equalTo: tossupTimeLabel.leadingAnchor),
            bonusTimeLabel.topAnchor.constraint(equalTo: tossupTimeLabel.bottomAnchor, constant: 40)
        ])
        
        scrollView.addSubview(bonusTimePicker)
        NSLayoutConstraint.activate([
            bonusTimePicker.widthAnchor.constraint(equalToConstant: 100),
            bonusTimePicker.heightAnchor.constraint(equalToConstant: 50),
            bonusTimePicker.leadingAnchor.constraint(equalTo: tossupTimePicker.leadingAnchor),
            bonusTimePicker.centerYAnchor.constraint(equalTo: bonusTimeLabel.centerYAnchor)
        ])
        
        scrollView.addSubview(roundTimerLabel)
        NSLayoutConstraint.activate([
            roundTimerLabel.leadingAnchor.constraint(equalTo: bonusTimeLabel.leadingAnchor, constant: -6),
            roundTimerLabel.topAnchor.constraint(equalTo: bonusTimeLabel.bottomAnchor, constant: 40)
        ])
        
        scrollView.addSubview(roundTimerButton)
        NSLayoutConstraint.activate([
            roundTimerButton.widthAnchor.constraint(equalToConstant: 60),
            roundTimerButton.heightAnchor.constraint(equalToConstant: 35),
            roundTimerButton.leadingAnchor.constraint(equalTo: roundTimerLabel.trailingAnchor, constant: 10),
            roundTimerButton.centerYAnchor.constraint(equalTo: roundTimerLabel.centerYAnchor)
        ])
        
        scrollView.addSubview(startSetButton)
        NSLayoutConstraint.activate([
            startSetButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            startSetButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            startSetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSetButton.topAnchor.constraint(equalTo: roundTimerButton.bottomAnchor, constant: 30)
        ])
        
        let height = startSetButton.frame.origin.y + startSetButton.frame.height + 30
        if height <= scrollView.frame.height {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: height)
        }
    }
    
    @objc func startReaderMode() {
        let questionSetNum = setRoundPicker.selectedRow(inComponent: 0) + 1
        let roundNum = setRoundPicker.selectedRow(inComponent: 1) + 1
        let tossupTime = getTossupTimeSelected()
        let bonusTime = getBonusTimeSelected()
        let questionSet = QuestionJSONParser.shared.getQuestionSet(questionSetNum, forRound: roundNum)
        if questionSet.isEmpty {
            let alertController = UIAlertController(title: "Invalid Set", message: "The chosen question set is not available.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let isTimedRound = roundTimerButton.isSelected
            let readerController = ModeratorModeViewController(questionSet: questionSet, index: 0, tossupTime: tossupTime, bonusTime: bonusTime, isTimedRound: isTimedRound, roundTimeRemaining: 480, halfNum: 1, isTimerRunning: false)
            navigationController?.pushViewController(readerController, animated: true)
        }
    }
    
    @objc func returnMainMenu() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Button Handlers
    
    @objc func toggleRoundTimer() {
        roundTimerButton.isSelected = !roundTimerButton.isSelected;
    }
    
    // MARK: - Picker Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == setRoundPicker {
            return roundPickerData.count
        } else if pickerView == tossupTimePicker {
            return tossupTimePickerData.count
        } else if pickerView == bonusTimePicker {
            return bonusTimePickerData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == setRoundPicker {
            return roundPickerData[component].count
        } else if pickerView == tossupTimePicker {
            return tossupTimePickerData[component].count
        } else if pickerView == bonusTimePicker {
            return bonusTimePickerData[component].count
        } else {
            return 0
        }
    }
    
    // MARK: - Picker Delegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        let title: String
        if pickerView == setRoundPicker {
            title = roundPickerData[component][row]
            pickerLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.regular)
        } else if pickerView == tossupTimePicker {
            title = tossupTimePickerData[component][row]
            pickerLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        } else if pickerView == bonusTimePicker {
            title = bonusTimePickerData[component][row]
            pickerLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        } else {
            title = ""
        }
        pickerLabel?.text = title
        pickerLabel?.textColor = UIColor.white
        return pickerLabel!
    }
    
    @objc func getTossupTimeSelected() -> Int {
        let index = tossupTimePicker.selectedRow(inComponent: 0)
        switch index {
        case 0: return 5
        case 1: return 10
        case 2: return 15
        default: return 0
        }
    }
    
    @objc func getBonusTimeSelected() -> Int {
        let index = bonusTimePicker.selectedRow(inComponent: 0)
        switch index {
        case 0: return 20
        case 1: return 25
        case 2: return 30
        case 3: return 35
        case 4: return 40
        default: return 0
        }
    }
}
