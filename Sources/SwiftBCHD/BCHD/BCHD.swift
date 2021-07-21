import Foundation
import Combine
import NIO
import GRPC

struct BCHD {
    private let client: Pb_bchrpcClient
    
    init(host: String, port: Int) {
        self.client = .init(channel: ClientConnection
                                .usingTLS(with: .makeClientConfigurationBackedByNIOSSL(),
                                          on: MultiThreadedEventLoopGroup(numberOfThreads: 1))
                                .connect(host: host, port: port))
    }
}

// MARK: - {Get} Requests
extension BCHD {
    func getBlockchainInformation() async throws -> Pb_GetBlockchainInfoResponse {
        let request = Pb_GetBlockchainInfoRequest()
        let response = try client.getBlockchainInfo(request, callOptions: .none).response.wait()
        return response
    }
    
    func getBlockInformation(of hash: Data) async throws -> Pb_GetBlockInfoResponse {
        var request = Pb_GetBlockInfoRequest()
        request.hash = hash
        let response = try client.getBlockInfo(request, callOptions: .none).response.wait()
        return response
    }
    
    func getBlock(of hash: Data) async throws -> Pb_GetBlockResponse {
        var request = Pb_GetBlockRequest()
        request.hash = hash
        let response = try client.getBlock(request, callOptions: .none).response.wait()
        return response
    }
    func getBlock(of height: Int32) async throws -> Pb_GetBlockResponse {
        var request = Pb_GetBlockRequest()
        request.height = height
        let response = try client.getBlock(request, callOptions: .none).response.wait()
        return response
    }
    
    func getRawBlock(of hash: Data) async throws -> Pb_GetRawBlockResponse {
        var request = Pb_GetRawBlockRequest()
        request.hash = hash
        let response = try client.getRawBlock(request, callOptions: .none).response.wait()
        return response
    }
    func getRawBlock(of height: Int32) async throws -> Pb_GetRawBlockResponse {
        var request = Pb_GetRawBlockRequest()
        request.height = height
        let response = try client.getRawBlock(request, callOptions: .none).response.wait()
        return response
    }
    
    func getBlockFilter(of hash: Data) async throws -> Pb_GetBlockFilterResponse {
        var request = Pb_GetBlockFilterRequest()
        request.hash = hash
        let response = try client.getBlockFilter(request, callOptions: .none).response.wait()
        return response
    }
    func getBlockFilter(of height: Int32) async throws -> Pb_GetBlockFilterResponse {
        var request = Pb_GetBlockFilterRequest()
        request.height = height
        let response = try client.getBlockFilter(request, callOptions: .none).response.wait()
        return response
    }
    
    func get2000Headers(above height: Int32) async throws -> Pb_GetHeadersResponse {
        var request = Pb_GetHeadersRequest()
        request.blockLocatorHashes = [try await getBlock(of: height).block.info.hash]
        let response = try client.getHeaders(request, callOptions: .none).response.wait()
        return response
    }
    
    func getMerkleProof(of transactionHash: Data) async throws -> Pb_GetMerkleProofResponse {
        var request = Pb_GetMerkleProofRequest()
        request.transactionHash = transactionHash
        let response = try client.getMerkleProof(request, callOptions: .none).response.wait()
        return response
    }
    
    func getMempoolInformation() async throws -> Pb_GetMempoolInfoResponse {
        let request = Pb_GetMempoolInfoRequest()
        let response = try client.getMempoolInfo(request, callOptions: .none).response.wait()
        return response
    }
    
    func getUnconfirmedTransactionHashesInMempool() async throws -> Pb_GetMempoolResponse {
        let request = Pb_GetMempoolRequest()
        let response = try client.getMempool(request, callOptions: .none).response.wait()
        return response
    }
    
    func getTransaction(of hash: Data) async throws -> Pb_GetTransactionResponse {
        var request = Pb_GetTransactionRequest()
        request.hash = hash
        let response = try client.getTransaction(request, callOptions: .none).response.wait()
        return response
    }
    
    func getRawTransaction(of hash: Data) async throws -> Pb_GetRawTransactionResponse {
        var request = Pb_GetRawTransactionRequest()
        request.hash = hash
        let response = try client.getRawTransaction(request, callOptions: .none).response.wait()
        return response
    }
    
    func getTransactions(in blockHash: Data) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.hash = blockHash
        let response = try client.getAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    func getTransactions(in blockHeight: Int32) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.height = blockHeight
        let response = try client.getAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    func getTransactions(in address: String) async throws -> Pb_GetAddressTransactionsResponse {
        var request = Pb_GetAddressTransactionsRequest()
        request.address = address
        let response = try client.getAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    
    func getRawTransactions(in blockHash: Data) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.hash = blockHash
        let response = try client.getRawAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    func getRawTransactions(in blockHeight: Int32) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.height = blockHeight
        let response = try client.getRawAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    func getRawTransactions(in address: String) async throws -> Pb_GetRawAddressTransactionsResponse {
        var request = Pb_GetRawAddressTransactionsRequest()
        request.address = address
        let response = try client.getRawAddressTransactions(request, callOptions: .none).response.wait()
        return response
    }
    
    func getUnspentOutput(in transactionHash: Data, includeUnconfirmed: Bool) async throws -> Pb_GetUnspentOutputResponse {
        var request = Pb_GetUnspentOutputRequest()
        request.hash = transactionHash
        request.includeMempool = includeUnconfirmed
        let response = try client.getUnspentOutput(request, callOptions: .none).response.wait()
        return response
    }
    
    func getUnspentOutputs(in address: String, includeUnconfirmed: Bool) async throws -> Pb_GetAddressUnspentOutputsResponse {
        var request = Pb_GetAddressUnspentOutputsRequest()
        request.address = address
        request.includeMempool = includeUnconfirmed
        let response = try client.getAddressUnspentOutputs(request, callOptions: .none).response.wait()
        return response
    }
}

// MARK: - {Subscribe} Requests

@available(iOSApplicationExtension 13.0, *)
@available(macOSApplicationExtension 10.15, *)
extension BCHD {
    func subscribeBlocks(blockSubject: PassthroughSubject<Block.Header, Never>) async {
        let request = Pb_SubscribeBlocksRequest()
        
        do {
            _ = try client.subscribeBlocks(request, callOptions: .none) { notification in
                let information = notification.blockInfo
                
                blockSubject.send(.init(hash: information.hash,
                                        version: information.version,
                                        previousBlockHash: information.previousBlock,
                                        merkleRoot: information.merkleRoot,
                                        timestamp: information.timestamp,
                                        targetBits: information.bits,
                                        miningField: information.nonce,
                                        confirmations: information.confirmations,
                                        difficulty: information.difficulty))
            }.status.wait()
        }
        catch {
            print(error)
        }
    }
    
    func subscribeTransactions(unconfirmedTransactionSubject: PassthroughSubject<UnconfirmedTransaction, Never>) async {
        var request = Pb_SubscribeTransactionsRequest()
        
        request.subscribe.allTransactions = true
        request.includeMempool = true
        
        do {
            _ = try client.subscribeTransactions(request, callOptions: .none) { notification in
                let unconfirmed = notification.unconfirmedTransaction
                
                unconfirmedTransactionSubject.send(.init(bchdMempoolTransaction: unconfirmed))
            }.status.wait()
        }
        catch {
            print(error)
        }
    }
}

// MARK: - {Submit} Requests
extension BCHD {
    func submit(rawTransaction: Data) async throws -> Pb_SubmitTransactionResponse {
        var request = Pb_SubmitTransactionRequest()
        request.transaction = rawTransaction
        let response = try client.submitTransaction(request, callOptions: .none).response.wait()
        return response
    }
}
