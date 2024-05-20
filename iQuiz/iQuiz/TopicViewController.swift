//
//  TopicViewController.swift
//  iQuiz
//
//  CCreated by Maggie Liang on 5/10/24.
//

import UIKit


class TopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var theTable: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    // Number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicCount
    }
    
    // Create and configure cells for the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        
        // Set the text and icon image for the cell
        cell.descriptionLabel.text = currentDescriptionList[indexPath.row]
        cell.topicLabel.text = currentTopicList[indexPath.row]
        cell.setIconImage(withIndex: indexPath.row + 1)
        
        return cell
    }
    
    var topicCount: Int = 0
    var currentTopicList: [String] = []
    var currentDescriptionList: [String] = []
    static var quizList: [Topic] = []
    static var selectedIndex: Int = 0
    var myURL:String = "http://tednewardsandbox.site44.com/questions.json"
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        theTable.refreshControl = refreshControl
        
        // Check if a URL is already saved in UserDefaults
           if let savedURL = UserDefaults.standard.string(forKey: "savedURL") {
               // If a URL is saved, use it
               myURL = savedURL
               fetchData(urlString: savedURL)
           } else {
               // If no URL is saved, use the default URL
               UserDefaults.standard.set(myURL, forKey: "savedURL")
               fetchData(urlString: myURL)
           }
    }

    @objc func refreshData() {
        fetchData(urlString: myURL)
    }
    
    var timer: Timer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [self] in
  
            timer?.invalidate()
            timer = nil
            
            //set one minutes timer
            //Timed refresh with user-specified interval in settings: 1 point.
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
   
    }
    
    @objc func timerFired() {
        //print("url is \(myURL)")
        let userDefaults = UserDefaults.standard
        let url = userDefaults.string(forKey: "savedURL")
        //print("URL is \(url)")
        DispatchQueue.main.async { [self] in
            fetchData(urlString: url!)
       
        }
        
    }
    
    // Fetch data from a remote JSON API
    func fetchData(urlString: String) {
        topicCount = 0
        TopicViewController.quizList.removeAll()
        TopicViewController.selectedIndex = 0
        currentTopicList.removeAll()
        currentDescriptionList.removeAll()
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let request = URLRequest(url: url)
        
        // Check network connection
        checkNetworkConnection(with: request) { isConnected in
            guard isConnected else {
                print("No network connection available.")
                self.showAlert(message: "No network connection available or url wrong.")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    // Decode the JSON response into an array of Topic objects
                    let topics = try JSONDecoder().decode([Topic].self, from: data)
                    
                    self.topicCount = topics.count
                    TopicViewController.quizList = topics
                    
                    for topic in topics {
                        self.currentTopicList.append(topic.title)
                        self.currentDescriptionList.append(topic.desc)
                    }
                    
                    DispatchQueue.main.async {
                        self.theTable.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
            task.resume()
        }
    }

    func checkNetworkConnection(with request: URLRequest, completion: @escaping (Bool) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        task.resume()
    }

       
       // Network Alert
       func showAlert(message: String) {
           let alertController = UIAlertController(title: "No Network", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           DispatchQueue.main.async {
               self.present(alertController, animated: true, completion: nil)
           }
       }
    
    // Load data for a specific topic and question index
    func loadData(forIndex index: Int, questionsIndex: Int, topics: [Topic]) -> (String, String, String, [String])? {
        guard index >= 0 && index < topics.count else {
            print("Invalid topic index.")
            return nil
        }
        
        let topic = topics[index]
        let topicTitle = topic.title
        let topicDescription = topic.desc
        
        guard questionsIndex >= 0 && questionsIndex < topic.questions.count else {
            print("Invalid questions index.")
            return nil
        }
        
        let question = topic.questions[questionsIndex]
        let questionText = question.text
        let singleAnswer = question.answer
        let answers = question.answers
        
        return (topicTitle, topicDescription, questionText, [singleAnswer] + answers)
    }
    
    // Handle the tap on the "Settings" button
    @IBAction func settingTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
   
        // Add "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func checkForUpdates(with url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        let request = URLRequest(url: url)
        
        checkNetworkConnection(with: request) { isConnected in
            guard isConnected else {
                print("No network connection available.")
                self.showAlert(message: "No network connection available.")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                print("Update check response: \(data)")
            }
            
            task.resume()
        }
    }

    
    // Handle the selection of a table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TopicViewController.selectedIndex = indexPath.row
        
        // Perform a segue to the "PerformQuestion" view
        self.performSegue(withIdentifier: "PerformQuestion", sender: true)
    }
}
