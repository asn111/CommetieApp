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
    
    @IBOutlet weak var allThingsView: UIView!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var memberNameLbl: UILabel!
    
    @IBOutlet weak var amountDetailView: UIView!
    @IBOutlet weak var bankAmountLbl: UILabel!
    @IBOutlet weak var cashAmountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    var viewModel: MonthsModel? {
        didSet{
            bindViewModel()
        }
    }
    
    
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
    
    func bindViewModel() {
        if let viewModel = viewModel {
            allThingsView.isHidden = true
            amountDetailView.isHidden = false
            
            bankAmountLbl.text = "\(viewModel.bankAmount)"
            cashAmountLbl.text = "\(viewModel.cashAmount)"
            totalAmountLbl.text = "Total\n\(viewModel.totalCollection)\nPKR"
        }
    }
    
}
