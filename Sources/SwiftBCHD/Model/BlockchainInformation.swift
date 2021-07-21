import Foundation

public struct BlockchainInformation {
    let lastBlockHeight: Int32
    let lastBlockHash: Data
    let difficulty: Double
    let lastElevenBlocksMedianTime: Int64
    let hasFullTransactionIndex: Bool
}
