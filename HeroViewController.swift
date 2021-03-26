import UIKit
import WebKit

//usa webkit para chamar o site dos herois

class HeroViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    //prepare da outra tela vaiinstanciar ele
    var hero: Hero!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pega a url do heroi
        //ele é Hero do array de Heros
        //dai chama o array de HeroURLS dentro dele ele pega a url
        let url = URL(string: hero.urls.first!.url)
       
        //Cria um request passando a url criada antes
        let request = URLRequest(url: url!)
        title = hero.name
        
        //permite ele navegar pela tela normalmente
        webView.isUserInteractionEnabled = false
        webView.allowsBackForwardNavigationGestures = false
        //seta o delegate do WebKit pra propria view
        webView.navigationDelegate = self
        //loada a webView passando o request criado antes
        webView.load(request)
    }
   

}
extension HeroViewController : WKNavigationDelegate{
    //para ele poder usar o delegate da WKNavigationDelegate
    //quando a webView parar de carregar o loading some
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
        webView.isUserInteractionEnabled = true
    }
}
