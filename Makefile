###############################################################################
###                              Port forward                              ###
###############################################################################

.PHONY: port-forward
port-forward:
	kubectl port-forward pods/osmosis-genesis-0 26653:26657 &
	kubectl port-forward pods/wasmd-genesis-0 26659:26657 &

.PHONY: stop-forward
stop-forward:
	-pkill -f "port-forward"

.PHONY: check-forward
check-forward:
	while true ; do nc -vz 127.0.0.1 26653 && nc -vz 127.0.0.1 26659 ; sleep 10 ; done

clean: stop-forward

###############################################################################
###                              Local Setup                                ###
###############################################################################

KIND_CLUSTER=kubeshuttle

install-kind:
ifeq ($(shell uname -s), Linux)
	curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
	chmod +x ./kind
	sudo mv ./kind /usr/local/bin/kind
else
	brew install kind
endif

kind_check := $(shell command -v kind 2> /dev/null)
setup-kind:
ifndef kind_check
	echo "No kind in $(PATH), installing kind..."
	$(MAKE) install-kind
endif
	echo "kind already insteall.. setting up kind cluster"
	kind create cluster --name $(KIND_CLUSTER)

install-kubectl:
ifeq ($(shell uname -s), Linux)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
else
	brew install kubectl
endif

kubectl_check := $(shell command -v kubectl 2> /dev/null)
setup-kubectl:
ifndef kubectl_check
	$(MAKE) install-kubectl
endif
	echo "kubectl already installed"

setup: setup-kubectl setup-kind

clean-kind:
	kind delete cluster

clean: clean-kind
	-@rm ./kind ./kubectl 2> /dev/null

###############################################################################
###                              Install Charts                             ###
###############################################################################
CHART_REPO = https://github.com/Anmol1696/kubeshuttle

install-chart:
	helm repo add stable $(CHART_REPO)
	helm repo update
	helm pull stable/devnet --untar
