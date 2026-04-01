

up:
	vagrant up --provider=libvirt

provision:
	vagrant provision

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

ssh:
	vagrant ssh-server

logs:
	vagrant ssh-server -c "sudo journalctl -u k3s -f"


.PHONY: up \
		provision \
		reload \
		halt \
		destroy \
		clean \
		re \
		rre \
		st \
        ssh \
		logs
