import { Transfer as TransferEvent } from "../generated/BaseToken/BaseToken";
import { Transfer } from "../generated/schema";

export function handleTransfer(event: TransferEvent): void {
  const id = event.transaction.hash.toHex() + '-' + event.logIndex.toString();
  let entity = new Transfer(id);
  entity.txHash = event.transaction.hash;
  entity.blockNumber = event.block.number;
  entity.timestamp = event.block.timestamp;
  entity.from = event.params.from;
  entity.to = event.params.to;
  entity.value = event.params.value;
  entity.save();
}
