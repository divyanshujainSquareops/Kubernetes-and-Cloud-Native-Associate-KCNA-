# Create veth pair
ip link add
# Attach veth pair
ip link set .....
ip link set ....
# Assign IP Address
ip -n ‹namespace› addr add .....
ip -n ‹namespace> route add ......
# Bring Up Interface
ip -n ‹namespace› link set