//
//  HeroesTableViewController.swift
//  HeroisMarvel
//
//  Created by Eric Brito on 22/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class HeroesTableViewController: UITableViewController, UISearchBarDelegate {
   

    //name ele recebe do prepare
    var name: String = ""
    //array de Hero vazio que vai ser completado chamando MarvelApi.loadheroes()
    var heroes: [Hero] = []
    var filteredHeroes: [Hero] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    //valida se ta carregando herois
    var loadingHeroes = false
    //quantas paginas vai carregar
    var currentPage = 0
    //qual o total de heorois atuais
    var total = 0
    
    //carrega um label que fica por trais da section
    //avisando que ta carregando
    //quando carregar ele fica abaixo e some
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Buscando herois. Aguarde"
        loadHeroes()
        
        
    
        self.searchBar.delegate = self
        
        
    }
    
    //tirar a navi bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //carregar o array de Herois
    func loadHeroes() {
        // sempre qe chamar ela mostra que ta carregando herois
        loadingHeroes = true
        
        //chama o load da Class MarvelAPI
        //passa o nome como o nome que foi passado na outras tela
        MarvelAPI.loadHeroes(name: name, page: currentPage) { (info) in
            
            //unwrap
            if let info = info {
                
                //info = MarvelInfo
                //heroes recebe o que esta dentro de MarvelAPI.data.results que seria um array de Hero
                self.heroes += info.data.results
                //recebe o total de herois
                self.total = info.data.total
                
                print("Total:", self.total, "- Já incluídos:", self.heroes.count)
                
                //thread main pra mudar coisas na tela
                DispatchQueue.main.async {
                    //se ta mudando ja ele nao ta dando mais loading
                    self.loadingHeroes = false
                    //o label de tras muda para isso
                    self.label.text = "Não foram encontrados heróis com o nome \(self.name)"
                    //da reload pra pegar os dados novos, se vier algo ele fica por cima do label dizendo que nao achou nada
                    self.filteredHeroes = self.heroes
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //se nao tiver nenhum heroi ele nao retorna o label ele manda nil
        //label trazeiro
        tableView.backgroundView = heroes.count == 0 ? label : nil
        
        return filteredHeroes.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HeroViewController
        //hero é o heroi da cell que clicamos
        vc.hero = heroes[tableView.indexPathForSelectedRow!.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HerosTableViewCell

        //hero é a linha atual
        let hero = filteredHeroes[indexPath.row]
        
        
        //funcao que prepara a celular passando um hero
        cell.prepareCell(with: hero)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //quantas celulas vao aparecer
        //se a celula atual for o numero total de celulas - 20
        // e os herois nao tiver carregando ja
        // e o numero de herois na tela seja diferente do total da API
        if indexPath.row == heroes.count - 20 && !loadingHeroes && heroes.count != total{
            //aumenta o numero de paginas
            //cada pagina carrega 50 entao vai indo assim
            currentPage += 1
            //recarrega com 50 herois mais que antes e vai indo assim
            loadHeroes()

            
        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      filteredHeroes = searchText.isEmpty ? heroes : heroes.filter{ (item: Hero) -> Bool in

        return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
       
         }
          tableView.reloadData()
      }
}


