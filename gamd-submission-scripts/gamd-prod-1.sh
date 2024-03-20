#!/bin/bash
#SBATCH --job-name=40r.3c.r0.POPE
#SBATCH --exclusive
#SBATCH --account=beagle3-exusers
#SBATCH --partition=beagle3
#SBATCH -t 36:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --constraint=a40

NUM=1

module load namd/3.0b3-multicore-cuda   
namd3 +p4 +devices 0 +setcpuaffinity "gamd-prod-${NUM}.inp" > "gamd-prod-${NUM}.log"
