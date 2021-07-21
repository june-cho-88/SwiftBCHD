import Foundation

public struct Transaction {
    let hash: Data
    let version: Int32
    let inputs: [Input]
    let outputs: [Output]
    let size: Int32
    let timestamp: Int64
    let confirmations: Int32
    let blockHash: Data
    let blockHeight: Int32
    
    init(bchdTransaction: Pb_Transaction) {
        self.hash = bchdTransaction.hash
        self.version = bchdTransaction.version
        self.inputs = bchdTransaction.inputs.map { Transaction.Input(bchdInput: $0) }
        self.outputs = bchdTransaction.outputs.map { Transaction.Output(bchdOutput: $0) }
        self.size = bchdTransaction.size
        self.timestamp = bchdTransaction.timestamp
        self.confirmations = bchdTransaction.confirmations
        self.blockHash = bchdTransaction.blockHash
        self.blockHeight = bchdTransaction.blockHeight
    }
}

public struct UnconfirmedTransaction {
    let transaction: Transaction
    let time: Int64
    let height: Int32
    let fee: Int64
    let feePerKb: Int64
    let priority: Double
    
    init(bchdMempoolTransaction: Pb_MempoolTransaction) {
        self.transaction = .init(bchdTransaction: bchdMempoolTransaction.transaction)
        self.time = bchdMempoolTransaction.addedTime
        self.height = bchdMempoolTransaction.addedHeight
        self.fee = bchdMempoolTransaction.fee
        self.feePerKb = bchdMempoolTransaction.feePerKb
        self.priority = bchdMempoolTransaction.startingPriority
    }
}

extension Transaction {
    struct Output {
        let index: UInt32
        let value: Int64
        let address: String
        let scriptFormat: String
        let lockingScript: Data
        
        init(bchdOutput: Pb_Transaction.Output) {
            self.index = bchdOutput.index
            self.value = bchdOutput.value
            self.address = bchdOutput.address
            self.scriptFormat = bchdOutput.scriptClass
            self.lockingScript = bchdOutput.pubkeyScript
        }
    }
    
    public struct UnspentOutput {
        let outpoint: (index: UInt32, hash: Data)
        let value: Int64
        let lockingScript: Data
        let blockHeight: Int32
        
        init(bchdUnspentOutput: Pb_UnspentOutput) {
            self.outpoint = (index: bchdUnspentOutput.outpoint.index, hash: bchdUnspentOutput.outpoint.hash)
            self.value = bchdUnspentOutput.value
            self.lockingScript = bchdUnspentOutput.pubkeyScript
            self.blockHeight = bchdUnspentOutput.blockHeight
        }
        
        init(outpoint: (index: UInt32, hash: Data), value: Int64, lockingScript: Data, blockHeight: Int32) {
            self.outpoint = outpoint
            self.value = value
            self.lockingScript = lockingScript
            self.blockHeight = blockHeight
        }
    }
}

extension Transaction {
    struct Input {
        let outpoint: (index: UInt32, hash: Data)
        let value: Int64
        let address: String
        let previousLockingScript: Data
        let unlockingScript: Data
        let sequence: UInt32
        
        init(bchdInput: Pb_Transaction.Input) {
            self.outpoint = (index: bchdInput.outpoint.index, hash: bchdInput.outpoint.hash)
            self.value = bchdInput.value
            self.address = bchdInput.address
            self.previousLockingScript = bchdInput.previousScript
            self.unlockingScript = bchdInput.signatureScript
            self.sequence = bchdInput.sequence
        }
    }
}
