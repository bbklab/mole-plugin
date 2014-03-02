Summary: 	event notify on mail deliver fail for eyoumailv5/8
Name: 		emp_notify_deliverfail
Version: 	1.1
Release: 	p1
License: 	GPLv3
Group:  	Extension
Packager: 	Zhang Guangzheng <zhang.elinks@gmail.com>
BuildRoot: 	/var/tmp/%{name}-%{version}-%{release}-root
Source0: 	emp_notify_deliverfail-1.1-p1.tgz
Requires:	mole >= 1.0
Requires:	perl >= 5.8.8

%description 
eyou plugins for mole:
event notify on mail deliver fail for eyoumailv5/8

%prep
%setup -q

%build

%install 
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/plugin/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/conf/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/{en,cn}/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/handler/
mkdir -p $RPM_BUILD_ROOT/usr/local/esop/agent/mole/opt/
p="emp_notify_deliverfail"
cp -a ${p}/${p}          $RPM_BUILD_ROOT/usr/local/esop/agent/mole/plugin/
cp -a ${p}/conf/${p}.ini $RPM_BUILD_ROOT/usr/local/esop/agent/mole/conf/
[ -f "${p}/docs/en/readme" ] && cp -a ${p}/docs/en/readme $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/en/${p}.readme
[ -f "${p}/docs/zh/readme" ] && cp -a ${p}/docs/zh/readme $RPM_BUILD_ROOT/usr/local/esop/agent/mole/docs/zh/${p}.readme 
cp -a ${p}/handler/      $RPM_BUILD_ROOT/usr/local/esop/agent/mole/
cp -a ${p}/opt/          $RPM_BUILD_ROOT/usr/local/esop/agent/mole/

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/local/esop/agent/mole/plugin/
/usr/local/esop/agent/mole/conf/
/usr/local/esop/agent/mole/docs/
/usr/local/esop/agent/mole/handler/
/usr/local/esop/agent/mole/opt/

%post

%preun

%postun

%changelog
* Tue Nov 12 2013 Guangzheng Zhang <zhang.elinks@gmail.com>
- 1.1 release
- bugfix on read attendlst file line
* Thu Nov  7 2013 Guangzheng Zhang <zhang.elinks@gmail.com>
- first buildrpm for 1.0 release
