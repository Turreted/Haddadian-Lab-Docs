#!/bin/sh

#SBATCH --job-name=step6.2-batch
#SBATCH --exclusive
#SBATCH --account=beagle3-exusers
#SBATCH --partition=beagle3
#SBATCH -t 05:00:00
#SBATCH --nodes=1             # 2 nodes
#SBATCH --ntasks-per-node=1   # 1 process per node
#SBATCH --cpus-per-task=2     # 2 threads mapping to 2 cores per node (1 of them for inter-node comm)
#SBATCH --gres=gpu:2          # 2 GPUs per node

### each node has 4 GPUs and 32 CPUs
export PATH=${PATH=}:"/project2/haddadian/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA"

namd3 +p8 "step6.2_equilibration.inp" > "step6.2_equilibration.log"
