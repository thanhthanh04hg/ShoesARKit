//
//  File.swift
//  MaterialAR
//
//  Created by Macbook on 12/12/2020.
//

import UIKit
import SwiftHSVColorPicker
class SelectColorViewController: UIViewController , Delegate {
    var colorStr : String = ""
    func passStringColor(_ strColor: String) {
        colorStr = strColor
    }
    

    static let shared = SelectColorViewController()
    var str : String = ""
    let colorPicker = SwiftHSVColorPicker(frame: CGRect(x:50, y: 150, width: 300, height: 400))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(colorPicker)
        colorPicker.setViewColor(.black)

    }
    
    @IBAction func onDisplayColor(_ sender: Any) {
        guard let selectColor = colorPicker.color else{
            return
        }
        UserDefaults.standard.set(StringFromUIColor(color: selectColor), forKey: colorStr)
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        present(vc,animated: true)
    }
    
    func StringFromUIColor(color: UIColor) -> String {
        
        let components = color.cgColor.components
        if(components?.count == 4){
            return "\(components![0]) \(components![1]) \(components![2]) \(components![3])"
        }
        else{
            return "\(components![0]) \(components![1])"
        }
    }

}
protocol Delegate : class {
    func passStringColor(_ strColor : String)
}

