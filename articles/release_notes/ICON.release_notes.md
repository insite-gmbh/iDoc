# ICON Base Release Notes
|date      |version      | change description |
|----------|-------------|:-------------|
|17.01.2019|v1.0.11|Added spezialised Linq Extensions which are also threadsafe and more performant then the original ones (Fixed Spooler bug). Updated all nuget packages to current version  |
|18.10.2018|v1.0.10|OPC UA Improvements |
|16.03.2018|v1.0.9|Changed .Net Framework to 4.6.1; Added OPC UA Support; Did some source cleanup, IMproved DiagnosisControl performance |
|26.02.2018|v1.0.8|Fixed MemBasedMsgSourceConverter:now we have one instance per Sink/Source because with different plc connections it is possible to have DBs with the same number but different size!! Updated InacS7 version. Added new global config entries ReportMemoryAndHandlesInterval and LogFreeDriveSpace to configure the time and logging of this. Changed some UI texts. Changed some log entries from DEBUG to WARNING or ERROR. Fixed ValidationTime ( if noting was set from plc, also the max validation time of the spooler doesn't work) -> if plc time was 00:00:00 automatically the spooler time will be used. otherwise, the smalles one of the both |
|20.02.2018|v1.0.7| Splitted Ui Slotcache from one per instance to one per page, because with multible connections it is possible to have different DB lenght for the same db number. Added db size cache entry only if read is ok.  Added InacS7 V1.0.14.  |
|11.01.2018|v1.0.6| Optimized Spooler performance (RefreshOnlyIfVisible, Locking, ...) and fixed some Bugs. Improve Socket logging and fixes bugs. Added handling of opc deactivate items exception when ICON is shutting down. |
|03.08.2017|| Added new configuration parameter (SuppressAcknowledge). Allow more the one clients with RFC1006-Server.
|06.04.2017|| Fixed a bug where spooler refresh remains locked, when WorkOnNextMessageFromSpooler throws a exception.
|23.03.2017|| Added locking to PayloadconverterAdapter to avoid the problem when sending more then one message at the same time.  |
|16.03.2017|| Added automatic handling of corrupt spooler files.  |
|16.02.2017|| Created lock free implementation for the slot cache by using concurrent dictionary. Added new Global config value to activate sendslotchages in UI. |
|10.02.2017|| Fixed a bug in BMW01 protocol implementation. (In some messages the byteorder was not correct.) |
|03.01.2017|| Some changes to allow payloadconverter to handle multiple messages at the same time. |
|20.12.2016|| Add GlobalSetting to setup ProcessPriority. |
|07.12.2016|| Moved background task to own thread. |
|21.11.2016|| Small fixes on ForceLastConnection. |
|18.11.2016|| Update InacS7 and add new functionality called ForceLastConnection|
|12.10.2016|| Remove lock in message dispatcher because we get messages from both sides. Update to new InacS7 version.|
|11.10.2016|| Update alarmhandling for PDEM to set the correct alarmcount in all cases.|
|13.09.2016|| change unlocking mechanism of middle module (e.g. Payloadconverter).|
|12.08.2016|| Fixed bug in edit spooler item (JIS Receive).|
|02.08.2016|| add config property AddIdentifierToMirror for JIS Receive, to add the identifier length to the mirror entry length.|
|13.07.2016|| remove locking from Payloadconverter, because of incompatibility to older configurations.|
|21.06.2016|| Fix culture in alamserver interface to de-DE, becuase winccAlarmserver use allways this format.|
|09.06.2016|| add receive puffer to serial module, to handle more than one receive to detect data|
|09.05.2016|| Refactoring, Handling of Socket Send-Timout ....|
|13.04.2016|| Refactoring, Log improving, Array Usage optimization in protocol detector, ....|
|12.04.2016|| Reimplemented singleton timer to use tasks instead of threads, do much resource cleaning to avoid increasing memory with ModuleInstanceManager, update of inacS7 and fix a bug in the InacS7Accessor |
|06.04.2016|| Fixed a bug in Payloadconverter, improve logging, add SocketSendBufferSize as global configuration value|
|30.03.2016|| optimize logging, use dispatcher for EventDistributor, bug fix in ModuleManager|
|25.03.2016|| more locking changes and spooler bit delegation for JIS|
|18.03.2016|| fix message locking after error problem|
|14.03.2016|| optimize logging in ModuleInstanceManager, bug fix LatencyMonitor and SpecialBeginReceiveThread|
|22.02.2016|| bug fix in singleton timer|
|18.02.2016|| add SocketTimeout as global configuration value|
|03.02.2016|| bug fix in repeatMsgs of history spooler|
|21.12.2015|| bug fixes in Slottracker and connection GUI, because of a problem with ModulInstancemanager; integration of INACS7|
|10.12.2015|| update LibNoDave and Snap7 because of bug fixes|
|18.11.2015|| update MsgDispatcher -> NoAck Attribut|
|05.10.2015|| update MsgDispatcher and Socket|
|30.09.2015|| extended Exception-handling for Socket|
|16.09.2015|| on a send slot reset the ack code will now set to 0 |
|15.09.2015|| added mote ReceiveBehavior (EatData and ReadAndReset)|
|18.08.2015|| added socket latency measurement (Globals and Socket) -> beta state|
|13.08.2015|| bug fix if Dns-Resolve is not working (now better cpu usage|
|07.08.2015|| suppress exception of splash screen|
|21.07.2015|| on msg retry we now reset the $$Created$$ attribute, to avoid stop processing by msg delay time |
|16.07.2015|| bug fix when you use server socket with more the one clients |
|10.07.2015|| created new module MessageDispatcher -> beta version|
|03.07.2015|| raise Icon to .Net40, remove old RFC1006 implementation |
|01.06.2015|| change socket close if receive buffer will not processed|
|26.05.2015|| add log entries for JISSendImpl, added AlarmServerConnectionStateMsg |
|30.04.2015|| added lock for pending messages, improve logging, trim for ModulInstanceManager keys|
|24.04.2015|| set MaxReceiveBuffer size from 16k to 64k,  bug fix UD_Protocol -> error on big data|
|21.04.2015|| improve logging in alarm inheritance |
|10.04.2015|| improve logging for JISImpl -> On a put into lay-and band-spooler the data will be logged|
|01.04.2015|| added new option (UseSocketBasedReceiveThread) to give every socket his own DataReceive Thread -> Reason: sometimes data are available in the buffe but no callback was fired.|
|26.03.2015|| extend exception handling for check running process, the Eventdistributor did not wait for ack anymore, ICONSocket write a debug output if data are available in the buffer an would not be processed |
|13.03.2015|| performance optimization in diagnosis view of send and receive slots |
|09.03.2015|| bug fix in DataBasedInstanceManager shutdown|
|06.03.2015|| change GetIpAddress for plc access to remove blanks from the address, bug fixes and optimization of DataBasedMsgRooter and DataBasedInstanceManager |
|03.03.2015|| optimize data extractor for DataBasedMsgRouter and DataBasedModuleInstanceManager |
|17.02.2015|| optimize S7AlarmManagement to handle parallel Graph7 alarms  |
|03.02.2015|| optimize socket error handling to prevent stop of receive routine once an internal error occurred |
|12.12.2014|| optimize JIS module to use it as FIFO|
|20.11.2014|| extend S7AlarmManagement to use it with prodiag.ini|
|13.11.2014|| optimize JIS module to use it as FIFO|
|21.10.2014|| added new module for dynamic module instantiation, and add step chain support for pdiag.xml|
|04.08.2014|| added support for "Includes" to separate the configuration file into different files |
|29.07.2014|| added state bar to show some states and password levels |
|14.07.2014|| implementation of RFC1006 in C#, switch to Visual Studio 2013 |

