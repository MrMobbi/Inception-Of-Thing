
all: create

create:
	k3d cluster create inception-of-things
	k3d kubeconfig get inception-of-things > config/config
	kubectl create namespace argocd
	kubectl create namespace dev

get-ns:
	kubectl get namespace

get-config:
	k3d kubeconfig get inception-of-things > ~/.kube/config

clean:
	k3d cluster delete inception-of-things
	rm config/config

re: clean create

.PHONY: create \
		get-ns \
		get-config \
		clean \
		re
