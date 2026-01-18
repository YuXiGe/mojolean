#!/bin/bash
set -e

LEAN_SYS_PATH=$(elan which lean | sed 's|/bin/lean||')
SRC_DIR="./src"
BUILD_DIR="./build"

mkdir -p $BUILD_DIR

echo "🔨 Building Lean Logic: $SRC_DIR/SimpleOracle.lean"

# 1. Lean -> C
lean $SRC_DIR/SimpleOracle.lean -c $BUILD_DIR/SimpleOracle.c

# 2. C -> Shared Object
# -fPIC と -rdynamic を追加してシンボルを公開する
clang -shared -o $BUILD_DIR/libPhysicsOracle.so $BUILD_DIR/SimpleOracle.c \
  -I "$LEAN_SYS_PATH/include" \
  -L "$LEAN_SYS_PATH/lib/lean" \
  -l leanshared -fPIC -rdynamic

echo "✅ Build Complete: $BUILD_DIR/libPhysicsOracle.so"
