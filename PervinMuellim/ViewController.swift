import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar üçün background
        view.backgroundColor = UIColor.white
        
        guard let url = URL(string: "https://pervinmuellim.az") else { return }
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 30
        )
        webView.load(request)
    }
    
    // Yüklənmə xətası — offline səhifə göstər
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let html = """
        <html>
        <body style='display:flex;justify-content:center;align-items:center;height:100vh;font-family:Arial;'>
        <div style='text-align:center'>
        <h2>Bağlantı xətası</h2>
        <p>İnternet bağlantınızı yoxlayın</p>
        </div>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}
