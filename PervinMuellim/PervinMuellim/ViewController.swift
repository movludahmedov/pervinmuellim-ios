import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    var retryCount = 0
    let maxRetry = 3
    var blurView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupScreenProtection()
        setupWebView()
        setupActivityIndicator()
        loadWebsite()
    }
    
    // MARK: - Ekran Qoruması
    func setupScreenProtection() {
        // Ekran yazısı qoruması
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureChanged),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        
        // Screenshot üçün TextField triki
        addSecureField()
    }
    
    func addSecureField() {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        secureField.translatesAutoresizingMaskIntoConstraints = false
        
        if let secureView = secureField.layer.sublayers?.first?.delegate as? UIView {
            secureView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(secureView, at: 0)
            
            NSLayoutConstraint.activate([
                secureView.topAnchor.constraint(equalTo: view.topAnchor),
                secureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                secureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                secureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
    @objc func screenCaptureChanged() {
        if UIScreen.main.isCaptured {
            showBlur()
        } else {
            hideBlur()
        }
    }
    
    func showBlur() {
        guard blurView == nil else { return }
        let blur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView?.frame = view.bounds
        view.addSubview(blurView!)
    }
    
    func hideBlur() {
        blurView?.removeFromSuperview()
        blurView = nil
    }
    
    // MARK: - WebView
    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences
        
        let webPreferences = WKPreferences()
        webPreferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = webPreferences
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = UIColor.white
        webView.scrollView.backgroundColor = UIColor.white
        webView.isOpaque = false
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
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 60
        )
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("https://pervinmuellim.az", forHTTPHeaderField: "Referer")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("az,en;q=0.9", forHTTPHeaderField: "Accept-Language")
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
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
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

extension ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
