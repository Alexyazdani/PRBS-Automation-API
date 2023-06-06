Alex Yazdani 2023

PRBS-Automation-API
Example API to be used with Cisco Guest Shell to work with Automation.

First few setup lines:
enable shell commands, enable PRBS, disable logging to not interfere with expected responses, disable exec timeout, instantiate error count and initial timestamp variables.

Functions:

1. SerPortEnabledState()
  Enable or disable desired port, optional arguement to set port speed for dual rate optics
  
2. SetVoltageMargin()
  Margin the voltage.
  
3. SetPRBSPattern()
  Start generating PRBS and continue to generate until lock status is validated

4. StartPRBSStatistics()
  Start measuring statistics: set error count to 0 and initialize timestamp.

5. GetPRBSStatistics()
  Fetch BER statistics, ie, error counts, timestamps, and lock status.  output in a stout format.

6. GetDomPower()
  Fetch the power from the Digital Optical Monitor
