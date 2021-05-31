//
//  ViewController.swift
//  TipCalculator
//
//  Created by Dylan Park on 2021-05-12.
//

import UIKit

class ViewController: UIViewController {

  let scrollView = UIScrollView()
  
  let totalAmountValueLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "$00.00"
    lbl.font = .boldSystemFont(ofSize: 50)
    return lbl
  }()

  let totalAmountLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Total Amount"
    lbl.font = .boldSystemFont(ofSize: 25)
    return lbl
  }()
  
  let amountTextField: UITextField = {
    let tf = UITextField()
    tf.becomeFirstResponder()
    tf.placeholder = "Bill Amount"
    tf.borderStyle = .roundedRect
    tf.textAlignment = .center
    tf.font = .boldSystemFont(ofSize: 35)
    tf.widthAnchor.constraint(equalToConstant: 250).isActive = true
    tf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
    return tf
  }()
  
  let tipPercentageLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Tip Percentage"
    lbl.font = .boldSystemFont(ofSize: 25)
    return lbl
  }()
  
  var percent = 15
  let slider: UISlider = {
    let s = UISlider()
    s.minimumValue = 0
    s.maximumValue = 100
    s.setValue(15.0, animated: false)
    s.widthAnchor.constraint(equalToConstant: 250).isActive = true
    s.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    return s
  }()
  
  let tipPercentageValueLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "15 %"
    lbl.font = .boldSystemFont(ofSize: 50)
    return lbl
  }()
  
  let calculateTipButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("Calculate Tip", for: .normal)
    btn.layer.cornerRadius = 8
    btn.backgroundColor = .blue
    btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
    btn.titleLabel?.font = .boldSystemFont(ofSize: 35)
    btn.addTarget(self, action: #selector(calculateTip), for: .touchUpInside)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Calculate Tip"
    navigationController?.navigationBar.prefersLargeTitles = true
    amountTextField.delegate = self
    setupViewLayout()
    registerForKeyboardNotification()
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  fileprivate func registerForKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardDidShow(_ notification: NSNotification) {
    guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardFrame = keyboardFrameValue.cgRectValue
    let keyboardHeight = keyboardFrame.size.height
    
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + (view.frame.height * 0.25), right: 0)
    scrollView.contentInset = insets
    scrollView.scrollIndicatorInsets = insets
  }
  
  @objc func keyboardWillBeHidden(_ notification: NSNotification) {
    let insets: UIEdgeInsets = .zero
    scrollView.contentInset = insets
    scrollView.scrollIndicatorInsets = insets
  }
  
  fileprivate func setupViewLayout() {
    let vStackView = UIStackView(arrangedSubviews: [totalAmountValueLabel, totalAmountLabel, UIView(), amountTextField, UIView(), tipPercentageLabel, slider, tipPercentageValueLabel, UIView(), calculateTipButton])
    vStackView.axis = .vertical
    vStackView.distribution = .equalSpacing
    vStackView.alignment = .center
    vStackView.spacing = 30
    vStackView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    
    scrollView.addSubview(vStackView)
    vStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
    vStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
    vStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
    vStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
    vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
  }

  @objc func calculateTip() {
    guard let text = amountTextField.text, let amount = Double(text), amount > 0.0 else {
      totalAmountValueLabel.text = "$00.00"
      return
    }

    let total = percent == 0 ? amount : amount + (amount * Double(percent)/100)
    totalAmountValueLabel.text = String(format: "$%.2f", total)
  }

  @objc func sliderValueChanged(_ sender: UISlider) {
    percent = Int(sender.value)
    tipPercentageValueLabel.text = String(format: "%d%%", percent)
    calculateTip()
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" { totalAmountValueLabel.text = "$00.00" }
    else { calculateTip() }
  }
}
