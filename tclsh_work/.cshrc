##
## PRINTER variabel "minlaser" settes iht. til hvilken avdeling du befinner deg i:
#if (! $?CSHRC_LOADED ) then
#  setenv CSHRC_LOADED 1
#else
#  exit 0
#endif
setenv PRINTER "minlaser"

setenv TOOLS ""
source /n/bin/cshrc.rc
#
# Add your own stuff below, could be an idea
# to check what the above file does first!!
#
bindkey ^r i-search-back
bindkey ^n i-search-fwd

### VC_WORKSPACE MESS ###############

#setenv VC_WORKSPACE /pro/quark4397/work/chsh/MyWorkspace

#QuarkFP2 WorkSpace
#setenv VC_WORKSPACE /pro/quark4413/work/chsh/QuarkFP2_WS
#setenv VC_WORKSPACE /pro/quark4413/work/chsh/QuarkFP2MPW1_dogit
#module load projects/QuarkFP2MPW1

setenv VC_WORKSPACE /pro/quark4430/work/chsh/QuarkGluon_WS_dogit
module unload projects
module load projects
#module load projects/QuarkFP2
module load projects/QuarkGluonFP1
#setenv VC_WORKSPACE /pro/quark4397/IntroProject_EGU/work/chsh/testxmlupdate
#setenv VC_WORKSPACE /pro/quark4397/work/chsh/MyWorkspace/Jenkins_WS_Nfc
###################








module swap eclipse/3.5.19_subclipse eclipse/4.4.1_subclipse
#module swap formality/2016.03-sp2 formality/2016.03-sp4
module load synopsys/spyglass/5.6.0.4
#module unload projects/LodeRunnerCommon
module load gnutools/grid-engine
#module load projects/QuarkFP1
set history=500000
set savehist = (500000 merge)
set symlinks="expand"
#dir_color specifies what color
alias ll 'ls -lAF --color=auto'
setenv HTML_NAVIGATOR "/cad/gnu/firefox/firefox17/firefox"
setenv SG_HTML_BROWSER "/cad/gnu/firefox/firefox17/firefox"
#export GREP_OPTIONS='-v \.svn/*'
setenv TERM xterm-256color
setenv DIFF_WORKSPACE $VC_WORKSPACE
#Used for generating FSDB files in Questa
setenv LD_LIBRARY_PATH /usr/lib/:/usr/lib64:/cad/synopsys/Verdi/so-lp_2014.03-SP2-9/share/PLI/MODELSIM/LINUX64:$LD_LIBRARY_PATH
alias startvnc vncserver :50 -geometry 3820x1160
alias stopvnc vncserver -kill :50
alias ,ec 'vim ~/.cshrc' # alias to open the cshrc file
alias ,sc 'source ~/.cshrc' #alias to source the cshrc file
alias ,ev 'vim ~/.vimrc' # alias to open the vimrc file

# SVN WS Aliases
alias DoConf 'svn up $VC_WORKSPACE/projects/quark/abc/quark.xml; $VC_WORKSPACE/projects/quark/abc/DoConfig -x $VC_WORKSPACE/projects/quark/abc/*.xml -d $VC_WORKSPACE |& tee DoConf.log ; upAll >> DoConf.log'
alias upAll 'echo "Updating $VC_WORKSPACE/ip ...."; svn up $VC_WORKSPACE/ip; echo "Updating $VC_WORKSPACE/products/LodeRunner/common ...."; svn up $VC_WORKSPACE/products/LodeRunner/common ; echo "Updating $VC_WORKSPACE/products/LodeRunner/QuarkFP2MPW1 ...."; svn up $VC_WORKSPACE/products/LodeRunner/QuarkFP2MPW1; echo "############"; echo "Updating methodology folder..."; svn up $VC_WORKSPACE/methodology/DesignKit'
#alias ip 'cd `~/scripts/superCd.py \!:*`'
alias swToTr '~/My-first-repo/scripts/./SwitchToTrunk.sh $1'
alias swToTag 'svn up $VC_WORKSPACE/projects/quark/abc/quark.xml; ~/My-first-repo/scripts/./SwitchToTag.sh \!*'
alias getMissing '~/My-first-repo/scripts/./get_missing_ip_from_repo.sh \!*'
# Grid
alias q 'qsub -N "-chsh-" -cwd -j y -o \$JOB_ID.log -M chirayu.shah@nordicsemi.no -m e $*'
alias qr 'qrsh -cwd -now no -N --chsh-- -pty yes -M chirayu.shah@nordicsemi.no -m beas -q alta-test01 $*'
# Any workspace
alias toptb 'cd ~/My-first-repo/scripts;. perlwrapper.sh -tb $1 $2'
alias tb 'cd "`~/My-first-repo/scripts/./superJump.sh -tb \!*`"'
alias ip ' cd "`~/My-first-repo/scripts/./superJump.sh -ip \!*`"'
alias prod 'cd "`~/My-first-repo/scripts/./superJump.sh -prod \!*`"'
alias proj 'cd "`~/My-first-repo/scripts/./superJump.sh -proj \!*`"'
alias ext 'cd "`~/My-first-repo/scripts/./superJump.sh -ext \!*`"'
alias meth 'cd "`~/My-first-repo/scripts/./superJump.sh -method \!*`"'
alias xterm '~/My-first-repo/scripts/./xterm-name.sh \!*'
alias setvc 'setenv VC_WORKSPACE $PWD'
alias deliv 'cd "`~/My-first-repo/scripts/./superJump.sh -deliv \!*`"'

#Git aliases
alias vc 'eval `dogit vc`'
alias rw 'dogit rw -s . ; cd `pwd`'
alias ro 'dogit ro -s . ; cd `pwd`'
alias DoGit 'dogit up |& tee dogitup.log'
alias getRW ' grep rw $VC_WORKSPACE/.dogitworkspace; cd $VC_WORKSPACE'
alias getKeep 'grep special $VC_WORKSPACE/.recipe ; '
alias cleanROWork 'find /work/chsh/deleted_rw_ttbs/ -type d -ctime +30 | cat ; find /work/chsh/deleted_rw_ttbs/ -type d -ctime +30 | xargs -p  rm -rf'
alias pushCWD 'dogit svnpush .'
alias svninfo 'rw ; grep "url" .git/config ; grep fetch .git/config'
# for git completion
source ~/.git-completion.tcsh
# will cause tab completion to show a menu of options when the completion choice is ambiguous
set autolist=ambiguous












# This is the setup for dogit -->
module load gnutools/git2.6.2
module load gnutools/anaconda3-2.4.0

setenv PATH /pri/chsh/dogit:$PATH
# <--
# source has to be at the end to overwrite
#Special alias precmd
alias precmd "source ~/My-first-repo/scripts/gitprompt.csh "
