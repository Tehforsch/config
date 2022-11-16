## Config folder
export CONFIG=$HOME/projects/config
export work=/beegfs/work/ws/hd_hp240-arepoTest-0/
export PATH=$PATH:$HOME/projects/neovim/install/usr/local/bin
export VIMEXE=$HOME/projects/neovim/install/usr/local/bin/nvim
source ~/.cargo/env
export scripts=/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/config/scripts/
export WORK=/gpfs/bwfor/home/hd/hd_hd/hd_hp240/work/

alias ml='module list'
alias ma='module spider'
alias fd='$HOME/projects/fd/target/release/fd'
alias showout='tail $(ls -l --sort=time | head -n 2 | tail -n 1 | tr -s " " | cut -f 9 -d " ") -n 50'
alias loadpython='module load devel/python_intel/3.6'
# alias vim='$HOME/projects/vimPool/openExistingInstance.sh'
alias ag='grep -R'
unalias e
unalias cat
alias e="vim"
alias sb="sbatch"
alias sc="scancel"
alias sq="squeue"
alias bu="make build -j 16"
alias l="ls -lah --color=auto"
alias ls="ls"
alias interactive="srun --partition=single --ntasks=3 --time=2:00:00 --pty /bin/bash"
alias pybob="$HOME/projects/config/scripts/pybobRequest.sh"
alias oldpybob="python $HOME/projects/pybob/main.py"
unalias pyplot
alias pyplot="~/projects/cpython/python ~/projects/pybob/main.py --post plot ."

export PATH=$PATH:/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/gitAnnex/git-annex.linux
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/hd/hd_hd/hd_hp240/projects/gmp/lib
export GMPDIR=$HOME/projects/gmp/
export HWLOC_DIR=$HOME/projects/hwloc/
export PATH=$PATH:/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/gitAnnex/git-annex.linux
export LIBCLANG_PATH=$HOME/projects/libclang/llvm-project/build/lib

