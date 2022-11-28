import UIKit
class movieViewController: UIViewController {
    @IBOutlet weak var movieActors: UILabel!
    @IBOutlet weak var movietype: UILabel!
    @IBOutlet weak var movieyear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    var movie: Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        movieActors.text = movie?.s
        movieyear.text = String(movie!.y)
        movietype.text = movie?.q
        movieTitle.text = movie?.l
        if let imageURL = URL(string: movie!.i.imageUrl){
            if let data = try? Data(contentsOf: imageURL){
                movieImg.image = UIImage(data: data)
            }
        }
    }
}
