//
//  ProfileViewController.swift
//  PlannerDiary
//
//  Created by sama73 on 2018. 12. 31..
//  Copyright © 2018년 sama73. All rights reserved.
//

import UIKit
import UserNotifications

class ProfileViewController: UIViewController, UITextFieldDelegate {
	
    // UITextField, UITextView포커스 매니저
	var focusManager : FocusManager?
    
    // 키보드 높이
    var kbSizeHeight : CGFloat = 0.0

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfName: UnderlineTextField!
	@IBOutlet weak var tfSurName: UnderlineTextField!
	@IBOutlet weak var tfAddress: UnderlineTextField!
	@IBOutlet weak var tfPhone: UnderlineTextField!
	@IBOutlet weak var tfMobile: UnderlineTextField!
	@IBOutlet weak var tfEmail: UnderlineTextField!
	
	@IBOutlet weak var tfWorkAddress: UnderlineTextField!
	@IBOutlet weak var tfWorkPhone: UnderlineTextField!
	@IBOutlet weak var tfWorkEmail: UnderlineTextField!
	
	@IBOutlet weak var tfFavouriteFilm: UnderlineTextField!
	@IBOutlet weak var tfFavouriteBook: UnderlineTextField!
	@IBOutlet weak var tfFavouriteMusic: UnderlineTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
		
        self.focusManager = FocusManager()
        if let focusManager = self.focusManager {
            focusManager.addItem(item: self.tfName)
            focusManager.addItem(item: self.tfSurName)
            focusManager.addItem(item: self.tfAddress)
            focusManager.addItem(item: self.tfPhone)
            focusManager.addItem(item: self.tfMobile)
            focusManager.addItem(item: self.tfEmail)
            
            focusManager.addItem(item: self.tfWorkAddress)
            focusManager.addItem(item: self.tfWorkPhone)
            focusManager.addItem(item: self.tfWorkEmail)
            
            focusManager.addItem(item: self.tfFavouriteFilm)
            focusManager.addItem(item: self.tfFavouriteBook)
            focusManager.addItem(item: self.tfFavouriteMusic)
            
            focusManager.focus(index: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillShow(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        
        notifier.addObserver(self,
                             selector: #selector(self.keyboardWillHide(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self)

        super.viewWillDisappear(animated)
    }

    // iPhoneX인지 체크
    var isIphoneX : Bool {
        
        get {
            guard #available(iOS 11.0, *) else {
                return false
            }
            
            print(UIApplication.shared.windows[0].safeAreaInsets)
            if(UIApplication.shared.windows[0].safeAreaInsets.bottom != 0.0) {
                return true
            }
            
            return false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITextFieldDelegate
    // 언더라인 선택 색상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 언더라인 선택 색상 적용
        if textField is UnderlineTextField {
            focusManager!.focusTouch(item: textField)
        }
    }
    
    // 언더라인 비선택 생상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 언더라인 미선택 색상 적용
        if textField is UnderlineTextField {
            let control = textField as! UnderlineTextField
            control.updateFocus(isFocus: false)
        }
    }
    
    // 엔터키 눌렀을때 다음 컨트롤로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        if textField is UnderlineTextField {
            focusManager!.focusNext()
        }
        
        return true
    }
    
    // MARK: - NotificationCenter
    // 인포커싱 되었을때 스크롤뷰 마진값 적용
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboardWillShow")
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            // iPhoneX 스타일 경우 마진을 34만큼 더준다.
            var gapOffsetY : CGFloat = 0.0
            if self.isIphoneX == true {
                gapOffsetY = 34.0
            }
            self.kbSizeHeight = keyboardRectangle.height - gapOffsetY
            
            // 스크롤바 키보드 높이 만큼 마진주기
            let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.kbSizeHeight, right: 0)
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    // 언포커싱 되었을때 스크롤뷰 마진값 해제
    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("keyboardWillHide")
        
        // 스크롤바 마진 제거
        let contentInset: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
        
        self.kbSizeHeight = 0
    }
}
