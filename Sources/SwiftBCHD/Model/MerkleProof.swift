import Foundation

public struct MerkleProof {
    let header: Block.Header
    let transactionHashes: [Data]
    let flags: Data
}
