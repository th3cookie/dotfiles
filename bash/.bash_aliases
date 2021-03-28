# Basic ones first
alias ll='ls -alh --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF'
alias ls='ls --color=auto'
alias lt='ls --human-readable --size -1 -S --classify'
alias mv="mv -v"
alias cp="cp -v"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Work Specific
alias pulldev='ssh -tq puppet02 "bash -ic pulldev"'
alias pullstaging='ssh -tq puppet02 "bash -ic pullstaging"'

# Systemctl
alias sysstart="systemctl start"
alias sysstop="systemctl stop"
alias sysrestart="systemctl restart"
alias sysstatus="systemctl status"
alias sysenable="systemctl enable"
alias sysdisable="systemctl disable"

# Docker (optional)
alias d="docker"
alias dc="docker-compose"

# Others
alias gh='history|grep'
alias ve='python -m venv ./venv'
alias va='source ./venv/bin/activate'
alias cpv='rsync -ah --info=progress2'
alias hosts='sudo vim /etc/hosts'
alias reslack='pkill slack && slack'
alias gitpullall='echo -e "\n$PWD\n------------------------\n" && git status && git pull'
alias fireth3cookie='(firefox -P th3cookie &> /dev/null &disown)'
alias firework='(firefox -P work &> /dev/null &disown)'
alias ss='sudo ss'
alias systemctl='sudo systemctl'
alias copy='xclip -sel clip'
alias python='python3.8'
alias config='/usr/bin/git --git-dir=/root/.cfg/ --work-tree=/root'
alias updotfiles="cd ~/dotfiles && git status && git pull"

# Only if linux is the main OS
# alias ovpn='sudo openvpn --config ~/work/hostopia.ovpn &'

# Functions to pass through options
function torhost() {
	TOR=$(host ${1} | grep -oP '(?<=vlan).*' | cut -d '.' -f 2-)
	TOR2=${TOR::-1}
	ssh ${TOR2}
}
function hosted() {
	host $1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | xargs host | awk '{print $5}' | bash -ic "xargs whm"
}
function sslchk() {
	${BROWSER} https://www.sslshopper.com/ssl-checker.html#hostname=$1 &
}
function fixpup() {
	echo "Doing puppet manifest checks - Lint and Parser..."; echo "If there is no output below, everything is fine."; echo "-------------------------------------------------"; puppet-lint $1; puppet parser validate $1;
}
function mxtoolbox() {
	${BROWSER} "https://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a${1}&run=toolpage" &
}
function ssa() {
	eval $(ssh-agent -s)
	ssh-add ~/.ssh/id_rsa*
}
function foreman() {
	${BROWSER} "https://puppet02.digitalpacific.com.au/hosts/${1}/edit#params" &
}
function jira() {
	${BROWSER} "https://hostopia-au.atlassian.net/browse/${1}" &
}
function confluence() {
	${BROWSER} "https://hostopia-au.atlassian.net/wiki/search?text=${1}" &
}
function geopeeker() {
	${BROWSER} "https://geopeeker.com/fetch/?url=${1}" &
}
function pagerduty() {
	${BROWSER} "https://digitalpacific.pagerduty.com/incidents/${1}/timeline" &
}
function gitpushall() {
	read -p "Commit Message: " MESSAGE
	echo -e "\n$PWD\n------------------------\n"
	git status
	git add .
	git commit -m "auto commit from $(hostname) - ${MESSAGE}"
	git push origin
}
# Change dir and ls
function cl() {
	DIR="$*";
	# if no DIR given, go home
	if [ $# -lt 1 ]; then
		DIR=$HOME;
	fi;
	builtin cd "${DIR}" && \
	# use your preferred ls command
	ls -F --color=auto
}
# Find git dir based on search term and cd into it (only usable with my dir structure i.e. ~/git/(personal|work)/repos etc.)
function gotogit() {
	SEARCHTERM=${1}
	FOUNDDIR=$(find ~/git -maxdepth 2 -type d -name "*${SEARCHTERM}*")
	[[ $(echo "${FOUNDDIR}" | wc -l) -eq 1 ]] && cd ${FOUNDDIR}
}
