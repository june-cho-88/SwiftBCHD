import Foundation
import Combine
import NIO

public struct SwiftBCHD {
    private let bchd: BCHD
    private let eventLoopGroup: EventLoopGroup
    
    public init(host: String, port: Int, on eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)) {
        self.eventLoopGroup = eventLoopGroup
        self.bchd = .init(host: host, port: port, on: eventLoopGroup)
    }
    
    public func disconnect() throws {
        try self.bchd.disconnect()
    }
}

extension SwiftBCHD {
    // MARK: - {Get}
    
    public func getBlockchain() async throws -> Blockchain {
        let blockchainInformation = try await bchd.getBlockchainInformation()
        
        return .init(lastBlockHeight: blockchainInformation.bestHeight,
                     lastBlockHash: blockchainInformation.bestBlockHash,
                     difficulty: blockchainInformation.difficulty,
                     lastElevenBlocksMedianTime: blockchainInformation.medianTime,
                     hasFullTransactionIndex: blockchainInformation.txIndex)
    }
    
    public func getBlockHeader(of hash: Data) async throws -> Block.Header {
        let blockInformation = try await bchd.getBlockInformation(of: hash).info
        
        return .init(version: blockInformation.version,
                     previousBlockHash: blockInformation.previousBlock,
                     merkleRoot: blockInformation.merkleRoot,
                     timestamp: blockInformation.timestamp,
                     targetBits: blockInformation.bits,
                     miningField: blockInformation.nonce)
    }
    
    public func getBlock(of hash: Data) async throws -> Block {
        let block = try await bchd.getBlock(of: hash).block
        let information = block.info
        let transactionHashes = block.transactionData.map {$0.transactionHash}
        
        return .init(hash: information.hash,
                     header: .init(version: information.version,
                                   previousBlockHash: information.previousBlock,
                                   merkleRoot: information.merkleRoot,
                                   timestamp: information.timestamp,
                                   targetBits: information.bits,
                                   miningField: information.nonce),
                     transactionHashes: transactionHashes,
                     confirmations: information.confirmations,
                     difficulty: information.difficulty,
                     medianTime: information.medianTime,
                     size: information.size,
                     nextBlockHash: information.nextBlockHash)
    }
    public func getBlock(of height: Int32) async throws -> Block {
        let block = try await bchd.getBlock(of: height).block
        let information = block.info
        let transactionHashes = block.transactionData.map {$0.transactionHash}
        
        return .init(hash: information.hash,
                     header: .init(version: information.version,
                                   previousBlockHash: information.previousBlock,
                                   merkleRoot: information.merkleRoot,
                                   timestamp: information.timestamp,
                                   targetBits: information.bits,
                                   miningField: information.nonce),
                     transactionHashes: transactionHashes,
                     confirmations: information.confirmations,
                     difficulty: information.difficulty,
                     medianTime: information.medianTime,
                     size: information.size,
                     nextBlockHash: information.nextBlockHash)
    }
    
    public func getRawBlock(of hash: Data) async throws -> Data {
        let rawBlock = try await bchd.getRawBlock(of: hash)
        return rawBlock.block
    }
    public func getRawBlock(of height: Int32) async throws -> Data {
        let rawBlock = try await bchd.getRawBlock(of: height)
        return rawBlock.block
    }
    
    public func getBlockFilter(of hash: Data) async throws -> Data {
        let blockFilter = try await bchd.getBlockFilter(of: hash)
        return blockFilter.filter
    }
    public func getBlockFilter(of height: Int32) async throws -> Data {
        let blockFilter = try await bchd.getBlockFilter(of: height)
        return blockFilter.filter
    }
    
    public func get2000BlockHeaders(above height: Int32) async throws -> [Block.Header] {
        let headers = try await bchd.get2000BlockHeaders(above: height)
        
        return headers.headers.map { Block.Header(version: $0.version,
                                                  previousBlockHash: $0.previousBlock,
                                                  merkleRoot: $0.merkleRoot,
                                                  timestamp: $0.timestamp,
                                                  targetBits: $0.bits,
                                                  miningField: $0.nonce) }
    }
    
    public func getMerkleProof(of transactionHash: Data) async throws -> MerkleProof {
        let merkleProof = try await bchd.getMerkleProof(of: transactionHash)
        let header = merkleProof.block
        
        return .init(header: .init(version: header.version,
                                   previousBlockHash: header.previousBlock,
                                   merkleRoot: header.merkleRoot,
                                   timestamp: header.timestamp,
                                   targetBits: header.bits,
                                   miningField: header.nonce),
                     transactionHashes: merkleProof.hashes,
                     flags: merkleProof.flags)
    }
    
    public func getMempoolInformation() async throws -> MempoolInformation {
        let mempoolInformation = try await bchd.getMempoolInformation()
        
        return .init(numberOfTransaction: mempoolInformation.size,
                     sizeInBytes: mempoolInformation.bytes)
    }
    
    public func getUnconfirmedTransactionHashesInMempool() async throws -> [Data] {
        let mempool = try await bchd.getUnconfirmedTransactionHashesInMempool()
        
        return mempool.transactionData.map {$0.transactionHash}
    }
    
    public func getTransaction(of hash: Data) async throws -> Transaction {
        let transaction = try await bchd.getTransaction(of: hash)
        
        return .init(bchdTransaction: transaction.transaction)
    }
    
    public func getRawTransaction(of hash: Data) async throws -> Data {
        let rawTransaction = try await bchd.getRawTransaction(of: hash)
        
        return rawTransaction.transaction
    }
    
    public func getTransactions(of blockHash: Data) async throws -> (confirmed: [Transaction], unconfirmed: [UnconfirmedTransaction]) {
        let transactions = try await bchd.getTransactions(in: blockHash)
        
        let confirmed = transactions.confirmedTransactions.map { Transaction(bchdTransaction: $0) }
        let unconfirmed = transactions.unconfirmedTransactions.map { UnconfirmedTransaction(bchdMempoolTransaction: $0) }
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getTransactions(of blockHeight: Int32) async throws -> (confirmed: [Transaction], unconfirmed: [UnconfirmedTransaction]) {
        let transactions = try await bchd.getTransactions(in: blockHeight)
        
        let confirmed = transactions.confirmedTransactions.map { Transaction(bchdTransaction: $0) }
        let unconfirmed = transactions.unconfirmedTransactions.map { UnconfirmedTransaction(bchdMempoolTransaction: $0) }
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getTransactions(in address: String) async throws -> (confirmed: [Transaction], unconfirmed: [UnconfirmedTransaction]) {
        let transactions = try await bchd.getTransactions(in: address)
        
        let confirmed = transactions.confirmedTransactions.map { Transaction(bchdTransaction: $0) }
        let unconfirmed = transactions.unconfirmedTransactions.map { UnconfirmedTransaction(bchdMempoolTransaction: $0) }
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getRawTransactions(of blockHash: Data) async throws -> (confirmed: [Data], unconfirmed: [Data]) {
        let transactions = try await bchd.getRawTransactions(in: blockHash)
        
        let confirmed = transactions.confirmedTransactions
        let unconfirmed = transactions.unconfirmedTransactions
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getRawTransactions(of blockHeight: Int32) async throws -> (confirmed: [Data], unconfirmed: [Data]) {
        let transactions = try await bchd.getRawTransactions(in: blockHeight)
        
        let confirmed = transactions.confirmedTransactions
        let unconfirmed = transactions.unconfirmedTransactions
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getRawTransactions(in address: String) async throws -> (confirmed: [Data], unconfirmed: [Data]) {
        let transactions = try await bchd.getRawTransactions(in: address)
        
        let confirmed = transactions.confirmedTransactions
        let unconfirmed = transactions.unconfirmedTransactions
        
        return (confirmed: confirmed, unconfirmed: unconfirmed)
    }
    
    public func getUnspentOutput(in transactionHash: Data, includeUnconfirmed: Bool) async throws -> Transaction.UnspentOutput {
        let unspentOutput = try await bchd.getUnspentOutput(in: transactionHash, includeUnconfirmed: includeUnconfirmed)
        
        return .init(outpoint: (index: unspentOutput.outpoint.index, hash: unspentOutput.outpoint.hash),
                     value: unspentOutput.value,
                     lockingScript: unspentOutput.pubkeyScript,
                     blockHeight: unspentOutput.blockHeight)
    }
    
    public func getUnspentOutputs(in address: String, includeUnconfirmed: Bool) async throws -> [Transaction.UnspentOutput] {
        let unspentOutputs = try await bchd.getUnspentOutputs(in: address, includeUnconfirmed: includeUnconfirmed).outputs
        
        return unspentOutputs.map { Transaction.UnspentOutput(bchdUnspentOutput: $0) }
    }
    
    // MARK: - {Subscribe}
    
    public func subscribeBlocks(to publisher: PassthroughSubject<Block.Header, Never>) async throws {
        _ = try await bchd.subscribeBlocks(to: publisher)
    }
    
    public func subscribeBlocks(execute: @escaping (Block.Header) -> Void) async throws -> AnyCancellable {
        let blockPublisher: PassthroughSubject<Block.Header, Never> = .init()
        let subscription = blockPublisher.sink(receiveValue: execute)
        
        _ = try await bchd.subscribeBlocks(to: blockPublisher)
        
        return subscription
    }
    
    public func subscribeTransactions(to publisher: PassthroughSubject<UnconfirmedTransaction, Never>) async throws {
        _ = try await bchd.subscribeTransactions(to: publisher)
    }
    
    public func subscribeTransactions(execute: @escaping (UnconfirmedTransaction) -> Void) async throws -> AnyCancellable {
        let transactionPublisher: PassthroughSubject<UnconfirmedTransaction, Never> = .init()
        let subscription = transactionPublisher.sink(receiveValue: execute)
        
        _ = try await bchd.subscribeTransactions(to: transactionPublisher)
        
        return subscription
    }
    
    // MARK: - {Submit}
    
    public func submit(rawTransaction: Data) async throws {
        _ = try await bchd.submit(rawTransaction: rawTransaction)
    }
}
