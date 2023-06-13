
/*
 Document(placeName: "시간을 들이다 본점", distance: "", placeURL: "http://place.map.kakao.com/789369795", categoryName: "음식점 > 간식 > 제과,베이커리", addressName: "서울 동작구 신대방동 342-23", roadAddressName: "서울 동작구 보라매로 80", id: "789369795", phone: "02-812-2158", categoryGroupCode: "FD6", categoryGroupName: "음식점", x: "126.92802859597275", y: "37.496509891518436")
 */

import Foundation

class Store : Codable{
    var _placeName: String
    var _placeURL: String
    var _categoryName: String
    var _addressName: String
    var _roadAddressName: String
    var _id: String
    var _phone: String
    var _categoryGroupCode: String
    var _categoryGroupName: String
    var _x: String
    var _y: String
    
    var placeName: String {
        return _placeName
    }
    
    var placeURL: String {
        return _placeURL
    }
    
    var categoryName: String {
        return _categoryName
    }
    
    var addressName: String {
        return _addressName
    }
    
    var roadAddressName: String {
        return _roadAddressName
    }
    
    var id: String {
        return _id
    }
    
    var phone: String {
        return _phone
    }
    
    var categoryGroupCode: String {
        return _categoryGroupCode
    }
    
    var categoryGroupName: String {
        return _categoryGroupName
    }
    var x: String {
        return _x
    }
    
    var y: String {
        return _y
    }
    
    
    
    
    init(placeName: String, placeURL: String, categoryName: String, addressName: String, roadAddressName: String, id: String, phone: String, categoryGroupCode: String, categoryGroupName: String, x: String, y: String) {
        self._placeName = placeName
        self._placeURL = placeURL
        self._categoryName = categoryName
        self._addressName = addressName
        self._roadAddressName = roadAddressName
        self._id = id
        self._phone = phone
        self._categoryGroupCode = categoryGroupCode
        self._categoryGroupName = categoryGroupName
        self._x = x
        self._y = y
    }
    
    
}
