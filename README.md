# docker-isdb-scanner

ISDB デジタル放送チャンネルスキャン用の [ISDBScanner](https://github.com/tsukumijima/ISDBScanner) Docker イメージです。

## 含まれるコンポーネント

| コンポーネント | バージョン | 説明 |
|--------------|----------|------|
| [ISDBScanner](https://github.com/tsukumijima/ISDBScanner) | 1.3.3 | ISDB デジタル放送チャンネルスキャナー |
| [recisdb-rs](https://github.com/kazuki0824/recisdb-rs) | 1.2.4 | B-CAS カードリーダー / TS ストリームデコーダー |

## イメージ

GitHub Container Registry で公開しています:

```
ghcr.io/longkey1/isdb-scanner:latest
ghcr.io/longkey1/isdb-scanner:<isdb-scanner-version>-latest
ghcr.io/longkey1/isdb-scanner:<tag>
```

`<tag>` はリリースタグ（例: `1.3.3-1`）です。

対応プラットフォーム: `linux/amd64`, `linux/arm64`

## バージョン管理

各コンポーネントのバージョンはリポジトリルートのバージョンファイルで管理しています:

| ファイル | 対象 |
|---------|------|
| `.isdb-scanner-version` | ISDBScanner のリリースバージョン |
| `.recisdb-rs-version` | recisdb-rs のリリースバージョン |

## 使い方

デバイスファイルや出力ディレクトリを必要に応じてマウントしてください:

```yaml
services:
  isdb-scanner:
    image: ghcr.io/longkey1/isdb-scanner:latest
    devices:
      - /dev/bus/usb:/dev/bus/usb
    volumes:
      - ./output:/work
    environment:
      - LOCAL_UID=1000
      - LOCAL_GID=1000
```

## ビルド

`*.*.*-*` パターンのタグプッシュをトリガーに、GitHub Actions で自動的にビルドして GHCR へ公開します。

タグのフォーマット: `<isdb-scanner-version>-<build-number>`（例: `1.3.3-1`）

新規リリース:

```bash
make release dryrun=false
```

既存タグの再リリース:

```bash
make re-release dryrun=false           # 最新タグを再リリース
make re-release tag=1.3.3-1 dryrun=false  # 指定タグを再リリース
```
