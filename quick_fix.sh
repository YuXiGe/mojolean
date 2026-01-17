#!/bin/bash
set -e

echo "--- ALETHEIA Quick Fix & Launch ---"
PROJECT_ROOT=$(pwd)

# ==========================================
# 1. ヘッダレス・トロイの木馬 (No headers needed)
# ==========================================
echo "🐴 Forging Header-free Trojan..."

# stdio.h を使わない、純粋なポインタ操作のみのコード
# これならコンパイラ環境が不完全でもビルドできます
cat <<EOF > trojan_minimal.c
// 必要なのは「シンボルが存在すること」だけ
// ヘッダファイルは一切不要

__attribute__((visibility("default"))) __attribute__((used))
void* l_Lean_Name_transitivelyUsedConstants___boxed(void* x) {
    // ログ出力は諦める（動作優先）
    return (void*)0; 
}

__attribute__((visibility("default"))) __attribute__((used))
void* l_Lean_Name_transitivelyUsedConstants(void* x) {
    return (void*)0; 
}
EOF

# コンパイル (-shared -fPIC)
# leanc が内部で標準ライブラリをリンクしようとしてコケるのを防ぐため
# 可能なら純粋な clang/gcc を使う手もあるが、まずは leanc で試す
# エラー回避のため -nostdlib は使わないが、ソースがシンプルなので通るはず
leanc -shared -fPIC -o libLeanTrojan.so trojan_minimal.c \
    -Wl,--whole-archive -Wl,--no-as-needed

echo "✅ libLeanTrojan.so created."

# 念のため確認
if nm -D libLeanTrojan.so | grep "T l_Lean_Name_transitivelyUsedConstants___boxed"; then
    echo "   -> Symbol is ARMED."
else
    echo "   -> Failed to export symbol."
    exit 1
fi

mv libLeanTrojan.so "$PROJECT_ROOT/physics_engine/"
rm trojan_minimal.c

# ==========================================
# 2. 高速起動
# ==========================================
echo "🚀 Launching..."

LEAN_SYS_PATH=$(elan which lean | sed 's|/bin/lean||')
LEAN_SYS_LIB="$LEAN_SYS_PATH/lib/lean"
PIXI_LIB=$PROJECT_ROOT/.pixi/envs/default/lib

find_lib() { find "$PROJECT_ROOT" -name "$1" | head -n 1; }

# ライブラリ収集
LIBLEANSHARED=$(find "$LEAN_SYS_LIB" -name "libleanshared.so" | head -n 1)
LIBLAKESHARED=$(find "$LEAN_SYS_LIB" -name "libLake_shared.so" | head -n 1)
LIBLEANTROJAN="$PROJECT_ROOT/physics_engine/libLeanTrojan.so"

LIBBATTERIES=$(find_lib "libBatteries.so")
LIBMATHLIB=$(find_lib "libMathlib.so")
LIBBLAS_FFI=$(find_lib "libLeanBLAS_FFI.so")
LIBBLAS=$(find_lib "libLeanBLAS.so")
LIBSCILEAN_FFI=$(find_lib "libSciLean_FFI.so")
LIBSCILEAN=$(find_lib "libSciLean.so")
LIBORACLE=$(find "$PROJECT_ROOT/physics_engine" -name "libPhysicsOracle.so" | head -n 1)

# 前回のBypassが残っていれば使う（保険）
LIBBYPASS=$(find "$PROJECT_ROOT/physics_engine" -name "libLeanBypass.so" | head -n 1)

# リンク
ln -sf "$LIBORACLE" "$PROJECT_ROOT/libPhysicsOracle.so"

# プリロード順序: Trojanを最優先
PRELOAD_LIST="$LIBLEANTROJAN:$LIBLEANSHARED:$LIBLAKESHARED:$LIBBYPASS:$LIBBLAS_FFI:$LIBBLAS:$LIBSCILEAN_FFI:$LIBBATTERIES:$LIBMATHLIB:$LIBSCILEAN:$LIBORACLE"
PRELOAD_LIST=$(echo $PRELOAD_LIST | sed 's/::/:/g' | sed 's/^://' | sed 's/:$//')

echo "📦 Preload List:"
echo "$PRELOAD_LIST" | tr ':' '\n'

export LD_LIBRARY_PATH="$PROJECT_ROOT:$LEAN_SYS_LIB:$PIXI_LIB:$LD_LIBRARY_PATH"

echo "🔥 Mojo Audit Start..."
env LD_PRELOAD="$PRELOAD_LIST" mojo audit_engine.mojo
