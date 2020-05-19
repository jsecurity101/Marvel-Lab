<img src="https://media.giphy.com/media/AbYxDs20DECQw/giphy.gif" width=900 />

## Data Sensors Available: 
- Window Event Logs (Application, Security, System, Setup)
  - Security events are being configured/audited via GPO. 
- [Sysmon v11.0](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
  - Configuration is being pulled from this [Github Gist](https://gist.github.com/jsecurity101/77fbb4d01887af8700b256a612094fe2)
  - Configuration file changes on a constant basis to help reduce noise. 
- [Zeek](https://zeek.org/)
  - Logs are stored within the Marvel-Lab directory you created under: `Marvel-Lab/Logging/splunk/zeek-logs`
- [OSQuery](https://osquery.readthedocs.io/en/latest/)
  
## Analytic Platforms: 
- Splunk
  - We recommend getting the Developer License Splunk offers and applying it within this lab due to the robustness of logs being collected. 
- Jupyter Notebooks

## Current data sources being shipped to Splunk: 
- Windows Events (Window Event Logs (Application, Security, System, Setup)
- Sysmon
- Zeek 


## To Do: 
- Forward OSQuery logs to Splunk 

  