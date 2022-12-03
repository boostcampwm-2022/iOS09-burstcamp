//
//  MyPageView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class MyPageView: UIView, ContainCollectionView {

    // MARK: - Properties

    private typealias DataSource = UICollectionViewDiffableDataSource<SettingSection, SettingCell>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingCell>

    private let myPageProfileView = MyPageProfileView()

    private let myInfoEditButton = DefaultButton(
        title: "내 정보 수정하기",
        font: .bold14
    )

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: listLayout()
    )
    private var settingDataSource: DataSource!

    private let darkModeSwitch = UISwitch().then {
        $0.onTintColor = .main
        $0.tintColor = .main
    }

    private let notificationSwitch = UISwitch().then {
        $0.onTintColor = .main
        $0.tintColor = .main
    }

    private let appVersionLabel = UILabel().then {
        $0.font = .regular16
        $0.textColor = .systemGray2
    }

    lazy var myInfoEditButtonTapPublisher = myInfoEditButton.tapPublisher
    lazy var darkModeSwitchStatePublisher = darkModeSwitch.statePublisher
    lazy var notificationSwitchStatePublisher = notificationSwitch.statePublisher

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)

        configureCollectionView()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func configureUI() {
        addSubview(myPageProfileView)
        myPageProfileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            make.height.equalTo(Constant.Profile.height)
        }

        addSubview(myInfoEditButton)
        myInfoEditButton.snp.makeConstraints { make in
            make.top.equalTo(myPageProfileView.snp.bottom)
                .offset(Constant.space16)
            make.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            make.height.equalTo(Constant.Button.editButton)
        }

        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myInfoEditButton.snp.bottom).offset(64)
            make.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            make.bottom.equalToSuperview()
        }
    }

    private func configureCollectionView() {
        collectionView.isScrollEnabled = false
        let cellRegistration = UICollectionView.CellRegistration(
            handler: cellRegistrationHandler
        )

        settingDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        )

        makeSnapshot()
    }

    private func cellBackgroundView() -> UIView {
        return UIView().then {
            $0.backgroundColor = .background
        }
    }

    func setCollectionViewDelegate(viewController: UICollectionViewDelegate) {
        collectionView.delegate = viewController
    }

    func updateView(user: User) {
        myPageProfileView.updateView(user: user)
        notificationSwitch.setOn(user.isPushOn, animated: true)
    }

    func updateDarkModeSwitch(appearance: Appearance) {
        darkModeSwitch.setOn(appearance.switchMode, animated: true)
    }

    func updateAppVersionLabel(appVersion: String) {
        appVersionLabel.text = appVersion
    }
}

// MARK: - UICollectionView

extension MyPageView {

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfiguration = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        layoutConfiguration.headerMode = .firstItemInSection
        layoutConfiguration.showsSeparators = false
        layoutConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(
            using: layoutConfiguration
        )
    }

    private func cellRegistrationHandler(
        cell: UICollectionViewListCell,
        indexPath: IndexPath,
        itemIdentifier: SettingCell
    ) {
        setContentConfiguration(
            cell: cell,
            indexPath: indexPath,
            itemIdentifier: itemIdentifier
        )

        setCellAccessoryConfiguration(
            cell: cell,
            indexPath: indexPath,
            itemIdentifier: itemIdentifier
        )
    }

    private func setContentConfiguration(
        cell: UICollectionViewListCell,
        indexPath: IndexPath,
        itemIdentifier: SettingCell
    ) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = itemIdentifier.title

        switch itemIdentifier {
        case .settingHeader, .appInfoHeader:
            contentConfiguration.textProperties.font = .bold12
            contentConfiguration.textProperties.color = .systemGray2
        default:
            contentConfiguration.textProperties.font = .regular16
        }

        cell.contentConfiguration = contentConfiguration
        cell.backgroundView = cellBackgroundView()
    }

    private func setCellAccessoryConfiguration(
        cell: UICollectionViewListCell,
        indexPath: IndexPath,
        itemIdentifier: SettingCell
    ) {
        switch itemIdentifier {
        case .notification, .darkMode:
            cell.accessories = [
                .customView(configuration: iconAccessoryConfiguration(cell: itemIdentifier)),
                .customView(configuration: switchAccessoryConfiguration(cell: itemIdentifier))
            ]
        case .withDrawal:
            cell.accessories = [
                .customView(configuration: iconAccessoryConfiguration(cell: itemIdentifier))
            ]
        case .openSource:
            cell.accessories = [.outlineDisclosure(
                displayed: .always,
                options: .init(tintColor: .systemGray2)
            )]
        case .appVersion:
            cell.accessories = [.customView(configuration: labelAccessoryConfiguration())]
        default: break
        }
    }

    private func iconAccessoryConfiguration(cell: SettingCell)
    -> UICellAccessory.CustomViewConfiguration {
        let iconImageView = UIImageView().then {
            $0.image = cell.icon?
                .withTintColor(.systemGray2)
                .withRenderingMode(.alwaysOriginal)
        }
        return UICellAccessory.CustomViewConfiguration(
            customView: iconImageView,
            placement: .leading()
        )
    }

    private func switchAccessoryConfiguration(cell: SettingCell)
    -> UICellAccessory.CustomViewConfiguration {
        var switchButton = UISwitch()

        switch cell {
        case .darkMode:
            switchButton = darkModeSwitch
        case .notification:
            switchButton = notificationSwitch
        default: break
        }

        return UICellAccessory.CustomViewConfiguration(
            customView: switchButton,
            placement: .trailing()
        )
    }

    private func labelAccessoryConfiguration()
    -> UICellAccessory.CustomViewConfiguration {
        return UICellAccessory.CustomViewConfiguration(
            customView: appVersionLabel,
            placement: .trailing()
        )
    }

    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(SettingSection.allCases)
        SettingCell.allCases.forEach { cell in
            snapshot.appendItems([cell], toSection: cell.section)
        }
        settingDataSource.apply(snapshot)
    }
}
