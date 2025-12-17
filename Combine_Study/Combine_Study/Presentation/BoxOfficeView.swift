//
//  BoxOfficeView.swift
//  Combine_Study
//
//  Created by 임소은 on 12/15/25.
//

import SwiftUI

struct BoxOfficeView: View {

    @StateObject private var vm: BoxOfficeViewModel
    @State private var selectedDate = Date()

    init(vm: BoxOfficeViewModel = BoxOfficeViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("🎥")
                .overlay { loadingOverlay }
                .alert("오류", isPresented: isErrorPresentedBinding) {
                    Button("확인", role: .cancel) { vm.errorMessage = nil }
                } message: {
                    Text(vm.errorMessage ?? "")
                }
                .task { vm.fetch(date: selectedDate) }
        }
    }
}

// MARK: - UI Components
private extension BoxOfficeView {

    var content: some View {
        VStack(spacing: 12) {
            datePickerSection
            fetchButton
            listSection
        }
    }

    var datePickerSection: some View {
        DatePicker("조회 날짜", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
    }

    var fetchButton: some View {
        Button {
            vm.fetch(date: selectedDate)
        } label: {
            Text("조회")
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 16)
        }
        .disabled(vm.isLoading)
    }

    @ViewBuilder
    var listSection: some View {
        if vm.items.isEmpty && !vm.isLoading {
            emptyView
        } else {
            boxOfficeList
        }
    }

    var emptyView: some View {
        ContentUnavailableView(
            "조회해주세요~",
            systemImage: "film"
        )
        .padding(.top, 20)
    }

    var boxOfficeList: some View {
        List(vm.items) { item in
            BoxOfficeRow(item: item)
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    var loadingOverlay: some View {
        if vm.isLoading {
            ProgressView()
        }
    }

    var isErrorPresentedBinding: Binding<Bool> {
        Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )
    }
}

// MARK: - BoxOfficeRow
private struct BoxOfficeRow: View {

    let item: DailyBoxOfficeItem

    var body: some View {
        HStack(spacing: 12) {
            rankView

            VStack(alignment: .leading, spacing: 6) {
                titleView
                openDateView
            }

            Spacer()

            audienceView
        }
        .padding(.vertical, 6)
    }
}

private extension BoxOfficeRow {

    var rankView: some View {
        Text(item.rank)
            .font(.system(size: 18, weight: .bold))
            .frame(width: 28)
    }

    var titleView: some View {
        Text(item.movieName)
            .font(.system(size: 15, weight: .semibold))
            .lineLimit(1)
    }

    var openDateView: some View {
        Text("개봉일: \(item.openDate)")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }

    var audienceView: some View {
        Text("누적 \(item.audienceAcc)")
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
}

#Preview {
    BoxOfficeView()
}
