#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
PATH="$PATH:~/.cabal/bin"

export GEM_HOME=$HOME/.gem
PATH="/home/selene/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/selene/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/selene/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/selene/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/selene/perl5"; export PERL_MM_OPT;
alias config='/usr/bin/git --git-dir=/home/selene/.cfg/ --work-tree=/home/selene'
