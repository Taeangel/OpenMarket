//
//  PreviewProvider.swift
//  OpenMarket
//
//  Created by song on 2022/12/24.
//



//{
//    "id": 32,
//    "vendor_id": 15,
//    "name": "우유병 텀블러",
//    "description": "하얀 우유병 모양의 텀블러! 집에 놓기만 해도 감성있는 인테리어 상품으로 적격 입니다. 여기에 물을 넣어 먹으면 나도 알프스 소녀? 입구는 음료를 마시기 좋은 크기인 40mm 입니다. 2중 구조로 탄탄합니다! 12시간이 지나도 보온 보냉이 유지 됩니다! 여름에 사용하기에도 겨울에 사용하기에도 너무 좋아요! 수량이 얼마 안 남았어요! 구매를 서두르세요😗",
//    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468784f1a11eda200131c69255928_thumb",
//    "currency": "KRW",
//    "price": 3500.0,
//    "bargain_price": 3400.0,
//    "discounted_price": 100.0,
//    "stock": 30,
//    "created_at": "2022-10-18T00:00:00",
//    "issued_at": "2022-10-18T00:00:00",
//    "images": [
//        {
//            "id": 35,
//            "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468774f1a11eda200afcab21bff61_origin",
//            "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468784f1a11eda200131c69255928_thumb",
//            "issued_at": "2022-10-18T00:00:00"
//        },
//        {
//            "id": 36,
//            "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/956d84f94f1a11eda2009d4c2abd0743_origin",
//            "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/956d84fa4f1a11eda200e1e1fcb5a93b_thumb",
//            "issued_at": "2022-10-18T00:00:00"
//        }
//    ],
//    "vendors": {
//        "id": 15,
//        "name": "red123"
//    }
//}

import SwiftUI

extension PreviewProvider {
  static var dev: DeveloperPreview {
    return DeveloperPreview.instance
  }
}

class DeveloperPreview {
  static let instance = DeveloperPreview()
  private init() {}
  @Namespace var animation

  let product = ProductModel(id: 32,
                             vendorID: 15,
                             name: "우유병 텀블러",
                             productDescription: "하얀 우유병 모양의 텀블러! 집에 놓기만 해도 감성있는 인테리어 상품으로 적격 입니다. 여기에 물을 넣어 먹으면 나도 알프스 소녀? 입구는 음료를 마시기 좋은 크기인 40mm 입니다. 2중 구조로 탄탄합니다! 12시간이 지나도 보온 보냉이 유지 됩니다! 여름에 사용하기에도 겨울에 사용하기에도 너무 좋아요! 수량이 얼마 안 남았어요! 구매를 서두르세요😗",
                             thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468784f1a11eda200131c69255928_thumb",
                             currency: "KRW",
                             price: 3500,
                             bargainPrice: 3400,
                             discountedPrice: 100,
                             stock: 30,
                             createdAt: "2022-10-18T00:00:00",
                             issuedAt: "2022-10-18T00:00:00",
                             images: [ProductImage(id: 35,
                                                   url: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468774f1a11eda200afcab21bff61_origin",
                                                   thumbnailURL: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/951468784f1a11eda200131c69255928_thumb",
                                                   issuedAt: "2022-10-18T00:00:00"),
                                      ProductImage(id: 36,
                                                   url: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/956d84f94f1a11eda2009d4c2abd0743_origin",
                                                   thumbnailURL: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20221018/956d84fa4f1a11eda200e1e1fcb5a93b_thumb",
                                                   issuedAt: "2022-10-18T00:00:00")],
                             vendors: Vendors(id: 15, name: "red123"))
}
