*******************
Telemetry/Logging Information
*******************

.. image:: ../images/tonystark.gif
   :align: center
   :alt: tonystark

Data Sensors Available:
#######################

-  Window Event Logs (Application, Security, System, Setup)

   -  Security events are being configured/audited via GPO.

-  `Sysmon`_

   -  Configuration is being pulled from Olaf Hartong's `sysmon-modular`_ project

-  `Zeek`_

   -  Logs are stored within the Marvel-Lab directory you created under:
      ``Marvel-Lab/Logging/splunk/zeek/zeek-logs``

Analytic Platforms:
###################

-  ELK
   - Zeek is currently unsupported with ELK
   
-  Splunk

   -  We recommend getting the Developer License Splunk offers and
      applying it within this lab due to the robustness of logs being
      collected.

-  Jupyter Notebooks

Current data sources being shipped to Splunk:
#############################################

-  Windows Events (Window Event Logs (Application, Security, System, Setup) (Windows Workstations))
-  Sysmon (Windows Workstations) 
-  Zeek

.. _Sysmon: https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
.. _sysmon-modular: https://github.com/olafhartong/sysmon-modular
.. _Zeek: https://zeek.org/

Splunk Universal Forwarder:
#############################################

The Forwarder currently has some exclusions set within the `inputs.conf`. These can be found below: 

Event ID 4688: 
::

   blacklist1=EventCode="4688" Message="New Process Name:\s*(?i)(?:[C-F]:\\Program Files\\Splunk(?:UniversalForwarder)?\\bin\\(?:btool|splunkd|splunk|splunk\-(?:MonitorNoHandle|admon|netmon|perfmon|powershell|regmon|winevtlog|winhostinfo|winprintmon|wmi|optimize))\.exe)"

Rule was borrowed from: https://gist.github.com/automine/a3915d5238e2967c8d44b0ebcfb66147

Event ID 4689:
::

   blacklist2=EventCode="4689" Message="Process Name:\s*(?i)(?:[C-F]:\\Program Files\\Splunk(?:UniversalForwarder)?\\bin\\(?:btool|splunkd|splunk|splunk\-(?:MonitorNoHandle|admon|netmon|perfmon|powershell|regmon|winevtlog|winhostinfo|winprintmon|wmi|optimize))\.exe)"

Rule was borrowed from: https://gist.github.com/automine/a3915d5238e2967c8d44b0ebcfb66147

Event ID 5156: 
::

   blacklist3=EventCode="5156"  Message="(?ms)Application\sName:\s.*\\windows\\system32\\svchost.exe."

