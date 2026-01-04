/**
 * Satya-Chain: Inbuilt Local Blockchain Ledger
 * Provides immutable transaction logging for Dhar-Kosh (QuantumDB).
 * Uses SHA-256 for integrity verification.
 */

class SatyaChain {
  constructor() {
    this.chain = [];
    this.difficulty = 2;
    this.init();
  }

  async init() {
    // Create Genesis Block if chain is empty
    if (this.chain.length === 0) {
      const genesisBlock = await this.createBlock("Genesis Block", "0");
      this.chain.push(genesisBlock);
      console.log("⛓️ Satya-Chain Initialized: Genesis Block Created.");
    }
  }

  async createBlock(data, prevHash) {
    const timestamp = Date.now();
    const nonce = 0;
    const hash = await this.calculateHash(prevHash, timestamp, data, nonce);
    return {
      timestamp,
      data,
      prevHash,
      hash,
      nonce,
    };
  }

  async calculateHash(prevHash, timestamp, data, nonce) {
    const msgUint8 = new TextEncoder().encode(
      prevHash + timestamp + JSON.stringify(data) + nonce
    );
    const hashBuffer = await crypto.subtle.digest("SHA-256", msgUint8);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
  }

  async addTransaction(data) {
    const prevBlock = this.chain[this.chain.length - 1];
    const newBlock = await this.createBlock(data, prevBlock.hash);

    // Anti-Tamper Check: Verify chain integrity before adding
    if (await this.isChainValid()) {
      this.chain.push(newBlock);
      console.log(
        `⛓️ Satya-Chain: New block added. Hash: ${newBlock.hash.substring(
          0,
          10
        )}...`
      );
      this.saveToStorage();
      return true;
    } else {
      console.error("🚨 Satya-Chain: Chain integrity compromised!");
      return false;
    }
  }

  async isChainValid() {
    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const prevBlock = this.chain[i - 1];

      // Re-calculate hash to verify
      const reconstructedHash = await this.calculateHash(
        currentBlock.prevHash,
        currentBlock.timestamp,
        currentBlock.data,
        currentBlock.nonce
      );

      if (currentBlock.hash !== reconstructedHash) return false;
      if (currentBlock.prevHash !== prevBlock.hash) return false;
    }
    return true;
  }

  saveToStorage() {
    localStorage.setItem("satya_chain_ledger", JSON.stringify(this.chain));
  }

  loadFromStorage() {
    const saved = localStorage.getItem("satya_chain_ledger");
    if (saved) {
      this.chain = JSON.parse(saved);
    }
  }
}

window.SatyaChain = new SatyaChain();
window.SatyaChain.loadFromStorage();
