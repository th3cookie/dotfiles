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
        firefox https://www.sslshopper.com/ssl-checker.html#hostname=$1 &
}
function fixpup() {
    echo "Doing puppet manifest checks - Lint and Parser..."; echo "If there is no output below, everything is fine."; echo "-------------------------------------------------"; puppet-lint $1; puppet parser validate $1;
}
function mxtoolbox() {
        wslview "https://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a${1}&run=toolpage" &
}
function ssa() {
        eval $(ssh-agent -s)
        ssh-add ~/.ssh/id_rsa*
}
function foreman() {
        wslview "https://puppet02.digitalpacific.com.au/hosts/${1}/edit#params" &
}
function jira() {
        wslview "https://hostopia-au.atlassian.net/browse/${1}" &
}
function geopeeker() {
        wslview "https://geopeeker.com/fetch/?url=${1}" &
}
function pagerduty() {
        wslview "https://digitalpacific.pagerduty.com/incidents/${1}/timeline" &
}

# Aliases
alias pulldev='ssh -tq puppet02 "bash -ic pulldev"'
alias pullstaging='ssh -tq puppet02 "bash -ic pullstaging"'
alias hosts='sudo vim /etc/hosts'
alias reslack='pkill slack && slack'
alias gitpushall='echo -e "\n$PWD\n------------------------\n" && git status && git add . && git commit -m "auto commit from $(hostname)" && git push origin'
alias gitpullall='echo -e "\n$PWD\n------------------------\n" && git status && git pull'
#alias traceroute='sudo traceroute -I'
alias fireth3cookie='(firefox -P th3cookie &> /dev/null &disown)'
alias firework='(firefox -P work &> /dev/null &disown)'
alias ss='sudo ss'
alias systemctl='sudo systemctl'
alias copy='xclip -sel clip'
alias spotify='spotify &'
alias python='python3.8'
alias config='/usr/bin/git --git-dir=/root/.cfg/ --work-tree=/root'

# Only if linux is the main OS
# alias ovpn='sudo openvpn --config ~/work/hostopia.ovpn &'