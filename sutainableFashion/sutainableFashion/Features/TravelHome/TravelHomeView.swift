//
//  TravelHomeView.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/18/25.
//

import SwiftUI
import MapKit

struct TravelHomeView: View {
    @ObservedObject var viewModel: TravelHomeViewModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    // 지도의 중심 위치와 줌 레벨 설정
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.1, longitude: 127.30), // 서울 좌표
        span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5)
    )
    
    // 마커로 표시할 위치 데이터
    let locations = [
        Location(name: "서울", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)),
        Location(name: "부산", coordinate: CLLocationCoordinate2D(latitude: 35.1796, longitude: 129.0756)),
        Location(name: "대구", coordinate: CLLocationCoordinate2D(latitude: 35.8714, longitude: 128.6014)),
        Location(name: "광주", coordinate: CLLocationCoordinate2D(latitude: 35.1595, longitude: 126.8526)),
        Location(name: "대전", coordinate: CLLocationCoordinate2D(latitude: 36.3504, longitude: 127.3845)),
        Location(name: "세종", coordinate: CLLocationCoordinate2D(latitude: 36.4800, longitude: 127.2890)),
        Location(name: "강원", coordinate: CLLocationCoordinate2D(latitude: 37.8228, longitude: 128.1555)),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapMarker(coordinate: location.coordinate, tint: Color(hex: 0x43C9B3))
                }
                .edgesIgnoringSafeArea(.all)
            } // VStack
            
            // 시트처럼 보이는 카드 뷰
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text("나의 패션템 여정")
                        .bold()
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 25)
                        .foregroundStyle(Color(hex: 0xFFFFFF))
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<2) { _ in
                                FashionItemCard()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
                .padding(.top, 8)
                
            } // VStack
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(hex: 0x2C2C32))
        } // VStack
    }
}

// MARK: - 하단 카드 UI
struct FashionItemCard: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                Color.gray
                    .frame(width: 130, height: 99)
                    .cornerRadius(12)

                Text("NN명 사용")
                    .font(.caption2)
                    .padding(4)
                    .background(Color(hex: 0x000000, alpha: 0.4))
                    .foregroundStyle(Color(hex: 0xFFFFFF))
                    .cornerRadius(6)
                    .padding(4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("아이템 이름")
                    .bold()
                    .foregroundStyle(Color(hex: 0xFFFFFF))

                Text("주소이름 주소이름 주소이름\n주소이름 주소이름")
                    .font(.caption)
                    .foregroundColor(Color(hex: 0xE5E5EA))
                    .lineLimit(2)

                Text("전체 사용 기간 | 000일")
                    .font(.caption2)
                    .foregroundColor(Color(hex: 0x8E8E93))
            }

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(12)
    }
}
// 위치 데이터 모델
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// MARK: - 샘플 핀 데이터
struct Pin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
let samplePins: [Pin] = [
    Pin(coordinate: CLLocationCoordinate2D(latitude: 35.8, longitude: 127.5)),
    Pin(coordinate: CLLocationCoordinate2D(latitude: 35.4, longitude: 128.2)),
    Pin(coordinate: CLLocationCoordinate2D(latitude: 34.9, longitude: 127.6)),
    Pin(coordinate: CLLocationCoordinate2D(latitude: 33.5, longitude: 126.5))
]

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

#Preview {
    TravelHomeView(viewModel: TravelHomeViewModel())
}
