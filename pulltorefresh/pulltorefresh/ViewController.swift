//
//  ViewController.swift
//  pulltorefresh
//
//  Created by Scissors on 24.02.2024.
//

import UIKit
import Lottie
import SnapKit

class ViewController: UIViewController {
    
    private let cellId = "cellId"
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let refreshView : UIView = {
        let view = UIView()
        return view
    }()
    
    private let leftImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .black
        image.image = UIImage(systemName: "magnifyingglass.circle")
        return image
    }()
    
    private let rightImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .black
        image.image = UIImage(systemName: "line.3.horizontal")
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.text = "TESTMEST"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0: return CompositionalLayoutSectionHelper.createHorizontalSection()
            case 1: return CompositionalLayoutSectionHelper.createVerticalSection()
            default: return nil
            }
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let refreshControl =  UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        animationView = .init(name: "Animation")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.1
        animationView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        view.addSubview(animationView)
        view.addSubview(scrollView)
        scrollView.addSubview(refreshView)
        refreshView.addSubview(leftImage)
        refreshView.addSubview(rightImage)
        refreshView.addSubview(titleLabel)
        refreshView.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        constraints()
    }
    
    @objc func refreshData() {
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
            self.refreshControl.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animationView.stop()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 5 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}

extension ViewController {
    private func constraints() {
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        refreshView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        leftImage.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        rightImage.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftImage)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(leftImage.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        animationView.snp.makeConstraints({ make in
            make.height.equalTo(220)
            make.top.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        })
    }
}
