import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.bounces = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        webView.isOpaque = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadWebsite()
    }
    
    func loadWebsite() {
        guard let url = URL(string: "https://pervinmuellim.az/") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showOfflinePage()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showOfflinePage()
    }
    
    func showOfflinePage() {
        let html = """
        <html>
        <head>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <style>
        body { font-family: -apple-system; text-align: center; padding: 50px; background: white; }
        h2 { color: #333; }
        p { color: #666; }
        button { background: #007AFF; color: white; border: none; padding: 15px 30px; border-radius: 10px; font-size: 16px; }
        </style>
        </head>
        <body>
        <h2>Bağlantı xətası</h2>
        <p>İnternet bağlantınızı yoxlayın</p>
        <button onclick='window.location.reload()'>Yenidən cəhd et</button>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}
