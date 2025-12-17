//
//  BoxOfficeView.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import SwiftUI

import Combine

struct BoxOfficeView: View {
    @StateObject private var vm: BoxOfficeViewModel

    @State private var selectedDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()

    init() {
        let client = NetworkClient()
        let repo = BoxOfficeRepository(client: client)
        _vm = StateObject(wrappedValue: BoxOfficeViewModel(repo: repo))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                DatePicker(
                    "기준 날짜",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .padding(.horizontal)

                HStack {
                    Button("조회") {
                        vm.load.send(selectedDate.yyyyMMdd)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("전날") {
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        vm.load.send(selectedDate.yyyyMMdd)
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .padding(.horizontal)

                Group {
                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if let msg = vm.errorMessage {
                        Spacer()
                        VStack(spacing: 10) {
                            Text("에러 발생")
                                .font(.headline)
                            Text(msg)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button("다시 시도") {
                                vm.load.send(selectedDate.yyyyMMdd)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List(vm.movies) { movie in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(movie.rank)")
                                    .font(.headline)
                                    .frame(width: 30, alignment: .leading)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(movie.name)
                                        .font(.body)

                                    HStack(spacing: 10) {
                                        Text("개봉: \(movie.openDate)")
                                        Text("누적: \(movie.audienceAcc.formattedWithSeparator)명")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            vm.load.send(selectedDate.yyyyMMdd)
                        }
                    }
                }
            }
            .navigationTitle("일별 박스오피스")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.load.send(selectedDate.yyyyMMdd)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                vm.load.send(selectedDate.yyyyMMdd)
            }
        }
    }
}

private extension Date {
    var yyyyMMdd: String {
        let f = DateFormatter()
        f.calendar = .current
        f.locale = .init(identifier: "ko_KR")
        f.timeZone = .current
        f.dateFormat = "yyyyMMdd"
        return f.string(from: self)
    }
}

private extension Int {
    var formattedWithSeparator: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
