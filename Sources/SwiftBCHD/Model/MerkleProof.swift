import Foundation

public struct MerkleProof {
    public let header: Block.Header
    public let transactionHashes: [Data]
    public let flags: Data
}
