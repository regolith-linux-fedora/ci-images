Name:           regolith-ci-hello
Version:        1.0
Release:        1%{?dist}
Summary:        Small test package for the build images
License:        MIT
URL:            https://github.com/regolith-linux-fedora/ci-images
BuildArch:      noarch

%description
A small test package. Building it shows that the image can build packages.

%prep

%build

%install
mkdir -p %{buildroot}%{_datadir}/%{name}
echo hello > %{buildroot}%{_datadir}/%{name}/hello

%files
%{_datadir}/%{name}/

%changelog
* Wed Oct 07 2026 Regolith Fedora port <bot@regolith-desktop.com> - 1.0-1
- First version
