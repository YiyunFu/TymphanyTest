//
//  TableViewCell.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        return makeLabel()
    }()
    
    lazy var idLabel: UILabel = {
        return makeLabel(color: .systemGray, size: 14)
    }()
    
    lazy var hexLabel: UILabel = {
        return makeLabel(color: .systemGray, size: 14)
    }()
    
    lazy var decimalLabel: UILabel = {
        return makeLabel(color: .systemGray, size: 14)
    }()
    
    lazy var binaryLabel: UILabel = {
        return makeLabel(color: .systemGray, size: 14)
    }()
    
    static let identifier = "TableViewCell"
    private let offset: CGFloat = 12
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUI() {
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
        ])
        
        contentView.addSubview(idLabel)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: offset),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
        ])
        
        contentView.addSubview(hexLabel)
        hexLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hexLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: offset),
            hexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
        ])
                
        contentView.addSubview(decimalLabel)
        decimalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decimalLabel.topAnchor.constraint(equalTo: hexLabel.bottomAnchor, constant: offset),
            decimalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
        ])
        
        contentView.addSubview(binaryLabel)
        binaryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            binaryLabel.topAnchor.constraint(equalTo: decimalLabel.bottomAnchor, constant: offset),
            binaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            binaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])
    }
    
    private func makeLabel(color: UIColor? = nil, size: CGFloat = 17) -> UILabel {
        let label = UILabel()
        label.textColor = color ?? .label
        label.font = UIFont.systemFont(ofSize: size)
        return label
    }
    
    func configure(_ model: BLEManagerDeviceModel) {
        nameLabel.text = "name: \(model.name)"
        idLabel.text = "id: \(model.identifier)"
        hexLabel.text = "hex value: \(model.hexValue)"
        decimalLabel.text = "decimal value: \(model.hexValue.hexToDecimal())"
        binaryLabel.text = "binary value: \(model.hexValue.hexToBinary())"
        
        nameLabel.font = model.status == .connected ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 14)
    }
}
