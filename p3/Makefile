
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

all: install create build 

install:
	$(call msg, $(GREEN),Installing requirement)
	bash scripts/install.sh

create:
	$(call msg, $(GREEN),Building project)
	k3d cluster create inception-of-things -p 8080:80@loadbalancer
	k3d kubeconfig get inception-of-things > config/config

build: config-common config-app config-argocd 

config-common:
	$(call msg, $(GREEN),Building default cluster)
	bash scripts/common.sh

config-argocd:
	$(call msg, $(GREEN),Building argoCD)
	bash scripts/argocd.sh

config-app:
	$(call msg, $(GREEN),Building app)
	bash scripts/app.sh

get-ns:
	kubectl get namespace

get-argocd:
	kubectl get all -n argocd
	kubectl get ingress -n argocd

get-config:
	k3d kubeconfig get inception-of-things > ~/.kube/config

get-argocd-pwd:
	@printf	"Admin password: \n"
	@kubectl -n argocd get secret argocd-initial-admin-secret \
		-o jsonpath="{.data.password}" | base64 -d; echo

clean:
	$(call msg, $(RED),Deleting cluster)
	k3d cluster delete inception-of-things
	rm config/config

re: clean all

start:
	k3d cluster start inception-of-things

stop:
	k3d cluster stop inception-of-things

curl-argocd:
	curl -H "Host: argocd.local" http://localhost:8080

git:
	git add .
	git commit -m "$(m)"
	git push

help:
	@printf "================= HELP =================\n\n"

	@printf "Main commands:\n"
	@printf "  %-15s %s\n" "all"            "Run full setup"
	@printf "  %-15s %s\n" "install"        "Install requirements"
	@printf "  %-15s %s\n" "create"         "Create k3d cluster"
	@printf "  %-15s %s\n\n" "build"          "Configure cluster"

	@printf "Configuration:\n"
	@printf "  %-15s %s\n" "config-common"  "Configure default components"
	@printf "  %-15s %s\n" "config-argocd" "Configure ArgoCD"
	@printf "  %-15s %s\n\n" "config-app"    "Deploy application"

	@printf "Utilities:\n"
	@printf "  %-15s %s\n" "get-ns"         "List namespaces"
	@printf "  %-15s %s\n" "get-argocd"    "Get ArgoCD resources"
	@printf "  %-15s %s\n" "get-config"    "Export kubeconfig"
	@printf "  %-15s %s\n\n" "get-argocd-pwd"  "Get ArgoCD admin password"

	@printf "Cluster control:\n"
	@printf "  %-15s %s\n" "start"          "Start cluster"
	@printf "  %-15s %s\n" "stop"           "Stop cluster"
	@printf "  %-15s %s\n" "clean"          "Delete cluster and config"
	@printf "  %-15s %s\n\n" "re"             "Recreate cluster"

	@printf "Testing:\n"
	@printf "  %-15s %s\n\n" "curl-argocd"   "Test ArgoCD ingress"

	@printf "========================================\n"

.PHONY: all \
		help \
		install \
		create \
		build \
		config-common \
		config-argocd \
		config-app \
		get-ns \
		get-argocd \
		get-config \
		get-argocd-pwd \
		clean \
		re \
		start \
		stop \
		curl-argocd
