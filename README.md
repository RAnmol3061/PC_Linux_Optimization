# PC_Linux_Optimization


to install auto-cpufreq, 
first clone the official auto-cpufreq repository

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq

then run the script provided inside the repo to install auto-cpufreq

sudo ./auto-cpufreq-installer
press "i" when asked to install the auto-cpufreq daemon(service) to work in background and start automatically at startup

to check if it working

auto-cpufreq --monitor