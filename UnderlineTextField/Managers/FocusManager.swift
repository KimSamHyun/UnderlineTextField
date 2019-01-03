//
//  FocusManager.swift
//  PlannerDiary
//
//  Created by 김삼현 on 01/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//
import UIKit
import Foundation

class FocusManager {

    // UITextField, UITextView 컨트롤을 배열에 관리한다.
	var arrItems : [AnyObject]
    
    // 포커싱되어 있는 컨트롤의 인덱스값
	var selectFocus : Int {
		get {
			for i in 0 ..< self.arrItems.count {
				let item = self.arrItems[i]
				if item is UnderlineTextField {
					let control = item as! UnderlineTextField
					if control.isFirstResponder {
						return i
					}
				}
                else if item is UITextField {
                    let control = item as! UITextField
                    if control.isFirstResponder {
                        return i
                    }
                }
//				else if item is UITextView {
//					return -1
//				}
			}
			
			return -1
		}
	}
    
    // Toolbar Setting
    var toolbar : UIToolbar?
    var bbiPrev : UIBarButtonItem?
    var bbiNext : UIBarButtonItem?
	
	init() {
		self.arrItems = []
	}
    
    // 키보드 툴바 설정
    func setInputAccessory() -> UIToolbar {
        
        if let toolbar = self.toolbar {
            return toolbar
        }
        else {
            self.toolbar = UIToolbar()
            self.toolbar!.barStyle = .default
            self.toolbar!.isTranslucent = true
            self.toolbar!.sizeToFit()
            
            self.bbiPrev = UIBarButtonItem.init(title: "Prev", style: .plain, target: self, action: #selector(onPrevClick(_:)))
            self.bbiNext = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(onNextClick(_:)))
            let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let bbiDone = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(onDoneClick(_:)))
            self.toolbar!.items = [self.bbiPrev!, self.bbiNext!, bbiSpacer, bbiDone]
            
            return self.toolbar!
        }
    }
    
    // 툴바에서 "Prev"버튼 클릭 이벤트
    @objc func onPrevClick(_ sender: Any) {
        self.focusPrev()
    }

    // 툴바에서 "Next"버튼 클릭 이벤트
    @objc func onNextClick(_ sender: Any) {
        self.focusNext()
    }
    
    // 툴바에서 "Done"버튼 클릭 이벤트
    @objc func onDoneClick(_ sender: Any) {
        self.focusClear()
    }

	// UITextField, UITextView 컨트롤 추가
	func addItem(item:AnyObject) {

		if item is UnderlineTextField {
			let control = item as! UnderlineTextField
            control.inputAccessoryView = setInputAccessory()
		}
        else if item is UITextField {

        }
		else if item is UITextView {
			
		}
		else {
			return
		}
		
		self.arrItems += [item]
	}
	
	// control focus index setting
    // 컨트롤 터치로 선택한 경우
    public func focusTouch(item:AnyObject) {
        for i in 0 ..< self.arrItems.count {
            let control1 = self.arrItems[i]
            if control1 is UnderlineTextField {
                // 전달 받은 컨트롤과 같으면...
                let control2 = control1 as! UnderlineTextField
                if control2 == item as! NSObject {
                    focus(index: i)
                }
            }
            else if control1 is UITextField {
                // 전달 받은 컨트롤과 같으면...
                let control2 = control1 as! UITextField
                if control2 == item as! NSObject {
                    focus(index: i)
                }
            }
//            else if item is UITextView {
//                return -1
//            }
        }
    }
    
    // 인덱스로 선택한 경우
	func focus(index:Int) {
		if index < 0 {
			return
		}
		
		if index >= self.arrItems.count {
			return
		}
		        
        // Prev 버튼 활성화 여부
        if index == 0 {
            if let bbiPrev = self.bbiPrev {
                bbiPrev.isEnabled = false
            }
        }
        else {
            if let bbiPrev = self.bbiPrev {
                bbiPrev.isEnabled = true
            }
        }
        
        // Next 버튼 활성화 여부
        if index == self.arrItems.count - 1 {
            if let bbiNext = self.bbiNext {
                bbiNext.isEnabled = false
            }
        }
        else {
            if let bbiNext = self.bbiNext {
                bbiNext.isEnabled = true
            }
        }
        
		let item = self.arrItems[index]
		if item is UnderlineTextField {
			let control = item as! UnderlineTextField
            control.becomeFirstResponder()
            // 언더라인 선택 색상 적용
            control.updateFocus(isFocus: true)
		}
		else if item is UITextField {
            let control = item as! UITextField
            control.becomeFirstResponder()
		}
        else if item is UITextView {
            
        }
		else {
			return
		}
	}
	
	// 이전 컨트롤 포커스
	func focusPrev() {
		self.focus(index: self.selectFocus - 1)
	}
	
	// 다음 컨트롤 포커스
	func focusNext() {
		self.focus(index: self.selectFocus + 1)
	}
	
	// 포커스 클리어
	func focusClear() {
		for i in 0 ..< self.arrItems.count {
			let item = self.arrItems[i]
			if item is UnderlineTextField {
				let control = item as! UnderlineTextField
				control.resignFirstResponder()
                // 언더라인 미선택 색상 적용
                control.updateFocus(isFocus: false)
			}
            else if item is UITextField {
                let control = item as! UITextField
                control.resignFirstResponder()
            }
//			else if item is UITextView {
//				return -1
//			}
		}
	}
}
