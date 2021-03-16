source ~/.bashrc

# Add home binary dir to PATH
if [[ -d "$HOME/bin" ]] ; then
  export PATH="$PATH:$HOME/bin"
  echo $HOME
  echo $PATH
fi
