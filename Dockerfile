FROM quay.io/centos7/s2i-core-centos7

EXPOSE 8080

ENV RUBY_SCL="rh-ruby27" \
    PATH="/opt/rh/rh-ruby27/root/usr/local/bin:/opt/rh/rh-ruby27/root/usr/bin:/opt/app-root/src/bin:/opt/app-root/bin:/opt/app-root:$PATH" \
    LD_LIBRARY_PATH="/opt/rh/rh-ruby27/root/usr/local/lib64:/opt/rh/rh-ruby27/root/usr/lib64" \
    X_SCLS="rh-ruby27" \
    MANPATH="/opt/rh/rh-ruby27/root/usr/local/share/man:/opt/rh/rh-ruby27/root/usr/share/man:" \
    XDG_DATA_DIRS="/opt/rh/rh-ruby27/root/usr/local/share:/opt/rh/rh-ruby27/root/usr/share:/usr/local/share:/usr/share" \
    PKG_CONFIG_PATH="/opt/rh/rh-ruby27/root/usr/local/lib64/pkgconfig:/opt/rh/rh-ruby27/root/usr/lib64/pkgconfig" \
    INSTALL_PKGS="autoconf automake gcc-c++ make git libcurl-devel openssl-devel wget libffi-devel rh-ruby27 rh-ruby27-ruby-devel \
                  rh-ruby27-rubygem-rake rh-ruby27-rubygem-bundler gettext hostname nss_wrapper bind-utils httpd24 \
                  httpd24-mod_ssl httpd24-mod_ldap httpd24-mod_session httpd24-mod_auth_mellon httpd24-mod_security openssl" \
    HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ \
    HTTPD_APP_ROOT=/opt/app-root \
    HTTPD_CONFIGURATION_PATH=/opt/app-root/etc/httpd.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_TLS_CERT_PATH=/etc/httpd/tls \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/opt/rh/httpd24/root/var/www \
    HTTPD_LOG_PATH=/var/log/httpd24 \
    HTTPD_SCL=httpd24 \
    LANG="en_US.UTF-8" \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    HOME=/opt/app-root/src \
    PLATFORM="el7" \
    BASH_ENV=/opt/app-root/scl_enable \
    ENV=/opt/app-root/scl_enable \
    PROMPT_COMMAND=". /opt/app-root/scl_enable"

LABEL io.openshift.expose-services="8080:http"

# Copy extra files to the image.
COPY ./.s2i/bin/ $STI_SCRIPTS_PATH
COPY ./root/ /

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
  yum install -y centos-release-scl epel-release && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  gem install ascii_binder && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*' && \
  /usr/libexec/httpd-prepare && \
  rpm-file-permissions && \
  mkdir -p ${HOME}/.pki/nssdb && \
  mkdir -p /opt/app-root/bin && \
  wget https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_amd64 -O /opt/app-root/bin/yq &&\
  chmod +x /opt/app-root/bin/yq && \
  chown -R 1001:0 ${APP_ROOT} && \
  chmod -R ug+rwx ${APP_ROOT}

# Directory with all the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

USER 1001

CMD ["/usr/bin/run-httpd"]
