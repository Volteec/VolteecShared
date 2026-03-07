import XCTest
@testable import VolteecShared

final class PlaceholderTests: XCTestCase {
    func testServerStatusResponseDecodesLegacyPayload() throws {
        let json = """
        {
          "version": "1.0.7",
          "protocolVersion": "1.1",
          "compatibility": "supported"
        }
        """

        let response = try JSONDecoder().decode(ServerStatusResponse.self, from: Data(json.utf8))

        XCTAssertEqual(response.version, "1.0.7")
        XCTAssertEqual(response.protocolVersion, "1.1")
        XCTAssertEqual(response.compatibility, .supported)
        XCTAssertNil(response.relayCurrentProtocolVersion)
        XCTAssertNil(response.relayMinProtocolVersion)
    }

    func testServerStatusResponseDecodesExtendedPayload() throws {
        let json = """
        {
          "version": "1.0.7",
          "protocolVersion": "1.1",
          "compatibility": "supported",
          "relayCurrentProtocolVersion": "1.1",
          "relayMinProtocolVersion": "1.0"
        }
        """

        let response = try JSONDecoder().decode(ServerStatusResponse.self, from: Data(json.utf8))

        XCTAssertEqual(response.version, "1.0.7")
        XCTAssertEqual(response.protocolVersion, "1.1")
        XCTAssertEqual(response.compatibility, .supported)
        XCTAssertEqual(response.relayCurrentProtocolVersion, "1.1")
        XCTAssertEqual(response.relayMinProtocolVersion, "1.0")
    }
}
