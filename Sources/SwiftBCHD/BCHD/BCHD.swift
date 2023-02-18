import Foundation
import Combine
import NIO
import GRPC

struct BCHD {
    private let client: Pb_bchrpcClient
    let eventLoopGroup: EventLoopGroup
    
    init(host: String, port: Int, on eventLoopGroup: EventLoopGroup) {
        self.eventLoopGroup = eventLoopGroup
        self.client = .init(
            channel: ClientConnection
                .usingTLS(with: .makeClientConfigurationBackedByNIOSSL(),
                          on: self.eventLoopGroup)
                .connect(host: host, port: port))
    }
    
    func disconnect() throws {
        _ = self.client.channel.close()
        try self.eventLoopGroup.syncShutdownGracefully()
    }
}

// MARK: - {Get} Requests
extension BCHD {
    func getBlockchainInformation() async throws -> Pb_GetBlockchainInfoResponse {
        let request = Pb_GetBlockchainInfoRequest()
        let response = try await client.getBlockchainInfo(request, callOptions: .none).response.get()
        return response
    }
    
    func getBlockInformation(of hash: Data) async throws -> Pb_GetBlockInfoResponse {
        var request = Pb_GetBlockInfoRequest()
        request.hash = hash
        let response = try await client.getBlockInfo(request, callOptions: .none).response.get()
        return response
    }
    
    func getBlock(of hash: Data) async throws -> Pb_GetBlockResponse {
        var request = Pb_GetBlockRequest()
        request.hash = hash
        let response = try await client.getBlock(request, callOptions: .none).response.get()
        return response
    }
    func getBlock(of height: Int32) async throws -> Pb_GetBlockResponse {
        var request = Pb_GetBlockRequest()
        request.height = height
        let response = try await client.getBlock(request, callOptions: .none).response.get()
        return response
    }
    
    func getRawBlock(of hash: Data) async throws -> Pb_GetRawBlockResponse {
        var request = Pb_GetRawBlockRequest()
        request.hash = hash
        let response = try await client.getRawBlock(request, callOptions: .none).response.get()
        return response
    }
    func getRawBlock(of height: Int32) async throws -> Pb_GetRawBlockResponse {
        var request = Pb_GetRawBlockRequest()
        request.height = height
        let response = try await client.getRawBlock(request, callOptions: .none).response.get()
        return response
    }
    
    func getBlockFilter(of hash: Data) async throws -> Pb_GetBlockFilterResponse {
        var request = Pb_GetBlockFilterRequest()
        request.hash = hash
        let response = try await client.getBlockFilter(request, callOptions: .none).response.get()
        return response
    }
    func getBlockFilter(of height: Int32) async throws -> Pb_GetBlockFilterResponse {
        var request = Pb_GetBlockFilterRequest()
        request.height = height
        let response = try await client.getBlockFilter(request, callOptions: .none).response.get()
        return response
    }
    
    func getBlockHeaders() async throws -> Pb_GetHeadersResponse {
        let request = Pb_GetHeadersRequest()
        
        let response = try await client.getHeaders(request, callOptions: .none).response.get()
        return response
    }
    
    func get2000BlockHeaders(above height: Int32) async throws -> Pb_GetHeadersResponse {
        var request = Pb_GetHeadersRequest()
        request.blockLocatorHashes = [try await getBlock(of: height).block.info.hash]
        let response = try await client.getHeaders(request, callOptions: .none).response.get()
        return response
    }
    
    func getMerkleProof(of transactionHash: Data) async throws -> Pb_GetMerkleProofResponse {
        var request = Pb_GetMerkleProofRequest()
        request.transactionHash = transactionHash
        let response = try await client.getMerkleProof(request, callOptions: .none).response.get()
        return response
    }
    
    func getMempoolInformation() async throws -> Pb_GetMempoolInfoResponse {
        let request = Pb_GetMempoolInfoRequest()
        let response = try await client.getMempoolInfo(request, callOptions: .none).response.get()
        return response
    }
    
    func getUnconfirmedTransactionHashesInMempool() async throws -> Pb_GetMempoolResponse {
        let request = Pb_GetMempoolRequest()
        let response = try await client.getMempool(request, callOptions: .none).response.get()
        return response
    }
    
    func getTransaction(of hash: Data) async throws -> Pb_GetTransactionResponse {
        var request = Pb_GetTransactionRequest()
        request.hash = hash
        let response = try await client.getTransaction(request, callOptions: .none).response.get()
        return response
    }
    
    func getRawTransaction(of hash: Data) async throws -> Pb_GetRawTransactionResponse {
        var request = Pb_GetRawTransactionRequest()
        request.hash = hash
        let response = try await client.getRawTransaction(request, callOptions: .none).response.get()
        return response
    }
    
    func getTransactions(in blockHash: Data) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.hash = blockHash
        let response = try await client.getAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    func getTransactions(in blockHeight: Int32) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.height = blockHeight
        let response = try await client.getAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    func getTransactions(in address: String) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.address = address
        let response = try await client.getAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    
    func getRawTransactions(in blockHash: Data) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.hash = blockHash
        let response = try await client.getRawAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    func getRawTransactions(in blockHeight: Int32) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.height = blockHeight
        let response = try await client.getRawAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    func getRawTransactions(in address: String) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.address = address
        let response = try await client.getRawAddressTransactions(request, callOptions: .none).response.get()
        return response
    }
    
    func getUnspentOutput(in transactionHash: Data, includeUnconfirmed: Bool) async throws -> Pb_GetUnspentOutputResponse {
        var request = Pb_GetUnspentOutputRequest()
        request.hash = transactionHash
        request.includeMempool = includeUnconfirmed
        let response = try await client.getUnspentOutput(request, callOptions: .none).response.get()
        return response
    }
    
    func getUnspentOutputs(in address: String, includeUnconfirmed: Bool) async throws -> Pb_GetAddressUnspentOutputsResponse {
        var request = Pb_GetAddressUnspentOutputsRequest()
        request.address = address
        request.includeMempool = includeUnconfirmed
        let response = try await client.getAddressUnspentOutputs(request, callOptions: .none).response.get()
        return response
    }
}

// MARK: - {Subscribe} Requests

extension BCHD {
    func subscribeBlocks(to publisher: PassthroughSubject<Block.Header, Never>) async throws -> GRPCStatus {
        let request = Pb_SubscribeBlocksRequest()
        
        let status = try await client.subscribeBlocks(request, callOptions: .none) { notification in
            let information = notification.blockInfo
            
            publisher.send(.init(version: information.version,
                                 previousBlockHash: information.previousBlock,
                                 merkleRoot: information.merkleRoot,
                                 timestamp: information.timestamp,
                                 targetBits: information.bits,
                                 miningField: information.nonce))
        }.status.get()
        
        return status
    }
    
    func subscribeTransactions(to publisher: PassthroughSubject<UnconfirmedTransaction, Never>) async throws -> GRPCStatus {
        var request = Pb_SubscribeTransactionsRequest()
        
        request.subscribe.allTransactions = true
        request.includeMempool = true
        
        let status = try await client.subscribeTransactions(request, callOptions: .none) { notification in
            let unconfirmed = notification.unconfirmedTransaction
            
            publisher.send(.init(bchdMempoolTransaction: unconfirmed))
        }.status.get()
        
        return status
    }
}

// MARK: - {Submit} Requests
extension BCHD {
    func submit(rawTransaction: Data) async throws -> Pb_SubmitTransactionResponse {
        var request = Pb_SubmitTransactionRequest()
        request.transaction = rawTransaction
        let response = try await client.submitTransaction(request, callOptions: .none).response.get()
        return response
    }
}
