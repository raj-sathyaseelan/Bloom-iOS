//
//  BKSportCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKSportCell: UITableViewCell {
    @IBOutlet weak var basketBallBtn: AHStackButton!
    @IBOutlet weak var footBallBtn: AHStackButton!
    @IBOutlet weak var tenisBtn: AHStackButton!
    @IBOutlet weak var baseBallBtn: AHStackButton!

    @IBOutlet weak var chessBtn: AHStackButton!
    @IBOutlet weak var soccerBtn: AHStackButton!

    fileprivate var buttons = [UIButton]()
    fileprivate(set) var totalSports: [BKSport] = [BKSport]()
    
    weak var navigationVC: UINavigationController?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton(btn: basketBallBtn)
        setupButton(btn: footBallBtn)
        setupButton(btn: tenisBtn)
        setupButton(btn: baseBallBtn)
        setupButton(btn: chessBtn)
        setupButton(btn: soccerBtn)
    }

    func setupButton(btn: UIButton) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.addTarget(self, action: #selector(sportBtnTapped(_:)), for: .touchUpInside)
        buttons.append(btn)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


//MARK:- Event Handling
extension BKSportCell {
    func sportBtnTapped(_ btn: UIButton) {
        let sportLevelVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "BKSportLevelVC") as! BKSportLevelVC
        sportLevelVC.delegate = self
        sportLevelVC.sportName = btn.titleLabel?.text ?? "Unknown Sport"
        navigationVC?.pushViewController(sportLevelVC, animated: true)
    }
}

extension BKSportCell: BKSportLevelVCDelegate {
    func sportLevel(_ vc: BKSportLevelVC, didChooseSport sport: BKSport?) {
        let sportName = vc.sportName
        
        let btn = buttons.filter { (btn) -> Bool in
            return btn.titleLabel!.text! == sportName
        }.first
        if let sport = sport {
            print("a sport added")
            totalSports.append(sport)
            btn?.setImage(#imageLiteral(resourceName: "sport-check-icon"), for: .normal)
        }else{
            print("a sport deleted")
            btn?.setImage(UIImage(named: "sport-add-icon"), for: .normal)
        }
    }
}







