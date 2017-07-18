//
//  ReaderModeViewController.swift
//  High School Science Bowl Practice
//
//  Created by Jake Polatty on 7/18/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import UIKit

class ReaderModeViewController: UIViewController {
    var questionSet: [Question]?
    var index: Int = 0
    
    lazy var nextQuestionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Next Question", style: .plain, target: self, action: #selector(ReaderModeViewController.loadNextQuestion))
        return button
    }()
    
    lazy var roundSetNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let roundNum = self.questionSet?[self.index].roundNumber, let setNum = self.questionSet?[self.index].setNumber {
            label.text = "Question Set \(setNum) Round \(roundNum)"
        }
        return label
    }()
    
    lazy var questionNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let questionNum = self.questionSet?[self.index].questionNumber, let questionType = self.questionSet?[self.index].questionType {
            label.text = "Question \(questionNum) \(questionType)"
        }
        return label
    }()
    
    lazy var catTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let category = self.questionSet?[self.index].category, let answerType = self.questionSet?[self.index].answerType {
            label.text = "\(String(describing: category)) \(String(describing: answerType))"
        }
        return label
    }()
    
    lazy var questionTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        if let questionText = self.questionSet?[self.index].questionText {
            label.text = questionText
        }
        return label
    }()
    
    init(questionSet: [Question], index: Int) {
        self.questionSet = questionSet
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = nextQuestionButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(roundSetNumLabel)
        NSLayoutConstraint.activate([
            roundSetNumLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            roundSetNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(questionNumLabel)
        NSLayoutConstraint.activate([
            questionNumLabel.topAnchor.constraint(equalTo: roundSetNumLabel.bottomAnchor, constant: 10),
            questionNumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(catTypeLabel)
        NSLayoutConstraint.activate([
            catTypeLabel.topAnchor.constraint(equalTo: questionNumLabel.bottomAnchor, constant: 10),
            catTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(questionTextLabel)
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: catTypeLabel.bottomAnchor, constant: 10),
            questionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func loadNextQuestion() {
        if let questionSet = questionSet {
            let nextQuestionController = ReaderModeViewController(questionSet: questionSet, index: index+1)
            navigationController?.pushViewController(nextQuestionController, animated: true)
        }
    }
}
