eval $(../../../testenv/testenv.sh alias)
echo -e "\a\033[0;31mThis is the right interface\n"
t enter -n right
ifconfig
