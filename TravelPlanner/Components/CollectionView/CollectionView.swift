//
//  CollectionView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import SwiftUI

struct CollectionView<Row: CollectionRow, Cell: View>: UIViewRepresentable {
    typealias SectionProvider = (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection

    var rows: [Row]
    let sectionLayoutProvider: SectionProvider
    @ViewBuilder let cell: (IndexPath, UICollectionView, Row.Item) -> Cell

    private func layout() -> UICollectionViewCompositionalLayout  {
        UICollectionViewCompositionalLayout(sectionProvider: sectionLayoutProvider)
    }

    private func snapshot() -> NSDiffableDataSourceSnapshot<Row.Section, Row.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Row.Section, Row.Item>()
        for row in rows {
            snapshot.appendSections([row.section])
            snapshot.appendItems(row.items, toSection: row.section)
        }

        return snapshot
    }

    private func reloadData(context: Context, animated: Bool = false) {
        let coordinator = context.coordinator
        coordinator.sectionLayoutProvider = self.sectionLayoutProvider

        guard let dataSource = coordinator.dataSource else { return }

        let rowsHash = rows.hashValue
        if coordinator.rowsHash != rowsHash {
            dataSource.apply(snapshot(), animatingDifferences: animated)
            coordinator.rowsHash = rowsHash
        }
    }

    func makeUIView(context: Context) -> UICollectionView {
        let cellID = "hostCell"

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellID)

        context.coordinator.dataSource = Coordinator.DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? HostCell
            hostCell?.hostedCell = cell(indexPath, collectionView, item)
            return hostCell
        }

        reloadData(context: context)
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        reloadData(context: context, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension CollectionView {
    class Coordinator {
        typealias DataSource = UICollectionViewDiffableDataSource<Row.Section, Row.Item>

        var dataSource: DataSource?
        var rowsHash: Int?
        var sectionLayoutProvider: SectionProvider?
    }
}

extension CollectionView {
    class HostCell: UICollectionViewCell {
        var hostController: UIHostingController<Cell>?

        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }

        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view)

                if let hostView = hostController?.view {
                    hostView.frame = contentView.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contentView.addSubview(hostView)
                }
            }
        }
    }
}
