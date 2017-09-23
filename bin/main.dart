// Be careful to use the right documentation for Crypto, since it has changed:
// https://www.dartdocs.org/documentation/crypto/2.0.2/crypto/crypto-library.html
//
import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

main() {
  List<Block> blockChain = new List<Block>();
  Digest genesisBlockHash = new Digest([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]); // guess
  String genesisBlockTransactions = "satoshi>rob=1000000;";
  Block block = new Block(genesisBlockHash, genesisBlockTransactions); // genesis block
  blockChain.add(block);
  print("${block.previousBlockHash.toString().substring(0,4)}... : ${block.thisBlockHash.toString().substring(0,4)}... : ${block.transactions}");

  for (int blkCtr = 0; blkCtr < 5; blkCtr++) {
    String transactions = "satoshi>rob=${(1 + blkCtr) * 10};" + "rob>peter=${1 + blkCtr};";
    block = new Block(block.thisBlockHash, transactions);
    blockChain.add(block);
    print("${block.previousBlockHash.toString().substring(0,4)}... : ${block.thisBlockHash.toString().substring(0,4)}... : ${block.transactions}");
  }
}

///
/// A Block is composed of three things: the hash (Digest) of the previous block,
/// the current transactions, and the hash (Digest) of those two.
class Block {
  int blockNumber;
  int nonce;
  int difficultyZeros;
  Digest previousBlockHash;
  String transactions;
  Digest thisBlockHash;

  Block(this.previousBlockHash, this.transactions) {
    mine();
    String contents = previousBlockHash.toString() + " : " + transactions;
    thisBlockHash = sha256.convert(contents.runes.toList(growable:false));
  }

  ///
  /// Find a nonce that will satisfy the difficulty requirement
  mine() {

  }
}
