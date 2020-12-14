//
//  ViewController.swift
//  MaterialAR
//
//  Created by Macbook on 29/11/2020.
//

import UIKit
import ARKit
import SceneKit
import SwiftHSVColorPicker

class ViewController: UIViewController ,UICollectionViewDelegate  {
    weak var delegate : Delegate?
    var shoesNode = SCNReferenceNode()
    let material1 = SCNMaterial()
    let material2 = SCNMaterial()
    let material3 = SCNMaterial()
    let materialThread = SCNMaterial()
    var str : String = ""
//    var colorStr = UserDefaults.standard.object(forKey: "color") as! String

    var nodeList : [String] = ["Node1" , "Node2" , "Node3","Thread"]
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var sceneView: ARSCNView!
    var node1Color : String = ""
    var node2Color : String = ""
    var node3Color : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAllForView()
        
    }
    // MARK: Display screen
    
    override func viewWillAppear(_ animated: Bool) {
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
        
    }
    //MARK: set up all for viewDidLoad()
    fileprivate func setUpAllForView(){
        setUpShoesNode()
        setUpCollectionView()
        if(UserDefaults.standard.string(forKey: "Node1") == nil){
            UserDefaults.standard.set("Thanh", forKey: "Node1")
        }
        if(UserDefaults.standard.string(forKey: "Node2") == nil){
            UserDefaults.standard.set("Thanh", forKey: "Node2")
        }
        if(UserDefaults.standard.string(forKey: "Node3") == nil){
            UserDefaults.standard.set("Thanh", forKey: "Node3")
        }

        
    }
    //MARK: register collection view
    fileprivate func setUpCollectionView(){
        let nib = UINib(nibName: "PenCell", bundle: nil)
        collView.register(nib, forCellWithReuseIdentifier: "PenCell")
        collView.delegate = self
        collView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:self.collView.bounds.width/5, height: self.collView.bounds.height)
        collView.collectionViewLayout = layout
        collView.showsHorizontalScrollIndicator = true
        collView.isUserInteractionEnabled = true
        collView.isPagingEnabled = true
        
    }
    //MARK: set up shoes node
    fileprivate func setUpShoesNode(){
        let urlModelShoes = Bundle.main.url(forResource: "vans_old.usdz", withExtension: nil)!
        let content = SCNReferenceNode(url: urlModelShoes)
        self.shoesNode = content!
        self.shoesNode.load()
        
        //MARK: set scale for object
        
        let width = (content?.boundingBox.max.x)! - (content?.boundingBox.min.x)!
        let scale = Float(Size(width: 5, height: 10, depth: 10).width) / (width*100.0)
        content?.scale = .init(scale,scale,scale)
        
        
        //MARK: set material for node
        
        material1.diffuse.contents = convertColorFromString(string: UserDefaults.standard.string(forKey: "Node1")!)
        material2.diffuse.contents = convertColorFromString(string: UserDefaults.standard.string(forKey: "Node2")!)
        material3.diffuse.contents = convertColorFromString(string: UserDefaults.standard.string(forKey: "Node3")!)
        materialThread.diffuse.contents = convertColorFromString(string: UserDefaults.standard.string(forKey: "Thread")!)
        devideNode()
        
        self.shoesNode.position = .init(0, 0, -0.2)
        sceneView.scene.rootNode.addChildNode(shoesNode)
    }
    func devideNode(){
        //MARK: devide node
        let shoesMaterials = shoesNode.childNodes.map( {(node) -> () in
            
            print(node)
            let geom1 = node.childNodes.map({(node2) -> () in
                print(node2)
                let van_old = node2.childNodes.map({(node3) -> () in
                    print(node3)
                    let geom2 = node3.childNodes.map({ (node4) -> () in
                            
                        if(node4.name == "Node1"){
                            node4.geometry?.materials = [material1]
                        }
                        if(node4.name == "Node2"){
                            node4.geometry?.materials = [material2]
                        }
                        if(node4.name == "Node3" ){
                            node4.geometry?.materials = [material3]
                        }
                        if(node4.name == "Thread"){
                            node4.geometry?.materials = [materialThread]
                        }
                            
                                

                        
                    })
                })
            })
        })
    }
    func convertColorFromString(string: String) -> UIColor {
        let arr = string.components(separatedBy: " ")
        if(arr.count == 4){
            return UIColor(red: CGFloat((arr[0] as NSString).floatValue), green: CGFloat((arr[1] as NSString).floatValue), blue: CGFloat((arr[2] as NSString).floatValue), alpha: CGFloat((arr[3] as NSString).floatValue))
        }
        else {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

}

//MARK: process Collection View Cell
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collView.dequeueReusableCell(withReuseIdentifier: "PenCell", for: indexPath) as? PenCell else{
            return UICollectionViewCell()
        }
        cell.nodeLabel.text = nodeList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let selectColorView = sb.instantiateViewController(withIdentifier: "SelectColorViewController") as! SelectColorViewController
            self.delegate = selectColorView
            switch indexPath.item {
            case 0:
                str = "Node1"
                delegate?.passStringColor("Node1")
                self.present(selectColorView,animated: true)
                print(UserDefaults.standard.string(forKey: "Node1")!)
            case 1:
                str = "Node2"
                delegate?.passStringColor("Node2")
                self.present(selectColorView,animated: true)
                print(UserDefaults.standard.string(forKey: "Node2")!)
            case 2:
                str = "Node3"
                delegate?.passStringColor("Node3")
                self.present(selectColorView,animated: true)
                print(UserDefaults.standard.string(forKey: "Node3")!)
            case 3:
                str = "Thread"
                delegate?.passStringColor("Thread")
                self.present(selectColorView,animated: true)
                print(UserDefaults.standard.string(forKey: "Thread")!)
                
            default:
                print("Default")
            }
        }
    }
    

}


struct Size: Hashable,Decodable {
    var width : Double
    var height : Double
    var depth : Double
    
    static let zero = Size(width: .zero, height: .zero, depth: .zero)
}
