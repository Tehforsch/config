## Config folder
export CONFIG=$HOME/projects/config
export work=/beegfs/work/ws/hd_hp240-arepoTest-0/
export PATH=$PATH:$HOME/projects/neovim/install/usr/local/bin
export VIMEXE=$HOME/projects/neovim/install/usr/local/bin/nvim
source ~/.cargo/env
export scripts=/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/config/scripts/
export WORK=/gpfs/bwfor/home/hd/hd_hd/hd_hp240/work/

alias ml='module list'
alias ma='module avail'
alias fd='$HOME/projects/fd/target/release/fd'
alias showout='tail $(ls -l --sort=time | head -n 2 | tail -n 1 | tr -s " " | cut -f 9 -d " ") -n 50'
alias loadpython='module load devel/python_intel/3.6'
alias ag='grep -R'
unalias e
unalias cat
alias e="vim"
alias sb="sbatch"
alias sc="scancel"
alias sq="squeue"
alias mb="make build -j 16"
alias l="ls -lah --color=auto"
alias ls="ls"
alias interactive="srun --partition=single --ntasks=3 --time=2:00:00 --pty /bin/bash"
alias refreshpybob="$HOME/projects/config/scripts/pybobRequest.sh"
alias pybob="python $HOME/projects/pybob/main.py"
unalias pyplot
alias plot="~/projects/cpython/python ~/projects/pybob/main.py --hide plot ."
alias refreshplot="$HOME/projects/config/scripts/pybobRequest.sh --hide plot ."
alias sq="squeue -u tpeter"
alias show="~/projects/config/scripts/showJobOutput.sh"

export PATH=$PATH:/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/gitAnnex/git-annex.linux
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/hd/hd_hd/hd_hp240/projects/gmp/lib
export GMPDIR=$HOME/projects/gmp/
export HWLOC_DIR=$HOME/projects/hwloc/
export PATH=$PATH:/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/gitAnnex/git-annex.linux
export LIBCLANG_PATH=/mpcdf/soft/SLE_15/packages/x86_64/clang/15.0.7/lib
export HDF5_DIR=/mpcdf/soft/SLE_15/packages/skylake/hdf5/intel_19.1.3-19.1.3/1.12.2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HDF5_HOME/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GSL_HOME/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FFTW_HOME/lib

