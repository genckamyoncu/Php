import { useMemo, useState } from 'react';
import { RainbowKitProvider, ConnectButton, darkTheme, getDefaultConfig } from '@rainbow-me/rainbowkit';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WagmiProvider, useWriteContract } from 'wagmi';
import { base, baseSepolia } from 'wagmi/chains';
import { parseAbi } from 'viem';

const queryClient = new QueryClient();

const config = getDefaultConfig({
  appName: 'Base NFT Minter',
  projectId: 'BASE-NFT-MINTER-DEMO',
  chains: [base, baseSepolia],
});

const abi = parseAbi([
  'function mintTo(address recipient, string tokenURI) external returns (uint256)'
]);

const CONTRACT_ADDRESS = (import.meta.env.VITE_NFT_CONTRACT_ADDRESS || '0x0000000000000000000000000000000000000000') as `0x${string}`;

function MintForm() {
  const [recipient, setRecipient] = useState('');
  const [tokenURI, setTokenURI] = useState('');
  const { writeContract, isPending, error, data } = useWriteContract();

  const disabled = useMemo(() => !recipient || !tokenURI || isPending, [recipient, tokenURI, isPending]);

  return (
    <form
      className="card"
      onSubmit={(event) => {
        event.preventDefault();
        writeContract({
          address: CONTRACT_ADDRESS,
          abi,
          functionName: 'mintTo',
          args: [recipient as `0x${string}`, tokenURI],
        });
      }}
    >
      <label>
        Alıcı Adresi
        <input value={recipient} onChange={(e) => setRecipient(e.target.value)} placeholder="0x..." />
      </label>
      <label>
        Token URI
        <input value={tokenURI} onChange={(e) => setTokenURI(e.target.value)} placeholder="ipfs://..." />
      </label>
      <button type="submit" disabled={disabled}>
        {isPending ? 'Gönderiliyor...' : 'Mint Et'}
      </button>
      {data && <p>İşlem hash: {data}</p>}
      {error && <p className="error">Hata: {error.message}</p>}
    </form>
  );
}

export default function App() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider theme={darkTheme()}>
          <div className="layout">
            <header>
              <h1>Base NFT Minter</h1>
              <ConnectButton />
            </header>
            <MintForm />
          </div>
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
