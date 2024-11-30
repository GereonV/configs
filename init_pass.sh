#!/usr/bin/env bash
dir=${PASSWORD_STORE_DIR:-~/.password-store}
if ! type git &> /dev/null
then
	echo "couldn't find git" >&2
	exit 1
elif ! type gpg &> /dev/null
then
	echo "couldn't find gpg" >&2
	exit 1
elif [[ -a ${dir} ]]
then
	echo "store '${dir}' already exists" >&2
	exit 1
fi

git clone git@github.com:GereonV/password-store.git "${dir}" ||
git clone git@gitlab.com:gereon36/password-store.git "${dir}" ||
{ echo "couldn't clone repo" >&2; exit 1; }
cd "${dir}" || exit
pubs=$(git cat-file blob pubs) || exit
gpg --import <<< "${pubs}" || exit
cat >> .git/config << "EOF"
[diff "gpg"]
	textconv = gpg --quiet --decrypt
EOF
echo
echo "for security reasons you should verify the imported keys manually"
echo "use 'gpg --fingerprint [name]' to get the fingerprint"
echo "issue 'gpg --quick-lsign-key \"<fingerprint>\"' to sign locally"
echo
echo "please install the pass program yourself!"
