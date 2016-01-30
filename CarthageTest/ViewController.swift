//
//  ViewController.swift
//  CarthageTest
//
//  Created by Anton Efimenko on 29.01.16.
//  Copyright © 2016 Anton Efimenko. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var label: UILabel!
	
	let model = SimpleModel()
	
//	var textFieldText = MutableProperty<String>("")
//	var labelText = MutableProperty<String>("")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model.text <~ textField.rac_text
		//textField.rac_text <~ model.text
		
//		
//		textFieldText.signal.observeNext {
//			next in self.textField.text = next
//		}
//		
//		labelText.signal.observeNext {
//			next in self.label.text = next
//		}
//		
//		labelText <~ textFieldText
		
		let (signal, observer) = Signal<String, NoError>.pipe()
		signal
			.map { string in string.uppercaseString }
			.observeNext { next in print(next) }
		observer.sendNext("ololo")
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func tapButton(sender: AnyObject) {
		//model.text.value = "AAA"
		//textField.resignFirstResponder()
		textField.rac_text.value = "AAA"
		label.text = model.text.value
		//model.text.value = "ololo"
	}
	
}

