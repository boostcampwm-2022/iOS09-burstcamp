//
//  MyPageView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

enum SettingSection: Int, CaseIterable {
    case setting
    case appInfo
}

enum SettingCell: Int, CaseIterable {
    case settingHeader
    case notification
    case darkMode
    case withDrawal
    case appInfoHeader
    case openSource
    case appVersion

    var title: String {
        switch self {
        case .settingHeader: return "설정"
        case .notification: return "알림설정"
        case .darkMode: return "다크모드"
        case .withDrawal: return "탈퇴하기"
        case .appInfoHeader: return "앱 정보"
        case .openSource: return "오픈소스 라이선스"
        case .appVersion: return "앱 버전"
        }
    }

    var section: SettingSection {
        switch self {
        case .settingHeader, .notification, .darkMode, .withDrawal:
            return .setting
        case .appInfoHeader, .openSource, .appVersion:
            return .appInfo
        }
    }

    var icon: UIImage? {
        switch self {
        case .notification: return UIImage(systemName: "bell.fill")
        case .darkMode: return UIImage(systemName: "moon.fill")
        case .withDrawal: return UIImage(systemName: "airplane.departure")
        default: return nil
        }
    }
}

final class MyPageView: UIView {

    // MARK: - Properties

    private typealias DataSource = UICollectionViewDiffableDataSource<SettingSection, SettingCell>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingCell>

    private let user: User

    private lazy var myPageProfileView = MyPageProfileView(
        user: user
    )

    private let myInfoEditButton = DefaultButton(
        title: "내 정보 수정하기",
        font: .bold14
    )

    private lazy var settingCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: listLayout()
    )
    private var settingDataSource: DataSource!

    // TODO: 현재는 private을 풀고 Combine Switch.Publisher를 추후 internal로 바꾸기?

    lazy var darkModeSwitch = UISwitch().then {
        $0.onTintColor = .main
        $0.tintColor = .main
    }

    lazy var notificationSwitch = UISwitch().then {
        $0.onTintColor = .main
        $0.tintColor = .main
    }

    // MARK: - Initializer

    init(user: User) {
        self.user = user
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
            make.top.equalToSuperview().offset(103)
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

        addSubview(settingCollectionView)
        settingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myInfoEditButton.snp.bottom).offset(64)
            make.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            make.bottom.equalToSuperview()
        }
    }

    private func configureCollectionView() {
        let cellRegistration = UICollectionView.CellRegistration(
            handler: cellRegistrationHandler
        )

        settingDataSource = DataSource(
            collectionView: settingCollectionView,
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
        settingCollectionView.delegate = viewController
    }

    func setDarkModeSwitch(appearance: Appearance) {
        darkModeSwitch.isOn = appearance.switchMode
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
                // TODO: Handler
                // actionHandler:
            )]
        case .appVersion:
            guard let appVersion = Bundle.main
                .infoDictionary?["CFBundleShortVersionString"] as? String
            else { break }
            cell.accessories = [.label(text: appVersion)]
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
            // TODO: 알림
            switchButton.isOn = false
        default: break
        }

        return UICellAccessory.CustomViewConfiguration(
            customView: switchButton,
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
