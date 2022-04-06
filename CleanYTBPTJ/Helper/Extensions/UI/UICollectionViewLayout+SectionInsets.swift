//
//  UICollectionViewLayout+SectionInsets.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/06.
//

import UIKit

extension UICollectionViewLayout {
   var sectionInsets: UIEdgeInsets {
     (self as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
  }
}
