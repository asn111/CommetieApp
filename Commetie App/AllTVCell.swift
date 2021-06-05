//
//  AllTVCell.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Thursday03/06/2021.
//

import UIKit

class AllTVCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var bankCBBtn: UIButton!
    @IBOutlet weak var CashCBBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
