.PHONY: shipyard

ngrok: 
	@ngrok start --config ngrok.cfg --authtoken $(NGROK_AUTHTOKEN) --all --log=false &

cleanup:
	@pkill ngrok || true
	@shipyard destroy
	@rm cloud.shipyardvars

shipyard:
	@curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.name == "gitlab (http)") | .public_url' | awk '{ print "gitlab_url=\""$$0"\"\ngitlab_host=\""$$0"\""}' > cloud.shipyardvars
	@shipyard run shipyard --vars-file=cloud.shipyardvars
	@shipyard output gitlab

remote:
	@shipyard run shipyard --vars-file=remote.shipyardvars
	@shipyard output gitlab

info:
	@curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.name == "rcon") | .public_url' | sed 's/tcp:\/\///g'
