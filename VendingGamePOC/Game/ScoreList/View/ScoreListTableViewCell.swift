//
//  ScoreListTableViewCell.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 23.10.2021.
//

import UIKit

class ScoreListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    func setup() {
        self.contentView.layer.cornerRadius = 15.0
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 3.0
        self.layer.masksToBounds = true
        self.contentView.layer.masksToBounds = true
        self.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
