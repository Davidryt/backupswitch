eval $(../../../testenv/testenv.sh alias)
echo -e "\a\033[0;32mThis is the left interface\n"
t enter -n right
ifconfig
