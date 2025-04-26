#!/bin/bash

# 使用法チェック
if [ "$1" != "--pdb" ] || [ -z "$2" ]; then
    echo "Usage: $0 --pdb <pdb_id>"
    exit 1
fi

pdb_id=$(echo "$2" | tr '[:upper:]' '[:lower:]')  # 小文字に変換
pdb_file="${pdb_id}.pdb"
workdir="${pdb_id}_prep"

# 1. 作業ディレクトリ作成＆移動
mkdir -p "$workdir"
cd "$workdir" || exit 1

# 2. PDBファイルのダウンロード
echo "Downloading PDB file for $pdb_id..."
wget -q "https://files.rcsb.org/download/${pdb_id}.pdb" -O "$pdb_file"

if [ ! -f "$pdb_file" ]; then
    echo "Failed to download PDB file."
    exit 1
fi

# 3. 全ATOM（=タンパク質）を1つのファイルにまとめる（チェーン分割しない）
echo "Extracting full receptor (all chains)..."
grep "^ATOM" "$pdb_file" > "rec_${pdb_id}.pdb"

# 4. チェーンごとにタンパク質を分割
echo "Splitting chains..."
for chain in $(grep "^ATOM" "$pdb_file" | awk '{print substr($0, 22, 1)}' | sort | uniq); do
    grep "^ATOM" "$pdb_file" | grep " $chain " > "${pdb_id}_${chain}.pdb"
done

# 5. chain A の水 (HOH) を抽出
echo "Extracting water molecules from chain A..."
grep "^HETATM" "$pdb_file" |grep "HOH" > solv_${pdb_id}.pdb

# 6. 金属イオンを抽出
echo "Extracting metals..."
grep '^HETATM' "$pdb_file" | grep -E ' ZN | FE | MG | CA | NA | MN | CU | CO | K  ' > metal_${pdb_id}.pdb

# 7. chain A の HETATM から水と金属を除いたリガンドを抽出
echo "Extracting ligand from chain A (excluding water and metals)..."
grep "^HETATM" "$pdb_file" | grep " A " | grep -v "HOH" | grep -v -E ' ZN | FE | MG | CA | NA | MN | CU | CO | K  ' > "lig_${pdb_id}.pdb"


echo "All processing done in directory: $workdir"
