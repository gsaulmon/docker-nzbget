FROM fedora

RUN dnf update -y \
	&& dnf install -y wget tar \
	&& dnf clean all \
	&& wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O nzbget-latest-bin-linux.run \
	&& chmod +x nzbget-latest-bin-linux.run \
	&& ./nzbget-latest-bin-linux.run \
	&& rm nzbget-latest-bin-linux.run \
	&& sed -i '/ControlPassword=/c\ControlPassword=' /nzbget/nzbget.conf \
	&& mkdir -p /opt/config/nzbget \
	&& cp /nzbget/nzbget.conf /opt/config/nzbget/

VOLUME /opt/config
VOLUME /opt/data

EXPOSE 6789

ENTRYPOINT ["/nzbget/nzbget", "-s", "-c", "/opt/config/nzbget/nzbget.conf", "-o", "OutputMode=log"]
