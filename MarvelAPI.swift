
import Foundation
import SwiftHash
import Alamofire

class MarvelAPI : Codable{
    
    //Url base da marvel
    static private let basepath: String = "https://gateway.marvel.com/v1/public/characters?"
    
    //chaves que ela disponibiliza para os devs
    static private let privateKey: String = "d8e96ecd58c276f5d7dd310e18e34636300ce497"
    static private let publicKey: String = "38d356618a4527271cb14e87a9b2616f"
   
    // limite de chamadas
    static private let limit = 50

    //pede o nome da primeira tela pra filtrar e a pagina que começa en 0
    // carregando 50 pessoas por pagina, e uma closure
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void){
        
        let offset = page * limit
        let startsWith: String
        
        // gerar um nome sem espeço que a api da marvel pede
        //se nao for vazia gera, se tiver vazio passar i, array nulo
        if let name = name, !name.isEmpty{
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else{
         startsWith = ""
            
        }
        
        //Cria a URL para chegar nos herois
        //a url Base da marvel, + o limite * pagina, quanto mais paginas mais ele carrega + limite  + o imput de nome + a credencial que é a ts + a chave publica + hash usada o swiftHash pra criar o MD5
        let url = basepath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
       
        //decodificar a api, usando Alamofire para dar um request passando a url e dentro da tentando conseguir
        Alamofire.request(url).responseJSON { (response) in
           // tentar passar a resposta do request para a data, se ele nao conseguir retorna o nil
            guard let data = response.data else{
                onComplete(nil)
                return
            }
            // um do tentando decodificar a data ena Class MarvelInf
            // se conseguir devolve a var crida para receber
            do {
              let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
              onComplete(marvelInfo)
            }
            //um catch caso de erro no do ele vem pra ca e bota o error na var error e printa ele, volta nil
            catch let error{
                 print(error)
                onComplete(nil)
               
                  }
        }
    }
    
    //gera a credencial que a marvel pede
    private class func getCredentials() -> String{
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts + privateKey + publicKey).lowercased()
        
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
}
  


