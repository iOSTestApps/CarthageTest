//
//  UIReactiveExtensions.swift
//  CarthageTest
//
//  Created by Anton Efimenko on 30.01.16.
//  Copyright © 2016 Anton Efimenko. All rights reserved.
//

import UIKit
import ReactiveCocoa

struct AssociationKey {
	static var hidden: UInt8 = 1
	static var alpha: UInt8 = 2
	static var text: UInt8 = 3
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
	return objc_getAssociatedObject(host, key) as? T ?? {
		let associatedProperty = factory()
		objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		return associatedProperty
  }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
	return lazyAssociatedProperty(host, key: key) {
		let property = MutableProperty<T>(getter())
		property.producer
			.startWithNext{
				newValue in
				setter(newValue)
		}
		
		return property
	}
}

extension UILabel {
	public var rac_text: MutableProperty<String> {
		return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
	}
}

extension UITextField {
	public var rac_text: MutableProperty<String> {
		return lazyAssociatedProperty(self, key: &AssociationKey.text) {			
			self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingDidEnd)
			let property = MutableProperty<String>(self.text ?? "")
//			property.signal.observeNext {
//				s in print("Observe next \(s)")
//			}
			property.producer
				.startWithNext {
					newValue in
					print("set new value \(newValue)")
					self.text = newValue
			}
			return property
		}
	}
	
	func changed() {
		print("changed \(self.text)")
		rac_text.value = self.text ?? ""
	}
}