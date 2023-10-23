import requests
import datetime
import socket

TIMEOUT=1

try:
	ip_api_response = requests.get("http://ip-api.com/json/?fields=city,lat,lon,query", timeout=TIMEOUT)
except requests.exceptions.ConnectionError, :
	print("\x1b[91mip-api.com✖\x1b[0m")
	exit(2)
ip_api_dict = ip_api_response.json()

try:
	open_meteo_response = requests.get("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&hourly=temperature_2m,precipitation_probability&timezone=auto&forecast_days=1&current_weather=true" % (ip_api_dict["lat"], ip_api_dict["lon"]), timeout=TIMEOUT)
except requests.exceptions.ConnectionError:
	print("\x1b[91mopen-meteo.com✖\x1b[0m")
	exit(3)
open_meteo_dict = open_meteo_response.json()

hour = int(datetime.datetime.fromisoformat(open_meteo_dict["current_weather"]["time"]).strftime("%H"))

print("%s" % (ip_api_dict["city"]))
print("%s" % (ip_api_dict["query"]))
print("%.1f" % (open_meteo_dict["hourly"]["temperature_2m"][hour]))
print("%.1f" % (open_meteo_dict["hourly"]["precipitation_probability"][hour]))