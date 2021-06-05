//
//  HeaderTVCell.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Thursday03/06/2021.
//

import UIKit

class HeaderTVCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var amountDetailView: UIView!
    
    @IBOutlet weak var bankAmountLbl: UILabel!
    @IBOutlet weak var cashAmountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    //MARK: Properties
    
    var viewModel: MonthsModel? {
        didSet{
            bindViewModel()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //bindViewModel()
        //set cell to initial state here
        //set like button to initial state - title, font, color, etc.
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
                headerView.isHidden = true
                amountDetailView.isHidden = false
            
            bankAmountLbl.text = "\(viewModel.bankAmount)"
            cashAmountLbl.text = "\(viewModel.cashAmount)"
            totalAmountLbl.text = "Total\n\(viewModel.totalCollection)\nPKR"
        }
    }
    
}
