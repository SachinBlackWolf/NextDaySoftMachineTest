//  LoginViewController.swift
//  NextDaySoftMachinTest
//  Created by Sachin on 09/04/24.

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.postRequest()
        }
    }
    @IBAction func secureButtonAction(_ sender: UIButton) {
        if self.passwordTextField.isSecureTextEntry {
            self.passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(named: "blueColour")?.cgColor
        let colorBottom = UIColor(named: "PurpleColour")?.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.loginBtn.bounds
        
        self.loginBtn.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension LoginViewController {
    
    func postRequest() {
        
        DispatchQueue.main.async {
            
            // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
            
            let parameters: [String: Any] = ["email": self.emailTextField.text ?? "", "password": self.passwordTextField.text ?? ""]
            
            // create the url with URL
            let url = URL(string: "https://reqres.in/api/login")! // change server url accordingly
            
            // create the session object
            let session = URLSession.shared
            
            // now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            
            // add headers for the request
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                // convert parameters to Data and assign dictionary to httpBody of request
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            // create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    print("Post Request Error: \(error.localizedDescription)")
                    return
                }
                
                // ensure there is valid response code returned from this HTTP response
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else {
                    print("Invalid Response received from the server")
                    return
                }
                
                // ensure there is data returned
                guard let responseData = data else {
                    print("nil Data received from the server")
                    return
                }
                
                do {
                    // create json object from data or use JSONDecoder to convert to Model stuct
                    if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                        print(jsonResponse)
                        if let token = jsonResponse["token"] as? String {
                            // alert ok button push product controller
                            let alert = UIAlertController(title: "Token", message: token, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                                self.navigationController?.pushViewController(loginViewController, animated: true)
                                
                            }))
                            
                            // show the alert
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            print(token)
                        }
                        // handle json response
                    } else {
                        print("data maybe corrupted or in wrong format")
                        throw URLError(.badServerResponse)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            // perform the task
            task.resume()
        }
    }
}
