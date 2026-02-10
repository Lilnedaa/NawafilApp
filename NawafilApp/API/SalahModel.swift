import Foundation

struct AladhanTimingsResponse: Decodable {
    let code: Int
    let status: String
    let data: AladhanData
}

struct AladhanData: Decodable {
    let timings: PrayerTimings
    let date: AladhanDate
}

struct PrayerTimings: Decodable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct AladhanDate: Decodable {
    let readable: String
    let hijri: HijriDate
}

struct HijriDate: Decodable {
    let date: String
    let month: HijriMonth
}

struct HijriMonth: Decodable {
    let number: Int
    let en: String
    let ar: String?
}
