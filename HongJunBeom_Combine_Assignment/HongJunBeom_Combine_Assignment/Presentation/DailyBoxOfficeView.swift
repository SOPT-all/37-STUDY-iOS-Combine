//
//  DailyBoxOfficeView.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/17/25.
//

import UIKit

import Then
import SnapKit

class DailyBoxOfficeView: UIView {
    var onTapInquiry: ((Date) -> Void)?
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.text = "날짜를 선택하세요"
    }
    
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.date = Date()
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private let inquiryButton = UIButton().then {
        $0.setTitle("조회", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    var movieTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemBackground
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.backgroundColor = .white
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setUI() {
        self.addSubview(dateLabel)
        self.addSubview(datePicker)
        self.addSubview(inquiryButton)
        self.addSubview(movieTableView)
        
        movieTableView.addSubview(loadingIndicator)
    }
    
    private func setLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        inquiryButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        movieTableView.snp.makeConstraints {
            $0.top.equalTo(inquiryButton.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(movieTableView)
        }
    }
    
    private func setAction() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        inquiryButton.addTarget(self, action: #selector(didTapInquiryButton), for: .touchUpInside)
    }
    
    @objc private func datePickerValueChanged() {
        updateDateLabel()
    }
    
    @objc private func didTapInquiryButton() {
        onTapInquiry?(datePicker.date)
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        dateLabel.text = formatter.string(from: datePicker.date)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            inquiryButton.isEnabled = false
            inquiryButton.alpha = 0.6
        } else {
            loadingIndicator.stopAnimating()
            inquiryButton.isEnabled = true
            inquiryButton.alpha = 1.0
        }
    }
}


