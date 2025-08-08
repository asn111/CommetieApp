//
//  MonthsViewController.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Thursday03/06/2021.
//

import UIKit
import RealmSwift

class MonthsViewController: UIViewController {

    @IBOutlet weak var monthsCV: UICollectionView!
    var tempMonthsNameList = [String:String]()
    var monthsNameList : [String:String] = ["May 2025":" 1st -- Shakeela",
                                            "June 2025":"2nd -- Neelum (Shehzad)",
                                            "July 2025":"3rd -- Ammna",
                                            "August 2025":"4th -- Sameena",
                                            "September 2025":"5th -- Mani + Waqar + Sana",
                                            "October 2025":"6th -- Hifza + Faiza + Areej",
                                            "November 2025":"7th -- Saddaf",
                                            "December 2025":"8th -- Hina",
                                            "January 2026":"9th -- Naheeda + Mani",
                                            "February 2026":"10th -- Sidra + Tasleem + Mani",
                                            "March 2026":"11th -- Zareena",
                                            "April 2026":"12th -- Neelum(Badar)",
                                            "May 2026":"12th -- Neelum (Hamza)"]
    
    var candidateNameList : [String:Any] = ["Neelum":"150000",
                                            "Shakeela": "100000",
                                            "Sameena": "50000",
                                            "Zareena":"50000",
                                            "Saddaf":"50000",
                                            "Hina":"50000",
                                            "Naheeda":"40000",
                                            "Mani":"35000",
                                            "Hifza":"30000",
                                            "Sidra":"30000",
                                            "Waqar":"25000",
                                            "Faiza":"10000",
                                            "Areej":"10000",
                                            "Tasleem":"10000",
                                            "Sana":"10000"]

    var candList = List<Candidate>()
    var monthsList : Results<MonthsModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        monthsCV.delegate = self
        monthsCV.dataSource = self
        monthsCV.register(UINib(nibName: "MonthsCVCell", bundle: nil), forCellWithReuseIdentifier: "MonthsCVCell")

        doTheRealmThing()

        if !AppFunctions.getIsFirstLogin(forKey: isFirstLogin) {
            Logs.value(message: "::FALSE VAL::")
            
            for months in monthsNameList {
                let month = MonthsModel()
                let candsArray = List<Candidate>()

                for candis in candidateNameList {
                    let cand = Candidate()
                    cand.cID = Candidate.incrementaIDs()
                    cand.cName = candis.key
                    cand.paymentAmount = candis.value as! String
                    cand.paymentMonth = months.key
                    create_Candidate(candidate: cand)
                    candsArray.append(cand)
                }

                

                
                month.mID = MonthsModel.incrementaIDs()
                month.mName = months.key
                month.memberName = months.value 
                month.candidates = candsArray
                if let number = Int(months.value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    month.mOrder = number
                    Logs.value(message: "VAL:: \(number)")
                }
                create_MonthsList(months: month)
            }
        }
        
    }
    
    func doTheRealmThing(){
        let realm = try! Realm()
        monthsList = realm.objects(MonthsModel.self).sorted(byKeyPath: "mOrder", ascending: true)
    }
    
    func create_Candidate(candidate: Candidate) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(Candidate.self, value: candidate, update: .all)
        }
    }
    func create_MonthsList(months: MonthsModel) {
        let realm = try! Realm()
        try! realm.write {
            AppFunctions.setIsFirstLogin(val: true)
            realm.create(MonthsModel.self, value: months, update: .all)
        }
    }
    
    

}
extension MonthsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monthsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthsCVCell", for: indexPath as IndexPath) as! MonthsCVCell
        cell.monthsLbl.text = monthsList[indexPath.row].mName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? CommetieViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.fade
            vc?.paymentMonth = monthsList[indexPath.item].mName
            self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
