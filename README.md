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


### GPU Optimizations

Ensure you have correct and latest NVIDIA Drivers installed (proprietary drivers from NVIDIA is recommend, as of writing (2026) they work the best compared to noveau driver)


```bash
sudo prime-select on-demand
```

After executing the command reboot the system, then run 

```bash
nvidia-smi
```

If the output shows no process are running when idle. Then you are done.

---

#### OS Specific Program

If you are also using Xubuntu, you would observe that there is a process called `Xorg` in the output of `nvidia-smi`, which is keeping the Nvidia GPU awake

Create a file called 99-disable-nvidia.conf in the directory /usr/share/X11/xorg.conf.d/

```bash
cd /usr/share/X11/xorg.conf.d/
sudo nano 99-disable-nvidia.conf
```

```xorg
Section "ServerFlags"
    Option "AutoAddGPU" "off"
EndSection
```

Press Ctrl+O then Ctrl+X

Reboot your computer

Now run `nvidia-smi` again, the `Xorg` process should be gone now.

If you want to know more about why this works, read up on **Xorg Documentation**


**Disclaimer: This setting could mess up with external monitor setups, so please move ahead with caution**

## Disclaimer

Please note that these optimizations are what worked for my specific hardware and software configuration; they may not yield the same results for every system. This guide is provided "as is," and I will not be offering any further updates, fixes, or technical support. Please proceed with caution.