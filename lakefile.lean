import Lake
open Lake DSL

package PhysicsOracle where
  -- Pixi環境のパス設定
  moreLeancArgs := #[
    "-I.pixi/envs/default/include",
    "-DNDEBUG",
    "-O3",
    "-fPIC"
  ]
  moreLinkArgs := #[
    "-L.pixi/envs/default/lib",
    "-lopenblas",
    "-rdynamic"
  ]

-- 修正：依存パッケージ名を正確に `scilean` に合わせます
require scilean from git
  "https://github.com/lecopivo/SciLean.git" @ "master"

@[default_target]
lean_lib PhysicsOracle where
  precompileModules := true
  srcDir := "src"  -- これを追加
  roots := #[`SimpleOracle]

-- Cブリッジの定義（Mojoとの衝突回避用）
extern_lib libleanbridge pkg := do
  let name := "leanbridge"
  let src := pkg.dir / "src" / "bridge.c"
  
  -- ソースファイルをビルドジョブに変換
  let srcJob ← inputTextFile src
  
  let flags := #[
    "-fPIC",
    "-I.pixi/envs/default/include",
    "-I" ++ (← getLeanIncludeDir).toString
  ]
  
  buildO name srcJob flags
