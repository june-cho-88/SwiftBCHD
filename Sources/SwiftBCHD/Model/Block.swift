import Foundation

public struct Block {
    public let information: BlockInformation
    public var header: Block.Header { self.information.header }
    public let transactionHashes: [Data]
    
    public struct Header {
        let hash: Data
        let version: Int32
        let previousBlockHash: Data
        let merkleRoot: Data
        let timestamp: Int64
        let targetBits: UInt32
        let miningField: UInt32
        let confirmations: Int32
        let difficulty: Double
    }
}
