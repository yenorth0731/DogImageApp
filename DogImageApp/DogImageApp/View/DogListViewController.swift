import UIKit


class DogListViewController: UIViewController {
//    var breeds: [String] = []
    var breeds: [DogBreed] = []

    
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
                destinationVC.selectedBreed = selectedBreed.name
//
            }
        }
    }
    
    
    func fetchData() {
        DogAPIManager.fetchDogBreeds { [weak self] result in
            switch result {
            case .success(let breeds):
                self?.breeds = breeds
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching dog breeds: \(error.localizedDescription)")
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
        let breed = breeds[indexPath.row]
        cell.textLabel?.text = breed.name
        return cell
    }
}
