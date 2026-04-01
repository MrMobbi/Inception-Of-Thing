
all: create

create:
	k3d cluster create inception-of-things
	k3d kubeconfig get inception-of-things > config/config


get-config:
	k3d kubeconfig get inception-of-things > ~/.kube/config

destroy:
	k3d cluster delete inception-of-things
	rm config/config

re: destroy create

.PHONY: create get-config 
