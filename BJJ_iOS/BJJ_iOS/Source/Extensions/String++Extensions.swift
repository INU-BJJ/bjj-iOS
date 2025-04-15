//
//  String++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/24/25.
//

import Foundation

extension String {
    /// 서버에서 받은 날짜 문자열을 원하는 형식으로 변환
    /// - Parameters:
    ///   - fromFormat: 현재 날짜 문자열의 형식 (예: "yyyy-MM-dd")
    ///   - toFormat: 변환 후 원하는 날짜 형식 (예: "yyyy.MM.dd")
    /// - Returns: 변환된 날짜 문자열 (변환 실패 시 원본 문자열 반환)
    
    func convertDateFormat(fromFormat: String = "yyyy-MM-dd", toFormat: String = "yyyy.MM.dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        dateFormatter.dateFormat = fromFormat

        guard let date = dateFormatter.date(from: self) else {
            return self // 변환 실패 시 원본 문자열 반환
        }

        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    func calculateItemValidPeriod() -> String? {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        guard let validDate = formatter.date(from: self) else { return nil }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: validDate)

        guard let day = components.day, let hour = components.hour, let minute = components.minute else { return nil }
        
        switch (day, hour, minute) {
        case (let day, _, _) where day > 0:
            return "\(day)d"
        case (_, let hour, _) where hour > 0:
            return "\(hour)h"
        default:
            return "\(minute)m"
        }
    }
}
