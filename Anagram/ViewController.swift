//
//  ViewController.swift
//  Anagram
//
//  Created by Alexander Bagmut on 10/3/16.
//  Copyright © 2016 Alexander Bagmut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{
	let textField1 = UITextField()
	let textField2 = UITextField()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.gray
		
		textField1.returnKeyType = .next
		commonTextFieldSetup(textField: textField1)
		
		textField2.returnKeyType = .go
		commonTextFieldSetup(textField: textField2)
		
		let checkButton = UIButton(type: .system)
		checkButton.translatesAutoresizingMaskIntoConstraints = false
		checkButton.backgroundColor = UIColor.darkGray
		checkButton.addTarget(self, action: #selector(onCheckButtonPress), for: .touchUpInside)
		checkButton.setTitle(NSLocalizedString("Check", comment: ""), for: .normal)
		view.addSubview(checkButton)
		
		
		// Layout
		let spacing = 10
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(spacing)-[textField1]-\(spacing)-[textField2]-\(spacing)-|",
		                                                   options: .alignAllCenterY,
		                                                   metrics: nil,
		                                                   views: ["textField1": textField1,
		                                                           "textField2": textField2]))
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(spacing)-[checkButton]-\(spacing)-|",
		                                                   options: [],
		                                                   metrics: nil,
		                                                   views: ["checkButton": checkButton]))
		view.addConstraint(NSLayoutConstraint(item: textField1,
		                                      attribute: .width,
		                                      relatedBy: .equal,
		                                      toItem: textField2,
		                                      attribute: .width,
		                                      multiplier: 1,
		                                      constant: 0))
		
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[textField1]-\(spacing)-[checkButton]",
		                                                   options: [],
		                                                   metrics: nil,
		                                                   views: ["textField1": textField1,
		                                                           "checkButton": checkButton]))
	}
	
// MARK: - Check anagram
	func checkIsAnagram(str1: String, str2: String) -> Bool
	{
		let normalizedStr1 = str1.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() // assume that case is irrelevant
		let normalizedStr2 = str2.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		
		if normalizedStr1.characters.count != normalizedStr2.characters.count
		{
			return false;
		}
		
		if normalizedStr1 == normalizedStr2
		{
			return true // if strings are the same assume that they are anagram of one another
		}

		// This algorithm has O(n) complexity
		//
		return charactersFrequency(str: normalizedStr1) == charactersFrequency(str: normalizedStr2)
		
		// This algorithm is simpler but has worse complexity - O(n*log(n))
		//
//		let sortedCharactersString1 = String(normalizedStr1.characters.sorted())
//		let sortedCharactersString2 = String(normalizedStr2.characters.sorted())
//		return sortedCharactersString1 == sortedCharactersString2
	}
	
	func charactersFrequency(str: String) -> [Character: Int]
	{
		var charactersFrequancy = [Character: Int]()
		for char in str.characters
		{
			charactersFrequancy[char] = (charactersFrequancy[char] ?? 0) + 1
		}
		return charactersFrequancy
	}

// MARK: - Common setup
	func commonTextFieldSetup(textField: UITextField) -> Void
	{
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.delegate = self
		view.addSubview(textField)
	}
	
// MARK: - Actions
	func onCheckButtonPress() -> Void
	{
		var message: String?
		
		if let str1 = textField1.text, str1.characters.count > 0,
		   let str2 = textField2.text, str2.characters.count > 0
		{
			view.endEditing(true)
			
			let isAnagram = checkIsAnagram(str1: str1, str2: str2)
			message = "'\(str2)' is \(isAnagram ? "" : "not ")an anagram of '\(str1)'"
		}
		else
		{
			message = "You should fill in both fields"
		}
		
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
// MARK: - UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if textField == textField1
		{
			textField2.becomeFirstResponder()
		}
		else if textField == textField2
		{
			onCheckButtonPress()
		}
		return true
	}
}

