package main

import (
    "context"
    "fmt"
    "log"
    "math/big"
    "os"

    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/ethclient"
    "github.com/joho/godotenv"
)

func main() {
    _ = godotenv.Load()

    rpcURL := getenv("BASE_RPC_URL", "https://mainnet.base.org")
    addressHex := os.Getenv("ADDRESS")
    if addressHex == "" {
        log.Fatal("ADDRESS env değişkeni gereklidir")
    }

    address := common.HexToAddress(addressHex)

    client, err := ethclient.Dial(rpcURL)
    if err != nil {
        log.Fatalf("RPC bağlantısı kurulamadı: %v", err)
    }
    defer client.Close()

    balance, err := client.BalanceAt(context.Background(), address, nil)
    if err != nil {
        log.Fatalf("Bakiye okunamadı: %v", err)
    }

    ethValue := new(big.Float).Quo(new(big.Float).SetInt(balance), big.NewFloat(1e18))
    fmt.Printf("Adres: %s\n", addressHex)
    fmt.Printf("Wei: %s\n", balance.String())
    fmt.Printf("ETH: %f\n", ethValue)
}

func getenv(key, fallback string) string {
    value := os.Getenv(key)
    if value == "" {
        return fallback
    }
    return value
}
