#!/bin/bash
# sh redock.sh --pdb xxxx

# 日付を取得
today=$(date '+%Y%m%d')

# 引数の処理
pdb=""

# オプションの解析
while [ $# -gt 0 ]; do
  case $1 in
    --pdb)
      pdb=$2
      shift 2
      ;;
    *)
      echo "Usage: $0 [--pdb pdb]"
      exit 1
      ;;
  esac
done

# 引数が指定されていない場合の処理
if [ -z "$pdb" ]; then
  echo "Usage: $0 [--pdb pdb]"
  exit 1
fi

# ディレクトリ作成および移動
mkdir -p "$pdb"
cd "$pdb" || exit

# pdbfixerコマンドの実行
pdbfixer --pdbid="$pdb" --output="prep_$pdb_${today}.pdb" --ph=7

# receptorとligandの準備
grep ATOM prep_$pdb_${today}.pdb > rec_$pdb.pdb
grep HETATM prep_$pdb_${today}.pdb > lig_$pdb.pdb

# local docking
smina \
--receptor rec_$pdb.pdb \
--ligand lig_$pdb.pdb \
--out redock_$pdb_${today}.sdf \
--num_modes 3 \
--autobox_ligand lig_$pdb.pdb \
--seed 0 \
--log log_local_dock_$pdb_${today}


# global docking
smina \
--receptor rec_$pdb.pdb \
--ligand lig_$pdb.pdb \
--out redock_global_$pdb_${today}.sdf \
--num_modes 9 \
--autobox_ligand rec_$pdb.pdb \
--seed 0 \
--log log_global_dock_$pdb_${today} \
# --exhaustiveness 64

# .pmlファイルに追記
echo "load prep_${pdb}_${today}.pdb" >> "${pdb}_${today}.pml"
echo "load redock_$pdb_${today}.sdf" >> "${pdb}_${today}.pml"
echo "load redock_global_$pdb_${today}.sdf" >> "${pdb}_${today}.pml"

