//
//  ViewController.swift
//  MaterialAR
//
//  Created by Macbook on 29/11/2020.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController ,UICollectionViewDelegate  {
    var shoesNode = SCNReferenceNode()
    let materialAround = SCNMaterial()
    let material = SCNMaterial()
    let material3 = SCNMaterial()
    var str : String = ""
    var nodeList : [String] = ["Node1" , "Node2" , "Node3","Thread","Color"]
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAllForView()
        print(str)
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
        let scene = SCNScene()
        let urlModelShoes = Bundle.main.url(forResource: "vans_old.usdz", withExtension: nil)!
        let content = SCNReferenceNode(url: urlModelShoes)
        self.shoesNode = content!
        self.shoesNode.load()
        
        //MARK: set scale for object
        
        let width = (content?.boundingBox.max.x)! - (content?.boundingBox.min.x)!
        let scale = Float(Size(width: 5, height: 10, depth: 10).width) / (width*100.0)
        content?.scale = .init(scale,scale,scale)
        
        
        //MARK: set material for node
        
//        materialAround.diffuse.contents = UIImage(named: "img_forest.jpg")
//
//        material3.diffuse.contents = UIColor.systemPink
//
//        material.diffuse.contents = UIColor.cyan
        
        
        self.shoesNode.position = .init(0, 0, -0.2)
        sceneView.scene.rootNode.addChildNode(shoesNode)
    }
    func devideNode(){
        //MARK: devide node
        let shoesMaterials = shoesNode.childNodes.map( {(node) -> () in
            
//            print(node)
            let geom1 = node.childNodes.map({(node2) -> () in
//                print(node2)
                let van_old = node2.childNodes.map({(node3) -> () in
//                    print(node3)
                    let geom2 = node3.childNodes.map({ (node4) -> () in
//                        print(node4)
                        let geomChild = node4.childNodes.map({ (node5) -> () in
                            if(node5.name == str){
                                node5.geometry?.materials = [material]
//                                print("1")
                            }
//                            if(node5.name == "Node2"){
//                                node5.geometry?.materials = [materialAround]
//                                print(2)
//                            }

                        })
                    })
                })
            })
                           
        })
    }

}

//MARK: process Collection View Cell
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
            material.diffuse.contents = UIColor.cyan
            switch indexPath.item {
            case 0:
                
                str = "Node1"
                devideNode()
            case 1:
                str = "Node2"
                devideNode()
            case 2:
                str = "Node3"
                devideNode()
            case 3:
                str = "Thread"
                devideNode()
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
