//
//  ProductModel.swift
//  OpenMarket
//
//  Created by song on 2022/12/23.
//

import Foundation

// MARK: - Product
struct ProductModel: Codable {
    let id, vendorID: Int?
    let name, productDescription: String?
    let thumbnail: String?
    let currency: String?
    let price, bargainPrice, discountedPrice, stock: Int?
    let createdAt, issuedAt: String?
    let images: [Image]?
    let vendors: Vendors?

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case productDescription = "description"
        case thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let url, thumbnailURL: String?
    let issuedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

// MARK: - Vendors
struct Vendors: Codable {
    let id: Int?
    let name: String?
}
