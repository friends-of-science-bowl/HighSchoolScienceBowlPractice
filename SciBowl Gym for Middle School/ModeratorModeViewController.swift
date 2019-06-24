//
//  ReaderModeViewController.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/18/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit
import RichTextView

class ModeratorModeViewController: UIViewController, UIScrollViewDelegate {
    var questionSet: [Question]?
    @objc var index: Int = 0
    @objc var seconds: Int = 0
    @objc var tossupTime: Int = 0
    @objc var bonusTime: Int = 0
    @objc var questionTimer = Timer()
    @objc var contentOffset: CGFloat = 0
    @objc var scrollView: UIScrollView = UIScrollView()
    
    @objc var isTimedRound: Bool = false
    @objc var roundTimeRemaining: Int = 0
    @objc var halfNum: Int = 0
    @objc var isTimerRunning: Bool = false
    @objc var roundTimer = Timer()
    
    @objc lazy var mainMenuButton: UIBarButtonItem? = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        button.setTitle(" Menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
        button.sizeToFit()
        button.addTarget(self, action: #selector(ModeratorModeViewController.returnMainMenu), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var nextQuestionButton: UIBarButtonItem = {
        let count = self.questionSet?.count ?? 0
        let button: UIButton
        if self.index == count - 1 {
            button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "Forward Chevron"), for: .normal)
            button.setTitle("Finish Set ", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
            button.sizeToFit()
            button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.addTarget(self, action: #selector(ModeratorModeViewController.finishSet), for: .touchUpInside)
        } else {
            button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "Forward Chevron"), for: .normal)
            button.setTitle("Next ", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
            button.sizeToFit()
            button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.addTarget(self, action: #selector(ModeratorModeViewController.loadNextQuestion), for: .touchUpInside)
        }
        return UIBarButtonItem(customView: button)
    }()
    
    @objc lazy var roundSetNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let roundNum = self.questionSet?[self.index].roundNumber, let setNum = self.questionSet?[self.index].setNumber {
            label.text = "Question Set \(setNum) Round \(roundNum)"
        }
        return label
    }()
    
    @objc lazy var questionNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let questionNum = self.questionSet?[self.index].questionNumber, let questionType = self.questionSet?[self.index].questionType {
            label.text = "Question \(questionNum) \(questionType)"
        }
        return label
    }()
    
    @objc lazy var catTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        if let category = self.questionSet?[self.index].category, let answerType = self.questionSet?[self.index].answerType {
            label.text = "\(String(describing: category)) \(String(describing: answerType))"
        }
        return label
    }()
    
    @objc lazy var questionTextLabel: UIView = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium),
            textColor: UIColor.white,
            frame: CGRect.zero
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        if let questionText = self.questionSet?[self.index].questionText {
            label.update(input: questionText)
        }
        return label
    }()
    
    @objc lazy var answerOptionsLabel: UIView? = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold),
            textColor: UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0),
            frame: CGRect.zero
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        if let answerChoices = self.questionSet?[self.index].answerChoices {
            if answerChoices.count > 0 {
                label.update(input: "\(answerChoices[0])<br>\(answerChoices[1])<br>\(answerChoices[2])<br>\(answerChoices[3])")
                return label
            } else {
                return nil
            }
        } else {
            return nil
        }
    }()
    
    @objc lazy var questionAnswerLabel: UIView = {
        let label = RichTextView(
            font: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy),
            textColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9),
            frame: CGRect.zero
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        if let answerText = self.questionSet?[self.index].answer {
            label.update(input: "<div align='center'>Answer:<br>\(answerText)</div>")
        }
        return label
    }()
    
    @objc lazy var startTimerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Timer", for: .normal)
        button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 63.0/255.0, alpha: 0.5)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ModeratorModeViewController.startTimerPressed), for: .touchUpInside)
        return button
    }()
    
    @objc lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        label.isHidden = true
        label.text = "\(self.seconds) Seconds Left"
        return label
    }()
    
    @objc lazy var timerBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 89.0/255.0, green: 185.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        return view
    }()
    
    @objc lazy var roundTimeHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.text = "Round Timer:"
        return label
    }()
    
    @objc lazy var roundTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        label.textColor = UIColor.white
        label.text = "8:00 (Half 1)"
        return label
    }()
    
    @objc lazy var roundTimerStartToggle: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Timer", for: .normal)
        button.setTitle("Pause", for: .selected)
        button.setBackgroundColor(color: UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5), forState: .normal)
        button.setBackgroundColor(color: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7), forState: .selected)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(ModeratorModeViewController.toggleRoundTimer), for: .touchUpInside)
        return button
    }()
    
    init(questionSet: [Question], index: Int, tossupTime: Int, bonusTime: Int, isTimedRound: Bool, roundTimeRemaining: Int, halfNum: Int, isTimerRunning: Bool) {
        self.questionSet = questionSet
        self.index = index
        self.tossupTime = tossupTime
        self.bonusTime = bonusTime
        
        self.isTimedRound = isTimedRound
        if (isTimedRound) {
            self.roundTimeRemaining = roundTimeRemaining
            self.halfNum = halfNum
            self.isTimerRunning = isTimerRunning
        }
        
        if questionSet[index].questionType == .tossup {
            self.seconds = tossupTime
        } else {
            self.seconds = bonusTime
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = nextQuestionButton
        self.navigationItem.leftBarButtonItem = mainMenuButton
        self.navigationItem.title = "Moderator Mode"
        scrollView.delegate = self
        
        if (isTimedRound) {
            roundTimeLabel.text = getRoundTimerString()
            
            if (roundTimeRemaining <= 1) {
                roundTimeLabel.text = "Round Over"
                roundTimerStartToggle.isHidden = true
                roundTimerStartToggle.isSelected = false
            } else if (roundTimeRemaining < 480) {
                roundTimerStartToggle.setTitle("Resume", for: .normal)
                roundTimerStartToggle.isSelected = false
            }
            
            if (isTimerRunning) {
                roundTimerStartToggle.isSelected = true
                runRoundTimer()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(red: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        if (isTimedRound) {
            view.addSubview(timerBar)
            NSLayoutConstraint.activate([
                timerBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                timerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                timerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                timerBar.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            timerBar.addSubview(roundTimeHeader)
            NSLayoutConstraint.activate([
                roundTimeHeader.centerYAnchor.constraint(equalTo: timerBar.centerYAnchor),
                roundTimeHeader.leadingAnchor.constraint(equalTo: timerBar.leadingAnchor, constant: 10)
            ])
            
            timerBar.addSubview(roundTimeLabel)
            NSLayoutConstraint.activate([
                roundTimeLabel.centerYAnchor.constraint(equalTo: timerBar.centerYAnchor),
                roundTimeLabel.leadingAnchor.constraint(equalTo: roundTimeHeader.trailingAnchor, constant: 4)
            ])
            
            timerBar.addSubview(roundTimerStartToggle)
            NSLayoutConstraint.activate([
                roundTimerStartToggle.widthAnchor.constraint(equalToConstant: 100),
                roundTimerStartToggle.heightAnchor.constraint(equalToConstant: 35),
                roundTimerStartToggle.centerYAnchor.constraint(equalTo: timerBar.centerYAnchor),
                roundTimerStartToggle.trailingAnchor.constraint(equalTo: timerBar.trailingAnchor, constant: -10)
            ])
            
            view.addSubview(scrollView)
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: timerBar.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            view.addSubview(scrollView)
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        scrollView.addSubview(roundSetNumLabel)
        NSLayoutConstraint.activate([
            roundSetNumLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            roundSetNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        scrollView.addSubview(questionNumLabel)
        NSLayoutConstraint.activate([
            questionNumLabel.topAnchor.constraint(equalTo: roundSetNumLabel.bottomAnchor, constant: 10),
            questionNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(catTypeLabel)
        NSLayoutConstraint.activate([
            catTypeLabel.topAnchor.constraint(equalTo: questionNumLabel.bottomAnchor, constant: 10),
            catTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(questionTextLabel)
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: catTypeLabel.bottomAnchor, constant: 10),
            questionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        scrollView.addSubview(questionAnswerLabel)
        NSLayoutConstraint.activate([
            questionAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        scrollView.addSubview(startTimerButton)
        NSLayoutConstraint.activate([
            startTimerButton.widthAnchor.constraint(equalToConstant: 120),
            startTimerButton.heightAnchor.constraint(equalToConstant: 44),
            startTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startTimerButton.topAnchor.constraint(equalTo: questionAnswerLabel.bottomAnchor, constant: 10),
        ])
        
        scrollView.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: startTimerButton.centerYAnchor)
        ])
        
        if let answerOptionsLabel = answerOptionsLabel {
            scrollView.addSubview(answerOptionsLabel)
            NSLayoutConstraint.activate([
                answerOptionsLabel.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 20),
                answerOptionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                answerOptionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                questionAnswerLabel.topAnchor.constraint(equalTo: answerOptionsLabel.bottomAnchor, constant: 30)
            ])
        } else {
            NSLayoutConstraint.activate([
                questionAnswerLabel.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 30)
            ])
        }
        
        let height = startTimerButton.frame.origin.y + startTimerButton.frame.height + 30
        if height <= scrollView.frame.height {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
    }
    
    // MARK: - Round Timer
    
    @objc func toggleRoundTimer() {
        if (!roundTimerStartToggle.isSelected) {
            runRoundTimer()
            roundTimerStartToggle.isSelected = true
            roundTimerStartToggle.setTitle("Resume", for: .normal)
        } else {
            roundTimer.invalidate()
            isTimerRunning = false
            roundTimerStartToggle.isSelected = false
        }
    }
    
    @objc func runRoundTimer() {
        isTimerRunning = true
        roundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ModeratorModeViewController.updateRoundTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateRoundTimer() {
        if roundTimeRemaining == 1 {
            roundTimer.invalidate()
            isTimerRunning = false
            if (halfNum == 1) {
                roundTimeLabel.text = "Halftime"
                roundTimerStartToggle.setTitle("Start Half 2", for: .normal)
                roundTimerStartToggle.isSelected = false
                isTimerRunning = false
                roundTimeRemaining = 480
                halfNum = 2
            } else {
                roundTimeLabel.text = "Round Over"
                roundTimerStartToggle.isHidden = true
                roundTimerStartToggle.isSelected = false
                isTimerRunning = false
            }
        } else {
            roundTimeRemaining -= 1
            roundTimeLabel.text = getRoundTimerString()
        }
    }
    
    @objc func getRoundTimerString() -> String {
        let minutes = (roundTimeRemaining / 60) % 60
        let seconds = roundTimeRemaining % 60
        return String(format: "%i:%02i (Half %i)", minutes, seconds, halfNum)
    }
    
    // MARK: - Navigation
    
    @objc func loadNextQuestion() {
        if (isTimerRunning) {
            roundTimer.invalidate()
        }
        if let questionSet = questionSet {
            let nextQuestionController = ModeratorModeViewController(questionSet: questionSet, index: index+1, tossupTime: tossupTime, bonusTime: bonusTime, isTimedRound: isTimedRound, roundTimeRemaining: roundTimeRemaining, halfNum: halfNum, isTimerRunning: isTimerRunning)
            navigationController?.pushViewController(nextQuestionController, animated: true)
        }
    }
    
    @objc func returnMainMenu() {
        if (isTimerRunning) {
            roundTimer.invalidate()
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func finishSet() {
        if (isTimerRunning) {
            roundTimer.invalidate()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Question Timer
    
    @objc func startTimerPressed() {
        runTimer()
        startTimerButton.isHidden = true
        timerLabel.isHidden = false
    }
    
    @objc func runTimer() {
        questionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ModeratorModeViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 1 {
            questionTimer.invalidate()
            timerLabel.text = "Time's Up"
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds) Seconds Left"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffset = scrollView.contentOffset.y
    }
}
