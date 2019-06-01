FROM centos:7

#RUN echo "[local-base]" > /etc/yum.repos.d/local.repo && \
#        echo "name=Local-Base" >> /etc/yum.repos.d/local.repo && \
#        echo "baseurl=file:///opt/repos/CentOS/7/" >> /etc/yum.repos.d/local.repo && \
#       echo "enabled=1" >> /etc/yum.repos.d/local.repo && \
#       echo "gpgcheck=0" >> /etc/yum.repos.d/local.repo && \
#       mkdir -p /opt/repos/CentOS/7/
#        #yum install --disablerepo=* --enablerepo=local-base wget -y

        #install packages we need
RUN	      yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils epel-release gcc
        #download and unpack source rpm
RUN cd /opt/ && \
	yumdownloader --source wget && \
    rpm -i wget-1.14-18.el7_6.1.src.rpm
        #install dependancies based on spec file and build rpm
RUN cd /root/ && \
    yum-builddep /root/rpmbuild/SPECS/wget.spec -y
RUN rpmbuild -bb /root/rpmbuild/SPECS/wget.spec

        #creating repo
RUN mkdir -p /opt/repos/CentOS/7/ && \
    createrepo /opt/repos/CentOS/7/ && \
        echo "[local-base]" > /etc/yum.repos.d/local.repo && \
        echo "name=Local-Base" >> /etc/yum.repos.d/local.repo && \
        echo "baseurl=file:///opt/repos/CentOS/7/" >> /etc/yum.repos.d/local.repo && \
        echo "enabled=1" >> /etc/yum.repos.d/local.repo && \
        echo "gpgcheck=0" >> /etc/yum.repos.d/local.repo && \
        mv /root/rpmbuild/RPMS/x86_64/wget-1.14-18.el7.1.x86_64.rpm /opt/repos/CentOS/7/wget-1.14-18.el7.1.x86_64.rpm && \
        createrepo /opt/repos/CentOS/7/
        #install wget from local-base repo
        #yum install --disablerepo=* --enablerepo=local-base wget -y

CMD ["wget", "otus.ru"]





