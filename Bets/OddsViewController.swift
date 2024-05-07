import UIKit
import BetsCore

class OddsViewController: UIViewController, UICollectionViewDataSource {
    
	private(set) lazy var oddsCollectionView: UICollectionView = {
		let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
		let layout = UICollectionViewCompositionalLayout.list(using: configuration)
		let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
		return collectionView
	}()
	
	private var viewModel: OddsViewModel!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let navigationTitle = "Odds"
	private let oddCellIdentifier = "cell_id"
	private let updateOddsButtonTitle = "Update odds"
    private var odds: [BetItem] = []

	convenience init(viewModel: OddsViewModel) {
		self.init()
		self.viewModel = viewModel
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
		setupActivityIndicator()
        getOdds()
    }
	
	private func setupView() {
		navigationItem.title = navigationTitle
		let logoutBarButtonItem = UIBarButtonItem(title: updateOddsButtonTitle,
												  style: .done,
												  target: self,
												  action: #selector(getOdds))
		navigationItem.rightBarButtonItem  = logoutBarButtonItem
	}
	
	private func setupCollectionView() {
		oddsCollectionView.register(OddCollectionViewCell.self, forCellWithReuseIdentifier: oddCellIdentifier)
		oddsCollectionView.dataSource = self
		oddsCollectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(oddsCollectionView)
		oddsCollectionView.isHidden = true
		NSLayoutConstraint.activate([
			oddsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			oddsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			oddsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			oddsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	private func setupActivityIndicator() {
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(activityIndicator)
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
	
	@objc private func getOdds() {
		UIView.animate(withDuration: 1, animations: { [weak self] in
			self?.loadingOdds()
		}) { [weak self] _ in
			guard let self else { return }
			Task {
				self.odds = try await self.viewModel.getOdds()
				await self.showOdds()
			}
		}
	}
	
	private func loadingOdds() {
		oddsCollectionView.isHidden = true
		activityIndicator.startAnimating()
	}
	
	private func showOdds() async {
		await MainActor.run { [weak self] in
			self?.oddsCollectionView.reloadData()
			UIView.animate(withDuration: 1, animations: {
				self?.oddsCollectionView.isHidden = false
				self?.activityIndicator.stopAnimating()
			})
		}
	}
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return odds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = oddsCollectionView.dequeueReusableCell(withReuseIdentifier: oddCellIdentifier,
																for: indexPath) as? OddCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.setup(with: odds[indexPath.item])
        return cell
    }
}

class OddCollectionViewCell: UICollectionViewListCell {
	
	let oddName = UILabel()
	let oddSellIn = UILabel()
	let oddQuality = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup(with betItem: BetItem) {
		oddName.text = betItem.name.rawValue
		oddSellIn.text = "Sell in: \(betItem.sellIn)"
		oddQuality.text = "Quality: \(betItem.quality)"
	}
	
	private func setupViews() {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
			stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 10),
			stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10)
		])
		
		stackView.addArrangedSubview(oddName)
		oddSellIn.textAlignment = .left
		stackView.addArrangedSubview(oddSellIn)
		oddQuality.textAlignment = .left
		stackView.addArrangedSubview(oddQuality)
	}
}
