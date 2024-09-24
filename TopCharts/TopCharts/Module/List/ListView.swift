//
//  ListView.swift
//  TopCharts
//
//  Created by Barış Dilekçi on 23.09.2024.
import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel()
    @State private var selectedSegment: Segment = .turkey

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List(filteredAlbums) { album in
                    HStack {
                        AsyncImage(url: URL(string: album.artworkUrl100)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                        } placeholder: {
                            ProgressView()
                        }

                        VStack(alignment: .leading) {
                            Text(album.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(album.artistName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Music")
            .navigationBarItems(trailing: Picker("Select a List", selection: $selectedSegment) {
                ForEach(Segment.allCases, id: \.self) { segment in
                    Text(segment.rawValue.capitalized).tag(segment)
                }
            }
            .pickerStyle(MenuPickerStyle())
            )
            .background(Color(.systemGroupedBackground))
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                Task {
                    await viewModel.fetchTurkeySong()
                    await viewModel.fetchGlobalSong()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private var filteredAlbums: [Album] {
        switch selectedSegment {
        case .turkey:
            return viewModel.turkeyAlbums
        case .global:
            return viewModel.globalAlbums
        }
    }
}

enum Segment: String, CaseIterable {
    case turkey = "Turkey"
    case global = "Global"
}

#Preview {
    ListView()
}
