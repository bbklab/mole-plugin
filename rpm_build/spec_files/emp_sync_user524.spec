Summary: 	sync user changes from eyoumailv5/8 to eyoumailv4
Name: 		emp_sync_user524
Version: 	1.0
Release: 	p2
License: 	GPLv3
Group:  	Extension
Packager: 	Zhang Guangzheng <zhang.elinks@gmail.com>
BuildRoot: 	/var/tmp/%{name}-%{version}-%{release}-root
Source0: 	emp_sync_user524-1.0-p2.tgz
Requires:	mole >= 1.0
Requires:	glibc-common >= 2.5, nc >= 1.84
Requires:	gawk >= 3.1.5

%description 
eyou plugins for mole:
sync user changes from eyoumail5/8 to eyoumailv4

%prep
%setup -q

%build

%install 
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
mkdir -p $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/plugin/
mkdir -p $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/conf/
mkdir -p $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/docs/{en,cn}/
mkdir -p $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/handler/
mkdir -p $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/opt/
p="emp_sync_user524"
cp -a ${p}/${p}          $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/plugin/
cp -a ${p}/conf/${p}.ini $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/conf/
[ -f "${p}/docs/en/readme" ] && cp -a ${p}/docs/en/readme $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/docs/en/${p}.readme
[ -f "${p}/docs/zh/readme" ] && cp -a ${p}/docs/zh/readme $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/docs/zh/${p}.readme
cp -a ${p}/handler/      $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/
cp -a ${p}/opt/          $RPM_BUILD_ROOT/usr/local/esoo/agent/mole/

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/local/esoo/agent/mole/plugin/
/usr/local/esoo/agent/mole/conf/
/usr/local/esoo/agent/mole/docs/
/usr/local/esoo/agent/mole/handler/
/usr/local/esoo/agent/mole/opt/

%post

%preun

%postun

%changelog
* Thu Nov  7 2013 Guangzheng Zhang <zhang.elinks@gmail.com>
- first buildrpm for 1.0 release
