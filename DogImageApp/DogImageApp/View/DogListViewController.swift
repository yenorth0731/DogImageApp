import UIKit


class DogListViewController: UIViewController {
    var breeds: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDogBreed" {
            if let destinationVC = segue.destination as? DogBreedViewController,
               let selectedIndexPath = tableView.indexPathForSelectedRow {
                let selectedBreed = breeds[selectedIndexPath.row]
                destinationVC.selectedBreed = selectedBreed
            }
        }
    }
    
    func fetchData() {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        
        guard let requestUrl = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if let error = error {
                print("Unexpected error: \(error.localizedDescription). ")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Request Failed")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let breedsDict = json?["message"] as? [String: [String]] {
                    self.breeds = Array(breedsDict.keys)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Failed to parse JSON")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

extension DogListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = breeds[indexPath.row]
        return cell
    }
}
