//
//  DateFormatterManager.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/19/26.
//

import Foundation
import Then

final class DateFormatterManager {

    // MARK: - Singleton

    static let shared = DateFormatterManager()

    // MARK: - Properties

    /// 한국 로케일 날짜 포맷터 (재사용)
    /// 기본 형식: "yyyy-MM-dd" → "yyyy.MM.dd"
    private let koreanDateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    /// 아이템 유효기간 파싱용 포맷터 (재사용)
    /// 형식: "yyyy-MM-dd'T'HH:mm:ss"
    private let itemValidPeriodFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    /// Calendar 인스턴스 (재사용)
    private let calendar = Calendar.current
    
    // MARK: - Init

    private init() {}

    // MARK: - Methods

    /// 서버에서 받은 날짜 문자열을 원하는 형식으로 변환
    /// - Parameters:
    ///   - dateString: 변환할 날짜 문자열
    ///   - fromFormat: 현재 날짜 문자열의 형식 (예: "yyyy-MM-dd")
    ///   - toFormat: 변환 후 원하는 날짜 형식 (예: "yyyy.MM.dd")
    /// - Returns: 변환된 날짜 문자열 (변환 실패 시 원본 문자열 반환)
    func convertDateFormat(from dateString: String, fromFormat: String = "yyyy-MM-dd", toFormat: String = "yyyy.MM.dd") -> String {
        koreanDateFormatter.dateFormat = fromFormat

        guard let date = koreanDateFormatter.date(from: dateString) else {
            return dateString // 변환 실패 시 원본 문자열 반환
        }
        
        koreanDateFormatter.dateFormat = toFormat
        return koreanDateFormatter.string(from: date)
    }

    /// 아이템 유효기간 계산
    /// - Parameter dateString: 유효기간 날짜 문자열 (형식: "yyyy-MM-dd'T'HH:mm:ss")
    /// - Returns: 남은 기간 문자열 (d/h/m 형식) 또는 nil (파싱 실패 시)
    func calculateItemValidPeriod(from dateString: String) -> String? {
        guard let validDate = itemValidPeriodFormatter.date(from: dateString) else {
            return nil
        }

        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: validDate)

        guard let day = components.day, let hour = components.hour, let minute = components.minute else {
            return nil
        }

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
