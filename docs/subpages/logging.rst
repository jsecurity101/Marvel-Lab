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

-  `Sysmon v11.0`_

   -  Configuration is being pulled from this `Github Gist`_
   -  Configuration file changes on a constant basis to help reduce
      noise.

-  `Zeek`_

   -  Logs are stored within the Marvel-Lab directory you created under:
      ``Marvel-Lab/Logging/splunk/zeek/zeek-logs``

-  `OSQuery`_ (Currently not fully opperational)

Analytic Platforms:
###################

-  Splunk

   -  We recommend getting the Developer License Splunk offers and
      applying it within this lab due to the robustness of logs being
      collected.

-  Jupyter Notebooks

Current data sources being shipped to Splunk:
#############################################

-  Windows Events (Window Event Logs (Application, Security, System,
   Setup)
-  Sysmon
-  Zeek

.. _Sysmon v11.0: https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
.. _Github Gist: https://gist.github.com/jsecurity101/77fbb4d01887af8700b256a612094fe2
.. _Zeek: https://zeek.org/
.. _OSQuery: https://osquery.readthedocs.io/en/latest/