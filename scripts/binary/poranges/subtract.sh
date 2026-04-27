set -euo pipefail

bin="${PORANGES_BENCH_BIN:-poranges_bench/target/release/poranges-bench}"

if [ ! -x "$bin" ]; then
    echo "Build poranges first with: cargo build --release --manifest-path poranges_bench/Cargo.toml" >&2
    exit 127
fi

exec "$bin" subtract "$1" "$2"
