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
        DogAPIManager.fetchData { [weak self] (breeds, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let breeds = breeds {
                self?.breeds = breeds
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
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
