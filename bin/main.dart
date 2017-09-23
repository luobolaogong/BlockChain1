// Be careful to use the right documentation for Crypto, since it has changed:
// https://www.dartdocs.org/documentation/crypto/2.0.2/crypto/crypto-library.html
//
import 'package:crypto/crypto.dart';


main() {
  int difficulty = 4;
  int blockNumber = 0;
  int maxBlocks = 10;
  List<Block> blockChain = new List<Block>();
  Stopwatch stopWatch = new Stopwatch();

  print("Start mining $maxBlocks blocks at difficulty $difficulty at " + (new DateTime.now()).toString());

  Digest genesisBlockHash = new Digest([]); // guess
  String genesisBlockTransactions = "satoshi>rob=1000000;";
  Block block = new Block(difficulty, blockNumber, genesisBlockHash, genesisBlockTransactions); // genesis block
  blockChain.add(block);
  print("Genesis block: ${block.thisBlockHash.toString()} : ${block.transactions}");

  for (int blkCtr = blockNumber + 1; blkCtr < maxBlocks; blkCtr++) {
    String transactions = "satoshi>rob=${(1 + blkCtr) * 10};" + "rob>peter=${1 + blkCtr};";
    stopWatch.start();
    block = new Block(difficulty, blkCtr, block.thisBlockHash, transactions);
    blockChain.add(block);
    stopWatch.stop();
    print("Processed block ${block.blockNumber} in ${stopWatch.elapsed.inMilliseconds} ms."
            "  Previous block hash: ${block.previousBlockHash.toString().substring(0,difficulty+4)}... "
            ": Current block hash: ${block.thisBlockHash.toString().substring(0,difficulty+4)}... "
            ": nonce: ${block.nonce}, ${block.transactions}");
    stopWatch.reset();
  }
  print("Processing ended at " + (new DateTime.now()).toString());
  print("\nThe block chain has ${blockChain.length} blocks holding the following transactions:");
  for (int blockCtr = 0; blockCtr < blockChain.length; blockCtr++) {
    print("\t${blockChain[blockCtr].transactions}");
  }
  print("Done");
}

///
/// A Block is composed of three things: the hash (Digest) of the previous block,
/// the current transactions, and the hash (Digest) of those two.
class Block {
  int blockNumber;
  int nonce; // this is the guess, when mining, and it changes so we only add it to the contents when it's found.
  int difficulty;
  Digest previousBlockHash; // this becomes part of the contents
  String transactions; // this becomes part of the contents
  Digest thisBlockHash; // this is the hash of the combination of previousBlockHash and transactions string

  Block(this.difficulty, this.blockNumber, this.previousBlockHash, this.transactions) {
    String contents = previousBlockHash.toString() + " : " + transactions;
    mine(difficulty, contents);
  }

  ///
  /// Find a nonce that will satisfy the difficulty requirement
  ///
  mine(int difficulty, String contents) {
    StringBuffer zerosBuffer = new StringBuffer();
    for (int zeroCtr = 0; zeroCtr < difficulty; zeroCtr++) {
      zerosBuffer.write("0");
    }
    String zeros = zerosBuffer.toString();
    StringBuffer contentsPlusNonce = new StringBuffer();
    for (int nonceCtr = 0; true; nonceCtr++) {
      contentsPlusNonce.write(contents + nonceCtr.toRadixString(16));
      Digest digest = sha256.convert(contentsPlusNonce.toString().runes.toList(growable:false));
      String digestAsString = digest.toString();
      if (digestAsString.startsWith(zeros)) {
        nonce = nonceCtr;
        thisBlockHash = digest;
        return;
      }
      contentsPlusNonce.clear();
    }
  }
}
