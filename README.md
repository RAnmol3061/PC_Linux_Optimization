# Battery Optimizations 

These are the tweaks I made to my system to increase battery life of my laptop.

## Laptop Specifications: 
- Model No: HP Victus 15-fb3162AX
- CPU: Ryzen 7 7445HS APU
- GPU: RTX 4050 6GB (50W TDP)
- Operating System: Xubuntu 25.04 and 25.10

---------------

### CPU Optimization: auto-cpufreq

Clone official github repository of auto-cpufreq

```bash
 git clone https://github.com/AdnanHodzic/auto-cpufreq.git
```
Change directory into auto-cpufreq

``` bash
cd auto-cpufreq

sudo ./auto-cpufreq-installer
```

Proceed as guided by the installer

To check if it is working

```bash
auto-cpufreq --status
```

To get most up to date information about **auto-cpufreq** please visit their *official github* repository. They have extremely detailed documentation on how to install and use auto-cpufreq. So if you have any questions regarding installation, how this software helps increase battery or how it works under the hood please visit their repository.


## GPU Optimizations

First ensure you have correct NVIDIA Drivers installed (proprietary drivers from NVIDIA is recommend, as of writing(2026) they work the best compared to noveau driver)

After driver is installed, run

sudo prime-select on-demand

After executing the command reboot the system, then run 

nvidia-smi

if it shows no process running, then you are done

But for me the fun part starts from here, I was facing a problem were the gpu was running a process called Xorg, which was only using 4mb of vram, even though my display was being rendered by
my integrated graphics(Radeon)

it was 0000:01:00.0 for me, check your id from nvidia-smi command

cat /proc/driver/nvidia/gpus/0000:01:00.0/power 



To check power draw, in my current configration after all the optimization and at lowest brightness, I am discharing 6W	
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage|energy-rate"

to fix the xorg issue, I downloaded envycontrol

Download the latest .deb file from their official github
https://github.com/bayasdev/envycontrol

and install using

sudo apt install ./(file name)      please make sure that the .deb file is legitimate, before using superuser privilege(sudo) to install the file


This command tells the pc to use integrated graphics for light tasks and use nvidia for heavy tasks or if you specifically offload the task to them
sudo envycontrol -s hybrid --rtd3


After running the command reboot the pc
run nvidia-smi

if xorg process is stilling running then do this changes below( as these changes didn't help me too)


create a file called 99-disable-nvidia.conf

run 
cd cd /usr/share/X11/xorg.conf.d/
sudo nano 99-disable-nvidia.conf

inside the file write:

Section "ServerFlags"
    Option "AutoAddGPU" "off"
EndSection

Press Ctrl+O then Ctrl+X


Reboot the pc

Now run 
cat /sys/bus/pci/devices/0000:01:00.0/power_state 

if it says D3Cold, you are golden

for peace of mind, run

cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status

it the output says "suspended" then it is working