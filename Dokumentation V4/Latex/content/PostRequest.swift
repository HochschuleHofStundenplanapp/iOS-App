var request = URLRequest(url:URL(string: myUrl!)!)
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let params = jsonObject
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                print(params)
                
                //http request
                URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                    if let safeData = data{
                        print("response: \(String(describing: String(data:safeData, encoding:.utf8)))")
                    }
                    }.resume()

            }
        else{
                    print("oops! Something went wrong")
        }
        
}
