FROM gentoo/portage AS portage
FROM gentoo/stage3-amd64
ENV GENTOO_MIRRORS https://mirrors.cloud.tencent.com/gentoo

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo
RUN emerge -q mirrorselect gentoolkit sudo vim && eclean -dq packages && eclean -dq distfiles

WORKDIR /root
COPY ./post-install.sh /root/post-install.sh
RUN cp -f /etc/skel/.bash* . && cp .bashrc .bashrc~ && \
echo "source /root/post-install.sh" >> .bashrc
