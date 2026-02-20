
PROJECT_DIR	:= p1
VAGRANT		:= cd $(PROJECT_DIR) && vagrant

up:
	$(VAGRANT) up --provider=libvirt

provision:
	$(VAGRANT) provision

prov-server:
	$(VAGRANT) provision server

prov-worker:
	$(VAGRANT) provision worker

rl:
	$(VAGRANT) reload

rl-provision:
	$(VAGRANT) reload --provision

halt:
	$(VAGRANT) halt

destroy:
	$(VAGRANT) destroy -f

clean: destroy
	@echo "Clean complete."

re: clean up

status:
	$(VAGRANT) status

ssh-server:
	$(VAGRANT) ssh server

ssh-worker:
	$(VAGRANT) ssh worker

logs-server:
	$(VAGRANT) ssh server -c "sudo journalctl -u k3s -f"

logs-worker:
	$(VAGRANT) ssh worker -c "sudo journalctl -u k3s-agent -f"

.PHONY: up provision reload halt destroy clean re status \
        ssh-server ssh-worker logs-server logs-worker
