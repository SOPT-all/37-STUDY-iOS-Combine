//
//  SSEViewController.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/29/25.
//

import UIKit

// 위키미디어 데이터 구조체 (필요한 필드만 정의)
struct WikiEvent: Codable {
    let title: String
    let user: String
    let comment: String?
}

class SSEViewController: UIViewController {
    
    let url = URL(string: "https://stream.wikimedia.org/v2/stream/recentchange")!
    
    // UI 요소
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "연결 대기 중..."
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startStreaming()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func startStreaming() {
        let configuration = URLSessionConfiguration.default
        // SSE를 위해 타임아웃을 무한정으로 설정 (선택 사항)
        configuration.timeoutIntervalForRequest = TimeInterval(Int.max) // 추가적인 데이터가 들어올 때까지 기다려주는 최대 시간
        configuration.timeoutIntervalForResource = TimeInterval(Int.max) // 전체 리소스를 다운로드하는 데 허용되는 최대 시간
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
    }
}

// MARK: - URLSessionDataDelegate
extension SSEViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // 1. 데이터를 문자열로 변환
        guard let string = String(data: data, encoding: .utf8) else { return }
        
        // 2. SSE 데이터 형식에서 "data:" 접두어 이후 내용 추출
        let lines = string.components(separatedBy: "\n")
        for line in lines {
            if line.hasPrefix("data:") {
                let jsonString = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let jsonData = jsonString.data(ofValue: .utf8) else { continue }
                
                // 3. Decoding 및 UI 업데이트
                do {
                    let event = try JSONDecoder().decode(WikiEvent.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = "수정된 문서: \(event.title)"
                        self.detailLabel.text = "사용자: \(event.user)\n설명: \(event.comment ?? "없음")"
                    }
                } catch {
                    print("Decoding Error: \(error)")
                }
            }
        }
    }
}

// String 편의 확장
extension String {
    func data(ofValue encoding: String.Encoding) -> Data? {
        return self.data(using: encoding)
    }
}
