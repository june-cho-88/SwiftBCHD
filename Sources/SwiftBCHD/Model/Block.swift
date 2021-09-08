import Foundation

public struct Block {
    public let hash: Data
    public let header: Block.Header
    public let transactionHashes: [Data]?
    
    public let confirmations: Int32
    public let difficulty: Double
    public let medianTime: Int64
    public let size: Int32
    public let nextBlockHash: Data
    
    public struct Header {
        public let version: Int32
        public let previousBlockHash: Data
        public let merkleRoot: Data
        public let timestamp: Int64
        public let targetBits: UInt32
        public let miningField: UInt32
    }
}
