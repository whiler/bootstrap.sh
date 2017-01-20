mkdir -p $(dirname ${HOME}/.config/flake8)
cat << EOF > ${HOME}/.config/flake8
[flake8]
max-line-length = 160
EOF
