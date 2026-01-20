# 1. 環境変数をセット（Pixi内のヘッダーとライブラリを優先）
export C_INCLUDE_PATH=$PIXI_PROJECT_ROOT/.pixi/envs/default/include:$C_INCLUDE_PATH
export LIBRARY_PATH=$PIXI_PROJECT_ROOT/.pixi/envs/default/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$PIXI_PROJECT_ROOT/.pixi/envs/default/lib:$LD_LIBRARY_PATH

# Pixi環境のベースパスを取得（通常は .pixi/envs/default）
export PIXI_INCLUDE_PATH=$PIXI_PROJECT_ROOT/.pixi/envs/default/include
export PIXI_LIB_PATH=$PIXI_PROJECT_ROOT/.pixi/envs/default/lib

# GCCがヘッダーを探すパスに追加
export C_INCLUDE_PATH=$PIXI_INCLUDE_PATH:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$PIXI_INCLUDE_PATH:$CPLUS_INCLUDE_PATH

# リンカがビルド時にライブラリを探すパスに追加
export LIBRARY_PATH=$PIXI_LIB_PATH:$LIBRARY_PATH

# 実行時にライブラリを探すパスに追加
export LD_LIBRARY_PATH=$PIXI_LIB_PATH:$LD_LIBRARY_PATH

lake build PhysicsOracle:shared
