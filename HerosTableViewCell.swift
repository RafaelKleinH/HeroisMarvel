//
//  HeroTableViewCell.swift
//  HeroisMarvel
//
//  Created by Rafael Hartmann on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import UIKit
import Kingfisher

class HerosTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var ivThumb: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //funcao para criar a celular passando o heroi
    func prepareCell(with hero: Hero){
        lbName.text = hero.name
        lbDescription.text = hero.description
        
        //usando kingFisher criamos a imagem, hero.thumbnail.url é a url da imagem
        if let url = URL(string: hero.thumbnail.url){
            //enquanto nao aparecer a imagem da uma tela de load
            ivThumb.kf.indicatorType = .activity
        
            //passa a url da imagem para ele criar ela
            ivThumb.kf.setImage(with: url)
        }
        else{
            ivThumb.image = nil
        }
        // setando a imageView redonda
        ivThumb.layer.cornerRadius = ivThumb.frame.size.height/2
        ivThumb.layer.borderColor = UIColor.red.cgColor
        ivThumb.layer.borderWidth = 2
        
    }
}
