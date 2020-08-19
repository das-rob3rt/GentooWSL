FROM gentoo/portage AS portage
FROM gentoo/stage3-amd64
ENV GENTOO_MIRRORS https://mirrors.cloud.tencent.com/gentoo

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo
RUN emerge app-portage/mirrorselect app-portage/gentoolkit app-admin/sudo app-editors/vim && \
eclean -d packages && eclean -d distfiles

WORKDIR /root
COPY ./post-install.sh /root/post-install.sh
RUN cp /etc/skel/.bash* . && cp .bashrc .bashrc~ && echo "source post-install.sh" >> .bashrc
