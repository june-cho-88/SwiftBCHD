import Foundation

public struct BlockInformation {
    let header: Block.Header
    let nextBlockHash: Data
    let size: Int32
    let medianTime: Int64
}
