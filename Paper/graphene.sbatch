#! /usr/bin/bash -l
#SBATCH -J "graphene"
#SBATCH --ntasks=16
#SBATCH -o graphene.out
mpirun abinit fbandgraphene.in
