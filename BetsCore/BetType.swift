//
//  BetType.swift
//  BetsCore
//
//  Created by Omar Torres on 4/18/24.
//

public struct BetType: RawRepresentable, Hashable {
	public let rawValue: String
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
	
	static func autoNamed(_ rawValue: StaticString = #function) -> Self {
		Self(rawValue: "\(rawValue)")
	}
	
	public static var playerPerfomance: Self { autoNamed() }
	public static var totalScore: Self { autoNamed() }
	public static var winningTeam: Self { autoNamed() }
}
