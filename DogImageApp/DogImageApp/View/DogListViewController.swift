import UIKit

class DogListViewController: UIViewController {
    var breeds: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchData() // 1. fetchData()メソッドの呼び出しを修正
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let urlString = "https://dog.ceo/api/breeds/list/all"

        guard let requestUrl = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, res,error) in
            if let error = error {
                print("Unexpected error: \(error.localizedDescription). ")
                return
            }
            //HTTPresエラー
            if let res = res as? HTTPURLResponse {
                if !(200...299).contains(res.statusCode) {
                    print("Request Failed - Status Code: \(res.statusCode).")
                    return
                }
            }
            
            //データ型　JSONに
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let breedsDict = json?["message"] as? [String: [String]] {
                        // breeds配列にデータを追加
                        self.breeds = Array(breedsDict.keys)
                        
                        // メインスレッドでテーブルビューをリロード
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("jsonError :(String(describing: json))")
                    }
                } catch {
                    print("Error")
                }
            } else {
                print("Unexpected error.")
            }

        }
        task.resume() // 2. タスクを再開
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
