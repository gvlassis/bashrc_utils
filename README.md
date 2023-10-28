# bashrc_utils

## Description
A pair of scripts that provide two shell functions, print_cmd_info() and print_info().

print_cmd_info() returns information for the command that was just run, and is meant to be used with blehook POSTEXEC.

![print_cmd_info](https://github.com/gvlassis/bashrc_utils/assets/74119653/050b4e34-9c37-4296-a89d-42ae90482428)


print_info() returns information about the initialization of Bash, as well as weather and IP information. print_info() is meant to be run near the end of .bashrc.

![print_info](https://github.com/gvlassis/bashrc_utils/assets/74119653/4584915c-9594-42e2-b5cb-2aacdb55aa2f)

The scripts were meant to be used in my personal .bashrc.

## TODO
\-

## Installation
GET.py requires requests.

utils.sh assumes the use of [ble.sh](https://github.com/akinomyoga/ble.sh), [git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh) and that load_duration_ms is set.

## Architecture
There are two source files, GET.py and utils.sh.

GET.py uses [ip-api](https://ip-api.com/) and its geolocation service to find the public IP and the location. If ip-api.com can be reached, [Open-Meteo](https://open-meteo.com/) is used to get the weather in the location (by using longitude and latitude). For both requests, the timeout is set to 1s. The script returns the \n separated list: city, public IP, temperature, precipitation.

utils.sh contains three functions, ms_to_human_friendly(), print_cmd_info() and print_info(). ms_to_human_friendly() converts measurements in ms to a human friendly format (e.g. minutes, hours). print_cmd_info() shows the duration and exit code of the last command, as well as the current user, hostname and working directory. Lastly, print_info() uses GET.py to show the initialization duration, the public IP, the city, the temperature and the precipitation. It also shows the current user, hostname and working directory.
