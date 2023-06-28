eval $(../../../testenv/testenv.sh alias)
t setup -n left
t setup -n right
gnome-terminal -- sh -c 'bash -c "echo -e \"\a RIGHT\n\"; exec bash"'
gnome-terminal -- sh -c 'bash -c "echo -e \"\a LEFT\n\"; exec bash"'

