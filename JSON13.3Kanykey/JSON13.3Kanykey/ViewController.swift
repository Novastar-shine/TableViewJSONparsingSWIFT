import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    var movies = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = editButtonItem
        self.table.isEditing = self.isEditing
        downloadJSON {
            self.table.reloadData()
            print("Success")
        }
        table.delegate = self
        table.dataSource = self
    }
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: "https://v2.sg.media-imdb.com/suggestion/h/hello.json")
        URLSession.shared.dataTask(with: url!){ data, response, err in
            if err == nil{
                do{
                    let movieArray = try JSONDecoder().decode(Movies.self, from: data!)
                    self.movies = movieArray.d
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("error fetching data from api")
                }
            }
        }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! movieCell
        let movie = movies[indexPath.row]
        cell.titlelbl.text = movie.l
        cell.yearlbl.text = String(movie.y)
        if let imageURL = URL(string: movie.i.imageUrl){
            if let data = try? Data(contentsOf: imageURL){
                cell.imageCell.image = UIImage(data: data)
            }
            cell.showsReorderControl = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? movieViewController{
            destination.movie = movies[table.indexPathForSelectedRow!.row]
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.movies.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
           table.setEditing(editing, animated: true)
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedMovie = movies.remove(at: fromIndexPath.row)
        movies.insert(movedMovie, at: to.row)
    }
}
