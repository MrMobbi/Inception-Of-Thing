
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

all: create

create:
	$(call msg, $(GREEN),Building project)
	k3d cluster create inception-of-things -p 8080:80@loadbalancer
	k3d kubeconfig get inception-of-things > config/config
	@$(MAKE) install

install:
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
	kubectl -n argocd get secret argocd-initial-admin-secret \
		-o jsonpath="{.data.password}" | base64 -d; echo

clean:
	$(call msg, $(RED),Deleting cluster)
	k3d cluster delete inception-of-things
	rm config/config

re: clean create


.PHONY: create \
		get-ns \
		get-argocd \
		get-config \
		clean \
		re
