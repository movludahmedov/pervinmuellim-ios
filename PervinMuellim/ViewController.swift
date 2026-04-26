import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    var retryCount = 0
    let maxRetry = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupWebView()
        setupActivityIndicator()
        loadWebsite()
    }
    
    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.backgroundColor = UIColor.white
        webView.isOpaque = true
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.autoresizingMask = [
            .flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin
        ]
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func loadWebsite() {
        guard let url = URL(string: "https://pervinmuellim.az") else { return }
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 60
        )
        webView.load(request)
    }
    
    func retryLoad() {
        if retryCount < maxRetry {
            retryCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.loadWebsite()
            }
        } else {
            activityIndicator.stopAnimating()
            showOfflinePage()
        }
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        retryCount = 0
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        retryLoad()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        retryLoad()
    }
    
    func showOfflinePage() {
        let html = """
        <html>
        <head>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system; display: flex; flex-direction: column;
               align-items: center; justify-content: center; height: 100vh;
               background: white; text-align: center; padding: 20px; }
        h2 { color: #333; margin-bottom: 10px; font-size: 22px; }
        p { color: #666; margin-bottom: 30px; font-size: 16px; }
        button { background: #007AFF; color: white; border: none;
                 padding: 15px 40px; border-radius: 12px; font-size: 17px; }
        </style>
        </head>
        <body>
        <h2>Baglanti xetasi</h2>
        <p>Internet baglantinizi yoxlayin</p>
        <button onclick='window.location.href="https://pervinmuellim.az"'>
        Yeniden cehed et
        </button>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: URL(string: "https://pervinmuellim.az"))
    }
}
