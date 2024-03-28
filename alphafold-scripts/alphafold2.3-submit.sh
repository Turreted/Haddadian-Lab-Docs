#!/bin/bash
#SBATCH --job-name=alphafold-demo
#SBATCH --account=beagle3-exusers
#SBATCH --partition=beagle3
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:2
#SBATCH --mem=64G

module load alphafold/2.3.2 cuda/11.3

# shamelessley ripped from https://github.com/kalininalab/alphafold_non_docker/blob/main/run_alphafold.sh
usage() {
        echo ""
        echo "Please make sure all required parameters are given"
        echo "Usage: $0 <OPTIONS>"
        echo "Required Parameters:"
        echo "-f <fasta_paths>      Path to FASTA files containing sequence(s). If a FASTA file contains multiple sequences, then it will be folded as a multimer. To fold more sequences one after another, write the files separated by a comma"
        echo "Optional Parameters:"
        echo "-t <max_template_date>    Maximum template release date to consider (ISO-8601 format - i.e. YYYY-MM-DD). Important if folding historical test sets (Default: 2022-1-1)"
        echo "-p <use_precomputed_msas> Denotes if the program should use MSAs that have already been generated by a previous run. (Default: false)"
	echo "-o <output_dir>           Path to a directory that will store the results. (Default: current directory)"
        echo ""
        exit 1
}

# Default Parameters
max_template_date="1000-02-20"
use_precomputed_msas=false
DOWNLOAD_DATA_DIR=/software/alphafold-data-2.3

while getopts ":d:o:f:t:g:r:e:n:a:m:c:p:l:b:" i; do
        case "${i}" in
        d)
                data_dir=$OPTARG
        ;;
        o)
                output_dir=$(realpath $OPTARG)
        ;;
        f)
                fasta_path=$(realpath $OPTARG)
        ;;
        t)
                max_template_date=$OPTARG
        ;;
        p)
                use_precomputed_msas=$OPTARG
        ;;
        esac
done

# Parse input and set defaults
if [[ "$fasta_path" == "" ]] ; then
    usage
fi

if [[ "$output_dir" == "" ]] ; then
    $output_dir="."
fi

if [[ "$data_dir" != "" ]] ; then
    DOWNLOAD_DATA_DIR=$data_dir
fi

if [[ "$model_preset" != "monomer" && "$model_preset" != "monomer_casp14" && "$model_preset" != "monomer_ptm" && "$model_preset" != "multimer" ]] ; then
    echo "Unknown model preset! Using default ('mutimer')"
    model_preset="multimer"
fi

# Parse database paths which are different for monomer / multimer
if [[ $model_preset == "multimer" ]]; then
	database_paths="--uniprot_database_path=$DOWNLOAD_DATA_DIR/uniprot/uniprot_sprot.fasta --pdb_seqres_database_path=$DOWNLOAD_DATA_DIR/pdb_seqres/pdb_seqres.txt"
else
	database_paths="--pdb70_database_path=$DOWNLOAD_DATA_DIR/pdb70/pdb70"
fi

echo "Running Alphafold with arguments: model=${model_preset}, use_precomputed_msas=${use_precomputed_msas}, max_template_date=${max_template_date}, fasta_file=${fasta_path}"

python /software/alphafold-2.3.2-el8-x86_64/run_alphafold.py  \
  --data_dir=$DOWNLOAD_DATA_DIR  \
  $database_paths \
  --uniref90_database_path=$DOWNLOAD_DATA_DIR/uniref90/uniref90.fasta  \
  --mgnify_database_path=$DOWNLOAD_DATA_DIR/mgnify/mgy_clusters_2022_05.fa  \
  --bfd_database_path=$DOWNLOAD_DATA_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt  \
  --uniref30_database_path=$DOWNLOAD_DATA_DIR/uniref30/UniRef30_2021_03 \
  --template_mmcif_dir=$DOWNLOAD_DATA_DIR/pdb_mmcif/mmcif_files  \
  --obsolete_pdbs_path=$DOWNLOAD_DATA_DIR/pdb_mmcif/obsolete.dat \
  --model_preset=$model_preset \
  --max_template_date=${max_template_date} \
  --db_preset=full_dbs \
  --use_gpu_relax=true \
  --models_to_relax=all \
  --use_precomputed_msas=${use_precomputed_msas} \
  --output_dir=$output_dir \
  --fasta_paths=$fasta_path