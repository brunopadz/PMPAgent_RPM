Name:	pmpagent		
Version:	1
Release:	0
Summary:	PMPAgent for Linux Servers

Group:		HDI
License:	GPL
URL:		https://www.hdi.com.br
Source0:	pmpagent-1.0.tar.gz
BuildArch:	x86_64
BuildRoot:	%{_tmppath}/%{name}-buildroot
%description
PMPAgent for Linux Servers

%prep
%setup -n pmpagent-1.0

%build
%install
install -m 0777 -d $RPM_BUILD_ROOT/opt/pmpagent
install -m 0777 Agent.conf $RPM_BUILD_ROOT/opt/pmpagent/Agent.conf
install -m 0777 installAgent-service.sh $RPM_BUILD_ROOT/opt/pmpagent/installAgent-service.sh
install -m 0777 PMPAgent $RPM_BUILD_ROOT/opt/pmpagent/PMPAgent
install -m 0777 pmpagent-service $RPM_BUILD_ROOT/opt/pmpagent/pmpagent-service
install -m 0777 ServerCer.cer $RPM_BUILD_ROOT/opt/pmpagent/ServerCer.cer

%clean
rm -rf $RPM_BUILD_ROOT

%files
%dir /opt/pmpagent
/opt/pmpagent/Agent.conf
/opt/pmpagent/PMPAgent
/opt/pmpagent/pmpagent-service
/opt/pmpagent/ServerCer.cer
/opt/pmpagent/installAgent-service.sh

%post
cd /opt/pmpagent/
./installAgent-service.sh install

