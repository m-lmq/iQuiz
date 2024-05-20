//
//  TopicTableViewCell.swift
//  iQuiz
//
//  Created by Maggie Liang on 5/10/24.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var topicLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setIconImage(withIndex index: Int) {
 
         let systemImageName = "\(index).circle.fill"
         let image = UIImage(systemName: systemImageName)
         
 
         let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
         let updatedImage = renderer.image { context in
             image?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
             
   
             let paragraphStyle = NSMutableParagraphStyle()
             paragraphStyle.alignment = .center
             let attributes: [NSAttributedString.Key: Any] = [
                 .font: UIFont.systemFont(ofSize: 12),
                 .paragraphStyle: paragraphStyle,
                 .foregroundColor: UIColor.white
             ]
             
      
             let text = "\(index)"
             let textSize = text.size(withAttributes: attributes)
             let textRect = CGRect(x: (30 - textSize.width) / 2, y: (30 - textSize.height) / 2, width: textSize.width, height: textSize.height)
             text.draw(in: textRect, withAttributes: attributes)
         }
         

         iconImage.image = updatedImage
     }

}
