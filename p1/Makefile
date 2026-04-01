

up:
	vagrant up --provider=libvirt

provision:
	vagrant provision

prov-server:
	vagrant provision server

prov-worker:
	vagrant provider worker

rl:
	vagrant reload

rl-prov:
	vagrant reload --provision

halt:
	vagrant halt

clean:
	vagrant destroy -f

re: rl provision

rre: destroy up

st:
	vagrant status

ssh-server:
	vagrant ssh-server

ssh-worker:
	vagrant ssh-worker

logs-server:
	vagrant ssh-server -c "sudo journalctl -u k3s -f"

logs-worker:
	vagrant ssh-worker -c "sudo journalctl -u k3s -f"

.PHONY: up \
		provision \
		reload \
		halt \
		destroy \
		clean \
		re \
		rre \
		st \
        ssh-server \
		ssh-worker \
		logs-server \
		logs-worker
