# 3rd Party API Data Collector (powered by WoofAPI)
## Requirements
- Python
    - requests
    - dataclasses

### Files:
- 📄 main.py: main driver of the API Scrapper
- 📄 models.py: shape of data to be sent to the API
- 📄 woof_API.py: calls to WoofAPI in order to interact with the data
- 📄 yelp_API.py: call to Yelps API in order to collect data and send it to the WoofAPI

# How to use

## How to run
```
cd API
go run main.go
```
or with test database
```
cd API
go run main.go -t test
```
in a separate terminal under the 3rdParty_API directory:
```
python3 main.py
```