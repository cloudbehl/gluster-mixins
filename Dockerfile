FROM docker.io/openshift/origin-release:golang-1.10

#install clang and gcc-c++ required for jsonnet to build
RUN yum install -y clang \
    gcc-c++ \
    make

#get required go packages for building k8s objects
RUN go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb \
    github.com/brancz/gojsontoyaml \
    github.com/prometheus/prometheus/cmd/promtool

#building jsonnet
RUN git clone https://github.com/google/jsonnet && \
    git --git-dir=jsonnet/.git checkout v0.10.0 && \
    make -C jsonnet CC=clang CXX=clang++ && \
    cp jsonnet/jsonnet /usr/bin

#install kubectl package in container
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin

#cloning the gluster-mixins project and making gluster-mixins as working dir
COPY . /gluster/gluster-mixins/
WORKDIR /gluster/gluster-mixins/

#run test and generate the intermidiate files
RUN make test \ 
    prometheus_alerts.yaml \
    prometheus_rules.yaml \
    dashboards_out

WORKDIR /gluster/gluster-mixins/extras
#installing required dependency from jsonnetfile.json and building k8s objects
RUN jb install
RUN ./build.sh example.jsonnet

#shell script to apply the k8s object to underlying cluster
COPY docker/entry.sh /
RUN chmod 755 /entry.sh

ENTRYPOINT [ "/entry.sh" ]
