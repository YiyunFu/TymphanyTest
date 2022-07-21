//
//  CustomNavigationBar.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit

class CustomNavigationBar: UIView {
    
    enum ButtonType {
        case left, right
    }
    
    enum StyleType {
        case none, black, white
    }
    
    lazy var defaultLeftImage: UIImage? = {
        return UIImage(systemName: "arrow.left")
    }()
    
    lazy var defaultRightImage: UIImage? = {
        return UIImage(systemName: "arrow.right")
    }()
    
    
    var clickedClosure: ((CustomNavigationBar.ButtonType) -> Void)?
    
    private var titleText: String? {
        get { return navigationTitle.text }
        set {
            navigationTitle.text = newValue
            if let value = newValue {
                navigationTitle.isHidden = value.isEmpty
            }
        }
    }
    private var leftImage: UIImage? {
        get { return leftButton.imageView?.image }
        set {
            leftButton.setImage(newValue, for: .normal)
            leftButton.isHidden = newValue == nil
        }
    }
    
    private var rightImage: UIImage? {
        get { return rightButton.imageView?.image }
        set {
            rightButton.setImage(newValue, for: .normal)
            rightButton.isHidden = newValue == nil
        }
    }
    
    var rightTitle: String? {
        get { return rightButton.titleLabel?.text }
        set {
            rightButton.setTitle(newValue, for: .normal)
            if rightButton.imageView?.image == nil {
                rightButton.isHidden = newValue == nil
            }
        }
    }
    
    private var styleType: StyleType = .none {
        didSet {
            switch styleType {
            case .black:
                self.tintColor = .black
                self.rightButton.setTitleColor(.black,
                                               for: .normal)
                self.leftButton.setTitleColor(.black,
                                               for: .normal)
                self.navigationTitle.textColor = .black
            case .white:
                self.tintColor = .white
                self.rightButton.setTitleColor(.white,
                                               for: .normal)
                self.leftButton.setTitleColor(.white,
                                               for: .normal)
                self.navigationTitle.textColor = .white
            case .none:
                break
            }
        }
    }
    
    lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(RightButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
        ])
        
        addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor),
        ])

        addSubview(navigationTitle)
        navigationTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationTitle.topAnchor.constraint(equalTo: self.topAnchor),
            navigationTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            navigationTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            navigationTitle.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -5),
            navigationTitle.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 5),
        ])
    }
    
    func settingNavigationBar(title: String? = nil, titleAlignment: NSTextAlignment? = .left, leftImage: UIImage? = nil, rightImage: UIImage? = nil, rightTitle: String? = nil, style: StyleType = .none, clickedClosure: ((CustomNavigationBar.ButtonType) -> Void)? = nil) {
        self.titleText = title
        self.navigationTitle.textAlignment = titleAlignment ?? .left
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.rightTitle = rightTitle
        self.clickedClosure = clickedClosure
        self.styleType = style
    }
    
    @objc func leftButtonClicked() {
        clickedClosure?(.left)
    }
    
    @objc func RightButtonClicked() {
        clickedClosure?(.right)
    }
    
    deinit {
        clickedClosure = nil
    }
    
}
