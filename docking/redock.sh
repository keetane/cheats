#!/bin/bash
# sh redock.sh --pdb xxxx

#!/bin/bash

# 使用法チェック
if [ "$1" != "--pdb" ] || [ -z "$2" ]; then
    echo "Usage: $0 --pdb <pdb_id>"
    exit 1
fi

pdb=$(echo "$2" | tr '[:upper:]' '[:lower:]')  # 小文字に変換
pdb_file="${pdb}.pdb"
workdir="${pdb}_prep"

# 1. 作業ディレクトリ作成＆移動
mkdir -p "$workdir"
cd "$workdir" || exit 1

# 2. PDBファイルのダウンロード
echo "Downloading PDB file for $pdb..."
wget -q "https://files.rcsb.org/download/${pdb}.pdb" -O "$pdb_file"

if [ ! -f "$pdb_file" ]; then
    echo "Failed to download PDB file."
    exit 1
fi

# 3. 全ATOM（=タンパク質）を1つのファイルにまとめる（チェーン分割しない）
echo "Extracting full receptor (all chains)..."
grep "^ATOM" "$pdb_file" > "rec_${pdb}.pdb"

# 3. チェーンごとにタンパク質を分割
echo "Splitting chains..."
for chain in $(grep "^ATOM" "$pdb_file" | awk '{print substr($0, 22, 1)}' | sort | uniq); do
    grep "^ATOM" "$pdb_file" | grep " $chain " > "${pdb}_${chain}.pdb"
done

# 4. chain A の水 (HOH) を抽出
echo "Extracting water molecules from chain A..."
grep "^HETATM" "$pdb_file" |grep "HOH" > solv_${pdb}.pdb

# 5. 金属イオンを抽出
echo "Extracting metals..."
grep '^HETATM' "$pdb_file" | grep -E ' ZN | FE | MG | CA | NA | MN | CU | CO | K  ' > metal_${pdb}.pdb

# 6. chain A の HETATM から水と金属を除いたリガンドを抽出
echo "Extracting ligand from chain A (excluding water and metals)..."
grep "^HETATM" "$pdb_file" | grep " A " | grep -v "HOH" | grep -v -E ' ZN | FE | MG | CA | NA | MN | CU | CO | K  ' > lig_${pdb}.pdb

# local docking
smina \
--receptor rec_${pdb}.pdb \
--ligand lig_${pdb}.pdb \
--out redock_${pdb}_${today}.sdf \
--num_modes 3 \
--autobox_ligand lig_${pdb}.pdb \
--seed 0 \
--log log_local_dock_${pdb}_${today}


# global docking
smina \
--receptor rec_${pdb}.pdb \
--ligand lig_${pdb}.pdb \
--out redock_global_${pdb}_${today}.sdf \
--num_modes 9 \
--autobox_ligand rec_${pdb}.pdb \
--seed 0 \
--log log_global_dock_${pdb}_${today} \
# --exhaustiveness 64

# .pmlファイルに追記
echo "load prep_${pdb}_${today}.pdb" >> "${pdb}_${today}.pml"
echo "load redock_${pdb}_${today}.sdf" >> "${pdb}_${today}.pml"
echo "load redock_global_${pdb}_${today}.sdf" >> "${pdb}_${today}.pml"

# PyMOLで開く
pymol rec_${pdb}.pdb lig_${pdb}.pdb redock_${pdb}_${today}.sdf redock_global_${pdb}_${today}.sdf