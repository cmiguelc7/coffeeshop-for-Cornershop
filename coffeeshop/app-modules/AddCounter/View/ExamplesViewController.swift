//
//  ExamplesViewController.swift
//  coffeeshop
//
//  Created by Cesar Miguel Chavez on 02/03/21.
//

import Foundation
import UIKit

class ExamplesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionLayoutDrinks: UICollectionViewFlowLayout! {
        didSet {
            collectionLayoutDrinks.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
    }
    
    @IBOutlet weak var collectionLayoutFood: UICollectionViewFlowLayout! {
        didSet {
            collectionLayoutFood.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
    }
    
    @IBOutlet weak var collectionLayoutMisc: UICollectionViewFlowLayout! {
        didSet {
            collectionLayoutMisc.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
    }
    
    @IBOutlet weak var collectionViewDrinks: UICollectionView!
    @IBOutlet weak var collectionViewFood: UICollectionView!
    @IBOutlet weak var collectionViewMisc: UICollectionView!
    
    var arrayDataDrinks:[String] = []
    var arrayDataFood:[String] = []
    var arrayDataMisc:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionViewDrinks.flashScrollIndicators()
        collectionViewFood.flashScrollIndicators()
        collectionViewMisc.flashScrollIndicators()
    }
    
    func configUI(){
        
        arrayDataDrinks = ["Cups of coffe", "Glasses of watter", "Orange Just", "Watter of bottle"]
        collectionViewDrinks.delegate = self
        collectionViewDrinks.dataSource = self
        collectionViewDrinks.register(UINib.init(nibName: "CustomLabelCell", bundle: nil), forCellWithReuseIdentifier: "CustomLabelCell")
        
        arrayDataFood = ["Hot-dogs", "Cupcakes eaten", "Chicken", "Hamburguer", "Steak", "Patatos", "Salad vegetables"]
        collectionViewFood.delegate = self
        collectionViewFood.dataSource = self
        collectionViewFood.register(UINib.init(nibName: "CustomLabelCell", bundle: nil), forCellWithReuseIdentifier: "CustomLabelCell")
        
        arrayDataMisc = ["Times sneezed", "Naps", "Day dreaming"]
        collectionViewMisc.delegate = self
        collectionViewMisc.dataSource = self
        collectionViewMisc.register(UINib.init(nibName: "CustomLabelCell", bundle: nil), forCellWithReuseIdentifier: "CustomLabelCell")
        
        
        
    }
    
    @IBAction func actionHandlerCloseViewExamples(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var totalRows = 0
        
        if collectionView == collectionViewDrinks {
            totalRows = arrayDataDrinks.count;
        }else if collectionView == collectionViewFood {
            totalRows = arrayDataFood.count;
        }else if collectionView == collectionViewMisc {
            totalRows = arrayDataMisc.count;
        }
        
        return totalRows
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomLabelCell", for: indexPath) as! CustomLabelCell
        
        if collectionView == collectionViewDrinks {
            cell.labelTitleExample.text = arrayDataDrinks[indexPath.row]
        }else if collectionView == collectionViewFood {
            cell.labelTitleExample.text = arrayDataFood[indexPath.row]
        }else if collectionView == collectionViewMisc {
            cell.labelTitleExample.text = arrayDataMisc[indexPath.row]
        }
        
        cell.labelTitleExample.backgroundColor = .white
        cell.layer.cornerRadius = 8.0
        cell.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3,
                           animations: {
                            
                            cell?.alpha = 0.5
                            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            
            }) { (completed) in
                UIView.animate(withDuration: 0.5,
                               animations: {
                                //Fade-out
                                cell?.alpha = 0
                                cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                                if collectionView == self.collectionViewDrinks {
                                    let text = self.arrayDataDrinks[indexPath.row]
                                    self.selectedStringPassingToAddCounter(text: text)
                                }else if collectionView == self.collectionViewFood {
                                    let text = self.arrayDataFood[indexPath.row]
                                    self.selectedStringPassingToAddCounter(text: text)
                                }else if collectionView == self.collectionViewMisc {
                                    let text = self.arrayDataMisc[indexPath.row]
                                    self.selectedStringPassingToAddCounter(text: text)
                                }
                                
                })
            }

        
    }
    
    func selectedStringPassingToAddCounter(text: String!){
        
        if let presentedByNavigation = presentingViewController as? UINavigationController, let presenter = presentedByNavigation.viewControllers.last as? AddCounterViewController {
                presenter.textFieldTitleCounter.text = text
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
