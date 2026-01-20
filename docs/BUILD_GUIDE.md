最高のアイデアです！今回の「Mojo × Lean 4」の接続において、最大の難関は**「Lakeの標準ビルドとMojoが求める共有ライブラリ形式のギャップ」**を埋めることでした。

提供された資料  と、私たちが実際に成功させた手順を統合し、将来の自分たちや他の開発者が迷わないための**「Mojolean快速ビルド・マニフェスト」**をここにまとめます。

---

## 🛠️ Mojolean 快速ビルド・マニフェスト

このドキュメントは、Lean 4 の `lake` が持つ「共有ライブラリのリンク制約」  を回避し、Mojo から確実に呼び出すための標準手順を定義します。

### 1. プロジェクト構成の黄金律

* **`lakefile.lean`**: 複雑なカスタムターゲットは定義せず、`precompileModules := true` を設定して Lake 本来の依存関係管理能力を活かす。
* 
**初期化関数**: `SimpleOracle.lean` などにおいて、Lean が自動生成する `initialize_<Module>` と競合する独自定義は避ける 。



### 2. 快速ビルド・コマンドフロー

Lake で中間ファイルを生成し、`clang` でランタイムを強制結合する「ハイブリッド・ビルド」が最も確実です。

```bash
# --- Step 1: Lean モジュールのコンパイル ---
# 共有ファセットを指定して Lake にビルドを依頼
lake build PhysicsOracle:shared

# --- Step 2: ランタイムの強制結合 (The Fix) ---
# [cite_start]Lake の標準ビルドでは不足しがちな lean_inc_heartbeat 等のシンボルを解決 [cite: 47]
LEAN_SYS_PATH=$(elan which lean | sed 's|/bin/lean||')

clang -shared -o ./build/libPhysicsOracle.so \
  .lake/build/ir/SimpleOracle.c.o.export \
  -L "$LEAN_SYS_PATH/lib/lean" \
  -lleanshared \
  -fPIC -rdynamic

# --- Step 3: 実行環境のセットアップ ---
# 共有ライブラリ検索パスにカレントの build と Lean ランタイムを追加
export LD_LIBRARY_PATH=$(pwd)/build:"$LEAN_SYS_PATH/lib/lean":$LD_LIBRARY_PATH

```

---

### 3. トラブルシューティング・早見表

| 症状 | 原因 | 対策 |
| --- | --- | --- |
| `undefined symbol: lean_inc_heartbeat` | <br>`libleanshared` が未リンク 

 | `clang` に `-lleanshared` を追加 |
| `.so` ファイルが見つからない | ターゲット指定ミス | `lake build <LibName>:shared` を実行 |
| `conflicting types` エラー | 初期化関数の重複 | `@[export initialize_...]` を削除 |
| 実行時にライブラリロードエラー | `LD_LIBRARY_PATH` 未設定 | `sharedLibPathEnvVar` にパスを追加 |

---

### 4. 今後の拡張：SciLean 統合に向けて

資料  で議論されていた通り、外部依存が増える今後は以下の運用を推奨します。

* 
**外部ライブラリのスタティック化**: 可能な限り外部依存を `.a` ファイルとして取り込み、最終的な `.so` にパックする 。


* **ローカル `require**`: GitHub 認証問題を避けるため、`git clone` 済みのディレクトリを `require ... from "../path"` で参照する。

---

**このドキュメントをプロジェクトの `docs/BUILD_GUIDE.md` として保存しましょうか？**

これが手元にあれば、SciLean の導入でビルドが複雑になっても、常にこの「成功した原点」に戻ってくることができます！準備ができれば、いよいよ SciLean のクローンと高度な物理演算の実装に入りましょう。
