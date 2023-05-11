forward_80_on_mac:
	sudo ncat -l -p 80 -c "ncat -l -p ${PORT}"

minica:
	# brew install minica
	minica --domains localhost

https:
	# npm install -g local-ssl-proxy
	local-ssl-proxy --source 8080 --target 3000
