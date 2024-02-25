Alex Yazdani 2023

PRBS-Automation-API
Example API to be used with Cisco IOS Shell to work with Automation.

First few setup lines:
enable shell commands, enable PRBS, disable logging to not interfere with expected responses, disable exec timeout, instantiate error count and initial timestamp variables.

The first example file applies to a rather simple DUT.  The second example file, PRBS_API_2, shows an example where the DUT being tested has 2 different PHYs, therefore 2 different sets of commands for different ports.  Start, stop, and error check commands were implemented to detect port and decide which command set to use.  There is also example code to pull out error count from registers returning MSB and LSB values.

Functions:

1. SetPortEnabledState() - 
  Enable or disable desired port, optional arguement to set port speed for dual rate optics.
  
2. SetVoltageMargin() - 
  Margin the voltage.
  
3. SetPRBSPattern() - 
  Start generating PRBS and continue to generate until lock status is validated.

4. StartPRBSStatistics() - 
  Start measuring statistics: set error count to 0 and initialize timestamp.

5. GetPRBSStatistics() - 
  Fetch BER statistics, ie, error counts, timestamps, and lock status.  output in a stout format.

6. GetDomPower() - 
  Fetch the power from the Digital Optical Monitor.


Official Documentation of Cisco IOS Shell:
https://www.cisco.com/c/en/us/td/docs/ios/netmgmt/configuration/guide/Convert/IOS_Shell/nm_ios_shell.html
