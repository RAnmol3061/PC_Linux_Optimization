# PC_Linux_Optimization

These are the tweaks I made to my system to increase battery life of my laptop

Laptop Specifications: HP Victus 15-fb3162AX
CPU: Ryzen 7 7445HS APU
GPU: RTX 4050 6GB (50W TDP)

OS Specification

Ubuntu 25.04


to install auto-cpufreq, 
first clone the official auto-cpufreq repository

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq

then run the script provided inside the repo to install auto-cpufreq

sudo ./auto-cpufreq-installer
press "i" when asked to install the auto-cpufreq daemon(service) to work in background and start automatically at startup

to check if it working

auto-cpufreq --monitor


## GPU Optimizations

First ensure you have correct NVIDIA Drivers installed (proprietary drivers from NVIDIA is recommend, as of writing(2026) they work the best compared to noveau driver)

After driver is installed, run

sudo prime-select on-demand

After executing the command reboot the system, then run 

nvidia-smi

if it shows no process running, then you are done

But for me the fun part starts from here, I was facing a problem were the gpu was running a process called Xorg, which was only using 4mb of vram, even though my display was being rendered by
my integrated graphics(Radeon)





