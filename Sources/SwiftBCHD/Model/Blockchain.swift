import Foundation

public struct Blockchain {
    public let lastBlockHeight: Int32
    public let lastBlockHash: Data
    public let difficulty: Double
    public let lastElevenBlocksMedianTime: Int64
    public let hasFullTransactionIndex: Bool
}
