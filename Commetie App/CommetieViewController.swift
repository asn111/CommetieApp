//
//  ViewController.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Wednesday02/06/2021.
//

import UIKit
import SwiftDate
import RealmSwift
import RxRealm
import RxSwift
import RxCocoa

class CommetieViewController: UIViewController {

    @IBOutlet weak var allThingsTV: UITableView!
    
    var candidateList : Results<Candidate>!
    var monthList : Results<MonthsModel>!
    var paymentMonth = ""
    var bankAmount = 0
    var cashAmount = 0
    var totalAmount = 0
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        allThingsTV.tableFooterView = UIView()
        allThingsTV.delegate = self
        allThingsTV.dataSource = self

        self.title = paymentMonth
        
        allThingsTV.register(UINib(nibName: "AllTVCell", bundle: nil), forCellReuseIdentifier: "AllTVCell")
        allThingsTV.register(UINib(nibName: "HeaderTVCell", bundle: nil), forCellReuseIdentifier: "HeaderTVCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doTheRealmThing()
    }
    
    func doTheRealmThing(){
        let realm = try! Realm()
        candidateList = realm.objects(Candidate.self).filter(NSPredicate(format: "paymentMonth == %@", paymentMonth)).sorted(byKeyPath: "cName", ascending: true)
        monthList = realm.objects(MonthsModel.self).filter(NSPredicate(format: "mName == %@", paymentMonth))
        //Logs.value(message: "LIST: \(monthList)")
        Observable.changeset(from: candidateList)
            .subscribe(onNext: { [unowned self] _, changes in
                if let changes = changes {
                    Logs.value(message: "CHANGES: \(changes.updated)")
                    self.allThingsTV.applyChangeset(changes)
                } else {
                    self.allThingsTV.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        /*let amountChanges = Observable.propertyChanges(object: candidateList[3])
        amountChanges
            .debug()
            .filter { $0.name == "paymentDate" }
            .map { "\($0.newValue!) PKR" }
            .bind(to: footer.rx.text)
            .disposed(by: disposeBag)*/
        
    }
    
    func updateCandidateData(candidate: Candidate) {
        let realm = try! Realm()
        let cands = realm.objects(Candidate.self).filter("cID = %i", candidate.cID)
        if let cand = cands.first {
            try! realm.write {
                cand.cPaymentMethod = candidate.cPaymentMethod
                cand.paymentDate = candidate.paymentDate
                Logs.value(message: "UPDATE: \(candidate)")
            }
        }
    }
    
    func updateMonthData(monthData: MonthsModel, isFromBank : Bool) {
        let realm = try! Realm()
        let months = realm.objects(MonthsModel.self).filter("mName = %@", paymentMonth)
        if let month = months.first {
            try! realm.write {
                if isFromBank {
                    month.bankAmount = monthData.bankAmount
                    month.totalCollection = monthData.totalCollection
                } else {
                    month.cashAmount = monthData.cashAmount
                    month.totalCollection = monthData.totalCollection
                }
                allThingsTV.reloadRows(at: [IndexPath(row: candidateList.count, section: 0)], with: .automatic)
                Logs.value(message: "UPDATE: \(month)")
            }
        }
    }
    
    @objc
    func btnPressedB(sender:UIButton) {
                if sender.currentImage!.isEqual(UIImage(named: "Unchecked-Checkbox")) {
            
            let candidate = Candidate()
            
            candidate.cID = candidateList[sender.tag].cID
            candidate.cPaymentMethod = "bank"
            candidate.paymentDate = Date().toFormat("dd-MMM")
            
            updateCandidateData(candidate: candidate)
                    
           
            if let month = monthList.first {
                let monthModel = MonthsModel()
                monthModel.bankAmount = month.bankAmount + Int(candidateList[sender.tag].paymentAmount)!
                monthModel.totalCollection =  monthModel.bankAmount + month.cashAmount
                updateMonthData(monthData: monthModel, isFromBank: true)
            }
            
            
        } else {
            
            let candidate = Candidate()
            
            candidate.cID = candidateList[sender.tag].cID
            candidate.cPaymentMethod = ""
            candidate.paymentDate = "N/A"
            
            updateCandidateData(candidate: candidate)
            
            if let month = monthList.first {
                let monthModel = MonthsModel()
                monthModel.bankAmount = month.bankAmount - Int(candidateList[sender.tag].paymentAmount)!
                monthModel.totalCollection =  monthModel.bankAmount + month.cashAmount
                updateMonthData(monthData: monthModel, isFromBank: true)
            }
        }
        
    }
    @objc
    func btnPressedC(sender:UIButton) {
        
        if sender.currentImage!.isEqual(UIImage(named: "Unchecked-Checkbox")) {
            
            let candidate = Candidate()
            
            candidate.cID = candidateList[sender.tag].cID
            candidate.cPaymentMethod = "cash"
            candidate.paymentDate = Date().toFormat("dd-MMM")
            
            updateCandidateData(candidate: candidate)
            
            if let month = monthList.first {
                let monthModel = MonthsModel()
                monthModel.cashAmount = month.cashAmount + Int(candidateList[sender.tag].paymentAmount)!
                monthModel.totalCollection =  month.bankAmount + monthModel.cashAmount
                updateMonthData(monthData: monthModel, isFromBank: false)
            }
            
        } else {
            
            let candidate = Candidate()
            
            candidate.cID = candidateList[sender.tag].cID
            candidate.cPaymentMethod = ""
            candidate.paymentDate = "N/A"
            
            updateCandidateData(candidate: candidate)
            
            if let month = monthList.first {
                let monthModel = MonthsModel()
                monthModel.cashAmount = month.cashAmount - Int(candidateList[sender.tag].paymentAmount)!
                monthModel.totalCollection =  month.bankAmount + monthModel.cashAmount
                updateMonthData(monthData: monthModel, isFromBank: false)
            }
        }
        
    }

}

extension CommetieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidateList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == candidateList.count {
            let amountViewCell : HeaderTVCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTVCell", for: indexPath) as! HeaderTVCell
            
            amountViewCell.viewModel = monthList.first
            
            return amountViewCell
        } else {
            let cell : AllTVCell = tableView.dequeueReusableCell(withIdentifier: "AllTVCell", for: indexPath) as! AllTVCell
            cell.bankCBBtn.addTarget(self, action: #selector(btnPressedB(sender:)), for: .touchUpInside)
            cell.CashCBBtn.addTarget(self, action: #selector(btnPressedC(sender:)), for: .touchUpInside)
            
            cell.bankCBBtn.tag = indexPath.row
            cell.CashCBBtn.tag = indexPath.row
            
            cell.nameLbl.text = candidateList[indexPath.row].cName
            
            if candidateList[indexPath.row].cPaymentMethod == "" {
                cell.bankCBBtn.setImage(UIImage(named: "Unchecked-Checkbox"), for: .normal)
                cell.CashCBBtn.setImage(UIImage(named: "Unchecked-Checkbox"), for: .normal)
                cell.bankCBBtn.isEnabled = true
                cell.CashCBBtn.isEnabled = true
                cell.dateLbl.text = "N/A"
            } else if candidateList[indexPath.row].cPaymentMethod == "bank" {
                cell.bankCBBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                cell.CashCBBtn.setImage(UIImage(named: "Unchecked-Checkbox"), for: .normal)
                cell.dateLbl.text = candidateList[indexPath.row].paymentDate
                cell.CashCBBtn.isEnabled = false
                cell.bankCBBtn.isEnabled = true
            } else if candidateList[indexPath.row].cPaymentMethod == "cash" {
                cell.CashCBBtn.setImage(UIImage(named: "checkbox"), for: .normal)
                cell.bankCBBtn.setImage(UIImage(named: "Unchecked-Checkbox"), for: .normal)
                cell.dateLbl.text = candidateList[indexPath.row].paymentDate
                cell.bankCBBtn.isEnabled = false
                cell.CashCBBtn.isEnabled = true
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTVCell") as! HeaderTVCell

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
       
}

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}

struct AMountModel {
    var bankAmount = 0
    var cashAmount = 0
    var isAmountView = false
}
