#!/bin/sh

#SBATCH --job-name=gideonm-md
#SBATCH --exclusive
#SBATCH --time=36:00:00
#SBATCH --exclusive
#SBATCH --partition=caslake
#SBATCH --nodes=6
#SBATCH --ntasks-per-node=48
#SBATCH --account=pi-haddadian

module load namd

mpiexec.hydra -bootstrap=slurm namd2 "gamd-equilib.inp" > "gamd-equilib.log"
