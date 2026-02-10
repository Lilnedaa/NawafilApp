import Foundation

enum AladhanAPIError: Error {
    case badURL
    case badResponse(Int)
}

struct AladhanAPIClient {

    private static let baseURL = URL(string: "https://api.aladhan.com/v1")!

    static func get<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem]
    ) async throws -> T {

        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else { throw AladhanAPIError.badURL }

        components.queryItems = queryItems

        guard let url = components.url else { throw AladhanAPIError.badURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw AladhanAPIError.badResponse(-1)
        }
        guard (200...299).contains(http.statusCode) else {
            throw AladhanAPIError.badResponse(http.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension AladhanAPIClient {

    /// GET /timings/{date}?latitude=..&longitude=..&method=..
    static func fetchTimings(
        latitude: Double,
        longitude: Double,
        date: Date = Date(),
        method: Int = 4,
        timezone: String,
        school: Int = 0
    ) async throws -> AladhanTimingsResponse {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: timezone) ?? .current
        formatter.dateFormat = "dd-MM-yyyy"

        let dateString = formatter.string(from: date)

        let queryItems: [URLQueryItem] = [
            .init(name: "latitude", value: String(latitude)),
            .init(name: "longitude", value: String(longitude)),
            .init(name: "method", value: String(method)),
            .init(name: "timezonestring", value: timezone),
            .init(name: "school", value: String(school))
        ]

        return try await get("timings/\(dateString)", queryItems: queryItems)
    }
}
