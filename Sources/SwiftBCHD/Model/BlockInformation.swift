import Foundation

public struct BlockInformation {
    public let header: Block.Header
    public let nextBlockHash: Data
    public let size: Int32
    public let medianTime: Int64
}
