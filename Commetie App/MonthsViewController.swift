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
    var monthsNameList : [String:String] = ["June 2021":" 1st -- Shakeela","July 2021":"2nd -- Rehana","August 2021":"3rd -- Neelum","September 2021":"4th -- Azra & Rakshanda","October 2021":"5th -- Mahjabeen","November 2021":"6th -- Abida, Aroosa, Mrs Malik", "December 2021":"7th -- Rida & Daneen", "Jaunary 2022":"8th -- Shazia & Husnain","Febuaray 2022":"9th -- Noreen & Shela","March 2022":"10th -- Nishat, Mahjabeen, Ruqaiya","April 2022":"11th -- Hina, Mani & Neelum"]
    var candidateNameList : [String:Any] = ["Shakeela": "20000",
                                            "Rehana": "20000",
                                            "Neelum": "25000",
                                            "Azra": "10000",
                                            "Rakshanda": "10000",
                                            "Mahjabeen": "25000",
                                            "Abida": "5000",
                                            "Aroosa": "5000",
                                            "Mrs Malik": "10000",
                                            "Shazia": "40000",
                                            "Noreen": "10000",
                                            "Nishat": "5000",
                                            "Ruqaiya": "10000",
                                            "Hina": "10000",
                                            "Mani": "5000",
                                            "Shela": "10000"]

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
