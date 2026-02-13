
GO_P1 = cd p1

all: up

up:
	${GO_P1} && vagrant up --provider=libvirt

up-debug:
	${GO_P1} && vagrant up --provider=libvirt --debug

stop:
	${GO_P1} && vagrant halt
	${GO_P1} && vagrant destroy

clean:
	${GO_P1} && vagrant destroy -f || true 
	${GO_P1} && rm -rf .vagrant

re: clean all

st:
	${GO_P1} && vagrant status

ssh-1:
	${GO_P1} && vagrant ssh server

ssh-2:
	${GO_P1} && vagrant ssh worker
