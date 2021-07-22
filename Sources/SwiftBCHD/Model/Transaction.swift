import Foundation

public struct Transaction {
    public let hash: Data
    public let version: Int32
    public let inputs: [Input]
    public let outputs: [Output]
    public let size: Int32
    public let timestamp: Int64
    public let confirmations: Int32
    public let blockHash: Data
    public let blockHeight: Int32
    
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
    public let transaction: Transaction
    public let time: Int64
    public let height: Int32
    public let fee: Int64
    public let feePerKb: Int64
    public let priority: Double
    
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
    public struct Output {
        public let index: UInt32
        public let value: Int64
        public let address: String
        public let scriptFormat: String
        public let lockingScript: Data
        
        init(bchdOutput: Pb_Transaction.Output) {
            self.index = bchdOutput.index
            self.value = bchdOutput.value
            self.address = bchdOutput.address
            self.scriptFormat = bchdOutput.scriptClass
            self.lockingScript = bchdOutput.pubkeyScript
        }
    }
    
    public struct UnspentOutput {
        public let outpoint: (index: UInt32, hash: Data)
        public let value: Int64
        public let lockingScript: Data
        public let blockHeight: Int32
        
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
    public struct Input {
        public let outpoint: (index: UInt32, hash: Data)
        public let value: Int64
        public let address: String
        public let previousLockingScript: Data
        public let unlockingScript: Data
        public let sequence: UInt32
        
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
