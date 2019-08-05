//
//  AvaliacaoViewController.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import UIKit

class AvaliacaoViewController: UIViewController {

    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btCalcula: UIButton!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbImc: UILabel!
    @IBOutlet weak var viResult: UIView!
    @IBOutlet weak var ivResult: UIImageView!
    var valuation: Valuation?
    var user: User?
    var result = ""
    var image = ""
    let dateFormatter : DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            lbDate.text = String(dateFormatter.string(from: Date()))
            lbName.text = user.name
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btCalculate(_ sender: Any) {
        
        if let weight = Float(tfWeight.text!), let height = Float(tfHeight.text!){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let resultCalc = calcImc(weight, height)
            showResult(imc: Double(resultCalc))
            
            if let user = user {
                valuation = Valuation(id: nil,
                                      user_id: user.id,
                                      weight: Int(weight),
                                      height: height,
                                      imc: resultCalc,
                                      image: image,
                                      result: result,
                                      date: String(dateFormatter.string(from: Date())))
            }
            
            lbImc.text = "IMC: " + String(resultCalc)
            lbResult.text = result
            ivResult.image = UIImage(named: image)
            viResult.isHidden = false
            view.endEditing(true)
            
            if let btCalc = btCalcula.titleLabel?.text {
                if btCalc == "Calcular" {
                    btCalcula.setTitle("Salvar", for: .normal)
                }else if btCalc == "Salvar" {
                    AddValuation()
                }
            }
        
        }
    }
    
    func AddValuation() {
        
        if let valuation = self.valuation  {
            HttpValuations.save(valuation:valuation) { (success) in
                self.goBack()
            }
        }
    }
    
    func goBack(){
        DispatchQueue.main.async {
             self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    func calcImc(_ weight: Float, _ height: Float) -> Int{
        
        return Int(weight / pow(height,2))
    }
    
    func showResult(imc:Double) {
        
        switch imc {
        case 0..<16 :
            result = "Magreza"
            image = "abaixo"
        case 16..<18.5:
            result = "Abaixo do peso"
            image = "abaixo"
        case 18.5..<25:
            result = "Peso ideal"
            image = "ideal"
        case 25..<30:
            result = "Sobre peso"
            image = "sobre"
        default:
            result = "Obesidade"
            image = "obesidade"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
