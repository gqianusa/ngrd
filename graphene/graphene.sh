#! /bin/bash
#PBS -N graphene
#PBS -l walltime=1:0:0
#PBS -l select=ncpus=4

#env
cd $PBS_O_WORKDIR
mpirun -n $NCPUS -f $PBS_NODEFILE /usr/local/bin/abinit < graphene.files
