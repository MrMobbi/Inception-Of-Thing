
# Colors
RED    := \033[0;31m
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
RESET  := \033[0m

# Message function
define msg
	@printf	"$(1)#######################\n"
	@printf	"$(2)\n"
	@printf	"#######################$(RESET)\n"
endef

all: install create

create:
	$(call msg, $(GREEN),Building project)
	k3d cluster create inception-of-things -p 8080:80@loadbalancer
	k3d kubeconfig get inception-of-things > config/config
	@$(MAKE)config-argocd

congig-argocd:
	$(call msg, $(GREEN),Configurating cluster)
	bash scripts/cluster_config.sh

get-ns:
	kubectl get namespace

get-argocd:
	kubectl get all -n argocd
	kubectl get ingress -n argocd

get-config:
	k3d kubeconfig get inception-of-things > ~/.kube/config

get-argo-pwd:
	@kubectl -n argocd get secret argocd-initial-admin-secret \
		-o jsonpath="{.data.password}" | base64 -d; echo

clean:
	$(call msg, $(RED),Deleting cluster)
	k3d cluster delete inception-of-things
	rm config/config

re: clean create

start:
	k3d cluster start inception-of-things

stop:
	k3d cluster stop inception-of-things

curl-argocd:
	curl -H "Host: argocd.local" http://localhost:8080


.PHONY: all \
		create \
		config-argocd \
		get-ns \
		get-argocd \
		get-config \
		get-argocd-pwd \
		clean \
		re \
		start \
		stop \
		curl-argocd
