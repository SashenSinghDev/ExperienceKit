import SwiftUI

struct DataTableView: ComponentView {
    private enum Constant {
        static let valueColumnWidth: CGFloat = 56
        static let totalColumnWidth: CGFloat = 62
        static let markerSize: CGFloat = 7
        static let markerSpacing: CGFloat = 5
        static let keySpacing: CGFloat = 14
        static let cardHorizontalPadding: CGFloat = 12
        static let cardBottomPadding: CGFloat = 4
        static let rowHorizontalPadding: CGFloat = 2
        static let rowTopPadding: CGFloat = 12
        static let rowBottomPadding: CGFloat = 9
        static let separatorHeight: CGFloat = 1
        static let headerTracking: CGFloat = 0.73
    }

    @ObservedObject var viewModel: DataTableViewModel

    init(viewModel: DataTableViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constant.keySpacing) {
            card

            if let markerLabel = viewModel.markerLabel {
                key(markerLabel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: .spacing.small) {
            if let header = viewModel.header {
                headerRow(header)
            }

            VStack(alignment: .leading, spacing: .spacing.none) {
                ForEach(viewModel.rows) { row in
                    tableRow(row)
                }
            }
        }
        .padding(.top, .spacing.medium)
        .padding(.bottom, Constant.cardBottomPadding)
        .padding(.horizontal, Constant.cardHorizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: .radius.lg)
                .fill(.backgroundsGrouped.secondary)
        )
        .clipShape(RoundedRectangle(cornerRadius: .radius.lg))
    }

    private func headerRow(_ header: DataTableViewModel.Header) -> some View {
        HStack(spacing: .spacing.small) {
            headerText(header.label)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(Array(header.values.enumerated()), id: \.offset) { index, value in
                headerText(value)
                    .frame(width: columnWidth(at: index, of: header.values.count), alignment: .trailing)
            }
        }
        .padding(.horizontal, Constant.rowHorizontalPadding)
        .accessibilityHidden(true)
    }

    private func headerText(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .tracking(Constant.headerTracking)
            .textCase(.uppercase)
            .foregroundStyle(.dataTable.secondaryLabel)
            .lineLimit(1)
    }

    private func tableRow(_ row: DataTableViewModel.Row) -> some View {
        HStack(spacing: .spacing.small) {
            HStack(spacing: Constant.markerSpacing) {
                Text(row.label)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.labels.primary)
                    .lineLimit(1)

                if row.isMarked {
                    marker
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(Array(row.cells.enumerated()), id: \.offset) { index, cell in
                Text(cell.text)
                    .font(cell.isEmphasised ? .footnote.weight(.semibold) : .footnote)
                    .foregroundStyle(.labels.primary)
                    .lineLimit(1)
                    .frame(width: columnWidth(at: index, of: row.cells.count), alignment: .trailing)
            }
        }
        .padding(.horizontal, Constant.rowHorizontalPadding)
        .padding(.top, Constant.rowTopPadding)
        .padding(.bottom, Constant.rowBottomPadding)
        .overlay(alignment: .bottom) {
            if row.showsSeparator {
                Rectangle()
                    .fill(.separators.nonOpaque)
                    .frame(height: Constant.separatorHeight)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(row.accessibilityLabel)
    }

    private func key(_ markerLabel: String) -> some View {
        HStack(spacing: Constant.markerSpacing) {
            marker

            Text(markerLabel)
                .font(.caption)
                .foregroundStyle(.dataTable.secondaryLabel)
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
    }

    private var marker: some View {
        Circle()
            .fill(.labels.primary)
            .frame(width: Constant.markerSize, height: Constant.markerSize)
    }

    // Value columns are fixed so figures line up down the table; the last
    // column is the wider, emphasised total.
    private func columnWidth(at index: Int, of count: Int) -> CGFloat {
        index == count - 1 ? Constant.totalColumnWidth : Constant.valueColumnWidth
    }
}

extension DataTableView {
    static func == (lhs: DataTableView, rhs: DataTableView) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id &&
        lhs.viewModel.header == rhs.viewModel.header &&
        lhs.viewModel.rows == rhs.viewModel.rows &&
        lhs.viewModel.markerLabel == rhs.viewModel.markerLabel
    }
}
