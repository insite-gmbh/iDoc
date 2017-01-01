<h1>IDAT Application Scenario</h1>
  

**Transferring data from Excel to a PLC**
  


**insite GmbH**



	
---  
#Introduction#

The request from BMW Steyr to automatically transfer data from a Microsoft Excel Sheet to a PLC led to the development of a set of components that together form the IDAT family. Though this task could have been done by programming a "monolithic" application that exactly satisfies this request, we chose to implement small components that can be used as building blocks and could be exchanged later if, say, the origin of the data would be a database or a plain text file instead of an Excel sheet, or the receiver of the data will be a certain microprocessor system instead of a Siemens S7 PLC. The flexibility of this approach has a drawback: the orchestration of small components to form an application as seen by the user, involves some configuration that may get more complex. This document aims to make these configuration tasks clearer and may serve as a starting point to a user who wants to alter the functionality of the existing application e.g. for transferring different data.
  

**Please open the configuration file "IMON.xml" and the DDF**  
 **"IDATSchrauberDB.xml" in a text editor for looking up things while reading this guide in order to get a better understanding of what is explained here.**

---  
##Document Audience##

Any user that has a general understanding of the system that is described here, what it does and why it is needed can benefit from this documentation. To make changes to it, you should have at least a generic knowledge about the following things:

---  
###PLC###

How data is organized and viewed in a PLC.

---  
###Component Oriented Software###

Not necessary, but it will help, if you are aware of the separation of an application into small building blocks, know how to handle EXEs and DLLs and what an interface, a plug-in or "inversion of control" is.

---  
###XML, XPath###

How to work on XML files, how elements and attributes are defined and what a well-formed XML document is. What XPath is and how it is used.

---  
###C&#35;, IEnumerable###

If you need to implement difficult queries to get the data from Excel and to layout to the format that is used in the PLC, you should know the extension methods of IEnumerable or LINQ.

---  
##Definitions, Acronyms, Abbreviations##

*  **Data Definition File (DDF):** A file that describes the structure of single or combined variables and defines the mapping of these variables.
*  **Mapping:** Variables are mapped to a defined data or memory area. 

---  
#Overview of the Implemented Functionality#

To start, here is an overview of the separate functions that make-up the application. They may include subsequent points with a more detailed explanation about the specific functionality and how this functionality could be seen in a more generic way. 

---  
##Observe a Certain Excel File for Changes##

<a name="Observe_a_Certain_Excel_File_for_Changes"></a>
As soon as somebody saves changes in the Excel data, the application detects the modification and starts to transfer the data to the PLC.

---  
###Specific Case###

Do a cyclic check of the file information data of the Excel file and compare the actual modification time to the last detected modification time. If the modification time has changed, transfer the Excel data to the PLC.

---  
###Generic Case###

Do a cyclic check of the file information of one or more files on disk. Compare each modification time and if a certain file has changed, send an event along with the path of the changed file to another component. This is how the "file monitoring" component is implemented. Via its configuration you simply tell this component which file(s) to observe and which component the receiver of the "file changed"-event is. 

---  
####Even more generic: Separation of monitor and comparer####
   

<a name="Even_more_generic:_Separation_of_monitor_and_comparer"></a>
To be exact, above functionality is implemented in an even more generic way, by separating the monitor from the comparer. The monitor is responsible to create change events and uses one or more comparer(s) to detect changes. Below, you can see that such a comparer can also be implemented to compare e.g. PLC data. This means the monitor stays the same, but the comparer changes.

---  
##Extract Data from the Changed Excel File and Convert it to Data Format used in the PLC##

Only a certain part of the data in the Excel file is transferred to the PLC. In the specific case, the selection of data and its location on the spreadsheet is well known. Putting this information statically into the application, would be a bad design flaw, since the data selection may change in the future. So there’s a need to be able to define the extracted and transferred data with a query expression. Since the queried data is normally not arranged as successive lines or a simple rectangle of cells, the query expression can get quite complex. Furthermore, the arrangement of the Excel data normally does not fit the layout of the data in the PLC. So along with the purpose of extracting the data, the query expression also needs to define the conversion to the destination format that is used in the PLC.

---  
###Querying Data from an Excel Sheet###

An Excel sheet is a two-dimensional matrix of cells, with each cell containing a single value. Therefore, we developed a simple "query language" that in general deals with the extraction of a rectangular part of this matrix (which, of course, in turn is a matrix). Such a (sub-)matrix equals a C&#35; type of IEnumerable&#60;IEnumerable&#60;string&#62;&#62; and you can append any method that is defined for IEnumerable in C&#35; (Select, Skip, ToList, Where, Aggregate, ...) to modify the final content and the layout of the data. So some knowledge in C&#35; and especially in the extension methods of IEnumerable is a great benefit to understand how the Excel data processing is done. There’s a new documentation called "Matrix User Guide" that contains some examples how to use the query language or – as the Matrix User Guide states – how to build a valid "data moniker".

---  
###Evaluating Queries###

Since the queries can get quite complex we could supply a tool to test the matrix monikers. It is called “Test Matrix” and is not officially supported nor documented, but you can use it to test if your monikers work as expected. 

---  
##Transferring Data to PLC##

The data exchange with the PLC is done by a component called “Executor”. The executor takes a DDF and executes the read and write operations on the mappings that are defined in the DDF. 

---  
###Phases of Execution###

<a name="Phases_of_Execution"></a>
When the executor processes a DDF, it goes through several phases of execution:
  

**1.) Replace constants:** Constants are referenced by &#35;&#60;name of constant&#62;&#35;. All constants are defined at the beginning of the file inside the XML element &#60;Consts&#62;. The executor walks through the DDF and replaces each occurrence of a constant with its value.
  

**2.) Read all pre-execution data from the PLC:** The executor evaluates all read operations that are marked with the "preex"-attribute set to "true". Search for preex="true" in the DDF to locate these operations. The values that are read from the PLC in this phase will be saved to an internal variable cache. These cached variables can then be used to control the further execution of the DDF (phase 3 and 4). In this use case, write operations are activated/deactivated depending on the value of such a variable. For example:

  
```html
<Write var="TimeToCopyFromXLS" active="#IfRead.WriteEnabled#">
    <![CDATA[@#ExcelFile#
             !#GlobalSheet#
             !TimeToCopyFromXLS
       ]]>
</Write>
```  


This write operation is only executed in phase 3 if the PLC variable  

IfRead.WriteEnabled was true during the pre-execution phase. You'll find many similar examples in the DDF.
  

**3.) Execute all active write operations:** The data (in this use case mostly values from Excel) will get written to the PLC.
  

**4.) Execute all active read operations:** The variables defined inside a read operation are read from the PLC and an output file is written. The output file is very similar to the DDF but has nested data.
  

The pre-execution phase and therefore the possibility to integrate PLC data into the DDF before executing the actual write and read operations, enable the user to realize a kind of protocol for data exchange between the PLC and the executor.

---  
###Play with the Executor###

You can test the executor and play with it by using an unsupported tool called "ExecutorCmdLineHost". It allows you to execute a DDF against a PLC. If you observe the created output files and the data in the PLC you will get a good understanding of how the Executor works. See the manual "XLAdapter.docx" for details.
  

**Attention: The ExecutorCmdLineHost must be handled with care, since you may overwrite data in the PLC when running it!**

---  
##Observe PLC for Data Requests##

As already stated in [Even More Generic: Separation of Monitor and Comparer](#Even_more_generic:_Separation_of_monitor_and_comparer), beside a comparer for file information, a comparer for PLC data is also available. Therefore, the implemented system is able to initiate a transfer from Excel to PLC not only when it detects a change in an Excel file but also when it detects a change in some PLC flag or similar. The PLC uses the flag IfRead.UpdateRequired for this purpose.

---  
#Configuration File IMON.xml#

<a name="Configuration_File_IMON.xml"></a>
What follows is a commented version of an IMON.xml configuration file. Not all details are explained, its purpose is to give you an overview of what is configured here.
  
```html
<?xml version="1.0" encoding="UTF-8"?>
<Setup>
```  

The element &#60;Assemblies&#62; lists all assemblies (DLLs) that make up the application.
  
```html
    <Assemblies>
        <Assembly path="IMONContentMonitor.dll"/>
        <Assembly path="IMONFileComparer.dll"/>
        <Assembly path="IMONDataComparer.dll"/>
        <Assembly path="IMONMatrixContentComparison.dll"/>
        <Assembly path="IMONIDATExecutorEventHandler"/>
        <Assembly path="ResolverImpl.dll"/>
        <Assembly path="OPCReaderWriter.dll"/>
        <Assembly path="ExcelDataReader.dll"/>
        <Assembly path="S7Converter.dll"/>
    </Assemblies>
```  

The element &#60;Instances&#62; configures instances of certain objects that are used by the application.
  
```html
    <Instances>
        <!-- IMON -->
        <IMonitors>
            <IMonitor name="Monitor">
```  

The element &#60;ContentMonitor&#62; sets up the monitor as described in [Observe a Certain Excel File for Changes](#Observe_a_Certain_Excel_File_for_Changes). Inside the element &#60;ContentMonitor&#62; two comparers are defined.
  
```html
              <ContentMonitor>
```  

The first comparer "IMONFileComparer" is configured to detect changes in the Excel file "PGSList&#95;FL.xlsx". The element &#60;File&#62; is not used directly by the file comparer but serves as a hint, what name the local file has, that serves as the source for the data. It is referenced by an XPath expression in the DDF (see [IDATSchrauberDB.xml](#DDF_IDATSchrauberDB.xmlDDF)
  
```html
           <Comparer impl="IMONFileComparer">
             <PollingCycle>10</PollingCycle>
             <Source><![CDATA[D:\PGSList_FL.xlsx]]></Source>
             <File><![CDATA[D:\Daten\DH\Konfigs\insite\XLAdapter\PGSList_FL.xlsx]]>
             </File>
             <Destination><![CDATA[D:\Daten\DH\Konfigs\insite\XLAdapter\]]>
             </Destination>
```  

What follows is the name of executor for change events and the name of another executor that is notified, when an error occurs. 
  
```html
                <Executor>
                    <Execute filter="(.*\.xlsx)" eventHandler="IDATExecutor" 
                             errorEventHandler="IDATErrorExecutor" 
                             errorValueName="CurrentErrorCode" hint="none" />
                </Executor>
```  

This is the second comparer "IMONDataComparer" used by the monitor. This is configured to process IDATSchrauberDB.xml
  
```html
           </Comparer>
           <Comparer impl="IMONDataComparer">
             <PollingCycle>3</PollingCycle>
             <DataDefFilename>D:\Daten\DH\Konfigs\insite\XLAdapter\IDATSchrauberDB.xml
             </DataDefFilename>
             <OutputFilename>IMONDataComparerOutput.xml</OutputFilename>
```  

The following action list implements a part of the handshake protocol with the PLC. The other part is implemented in the DDF used by the executor.  

This list is essential for the correct working of the application!
  
```html
             <Actions>
                <Action writeVar="IfError.ErrorCode" eventHandler="IDATExecutor"  />
                <Action writeVar="IfError.ErrorOccured" eventHandler="IDATExecutor"  />
                <Action readVar="IfRead.UpdateRequired" compValue="true" 
                        eventHandler="IDATExecutor" 
                        errorEventHandler="IDATErrorExecutor" 
                        errorValueName="CurrentErrorCode" hint="none" />
                <Action readVar="IfRead.UpdateRequired" compValue="false" 
                        writeVar="IfWrite.UpdateRequiredDetected" writeValue="false" 
                        errorEventHandler="IDATErrorExecutor" 
                        errorValueName="CurrentErrorCode" hint="none" />
                <Action readVar="IfRead.Toggle" compValue="true" 
                        writeVar="IfWrite.Toggle" writeValue="false" 
                        errorEventHandler="IDATErrorExecutor" 
                        errorValueName="CurrentErrorCode" hint="none" />
                <Action readVar="IfRead.Toggle" compValue="false" 
                        writeVar="IfWrite.Toggle" writeValue="true" 
                        errorEventHandler="IDATErrorExecutor" 
                        errorValueName="CurrentErrorCode" hint="none" />
                <Action readVar="IfRead.WriteEnabled" compValue="false" 
                        writeVar="IfWrite.DataWritten" writeValue="false" 
                        errorEventHandler="IDATErrorExecutor" 
                        errorValueName="CurrentErrorCode" hint="none" edge="true" />
             </Actions>
           </Comparer>
          </ContentMonitor>
         </IMonitor>
        </IMonitors>
```  

Now the event handlers are defined, one for handling the change events (IDATExecutor, see above), the other to handle errors (IDATAErrorExecutor). 
  
```html
        <IEventHandlers>
            <IDATExecutorEventHandler name="IDATExecutor">
              <DataDefFilename>D:\Daten\DH\Konfigs\insite\XLAdapter\IDATSchrauberDB.xml
              </DataDefFilename>
              <OutputFilename>ExecutorCmdLineHostOutput.xml</OutputFilename>
            </IDATExecutorEventHandler>
            <IDATExecutorEventHandler name="IDATErrorExecutor">
              <DataDefFilename>D:\Daten\DH\Konfigs\insite\XLAdapter\IDATSchrauberDB.xml
              </DataDefFilename>
              <OutputFilename>ErrorExecutorCmdLineHostOutput.XML</OutputFilename>
            </IDATExecutorEventHandler>
        </IEventHandlers>
```  

You can ignore the next lines, they are more or less "static must-have content" in this application.
  
```html
        <IComparers>
            <IComparer name="comparer" />
        </IComparers>
        <IContentComparisons>
            <IContentComparison name="ContentComparison" />
        </IContentComparisons>
        <IResolvers>
            <IResolver name="Resolver">
            </IResolver>
        </IResolvers>
```  

The binary reader/writers make up the communication channel to the PLC. Here you can change the way the PLC is accessed or configure the OPC server.
  
```html
        <IBinaryReaderWriters>
            <IBinaryReaderWriter name="OPCReaderWriter" >
                <ServerName>insite.opc.simu</ServerName>
                <aServerName>OPC.SimaticNet</aServerName>
                <ProtocolName>S7</ProtocolName>
                <ConnectionName>RTX</ConnectionName>
                <ItemSyntax>SimaticNet</ItemSyntax>
            </IBinaryReaderWriter>
        </IBinaryReaderWriters>
        <IDataStoreReaderWriters>
            <IDataStoreReaderWriter name="ExcelDataReader">
            </IDataStoreReaderWriter>
    </IDataStoreReaderWriters>
```  

Don’t change this unless you communicate with something different than a Siemens PLC.
  
```html
        <IConverters>
            <IConverter name="S7Converter">
            </IConverter>
        </IConverters>
    </Instances>
```  

The next element configures the log4net logging system. See the web for more details.
  
```html
    <log4net>
    <appender name="RollingFile" type="log4net.Appender.RollingFileAppender">
      <file value="IMON.log" />
      <appendToFile value="true" />
      <immediateFlush value="true" />
      <maximumFileSize value="1GB" />
      <maxSizeRollBackups value="-1" />
      <rollingStyle value="Date" />
      <datePattern value="yyyyMMdd" />
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%date %-6level [%5thread]
                                  %message - (%file:%line)%newline"/>
      </layout>
    </appender>
    <root>
      <level value="INFO" />
      <appender-ref ref="RollingFile" />
    </root>
  </log4net>
</Setup>
```  


---  
#DDF IDATSchrauberDB.xml#

<a name="DDF_IDATSchrauberDB.xmlDDF"></a>
What follows is a commented version of a data definition file. Not all details are explained, its purpose is to give you an overview of what is configured here. To understand how the reference to the Excel data is defined, take a look at the "Matrix User Guide". There is a real-world example explained that matches the DDF described here.
  
```html
<?xml version="1.0" encoding="utf-8"?>
<DataDef Endianness="Host-Endianess" Encoding="Base16" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xmlns="http://www.insite-gmbh.de/IDAT/DataDef" 
         xsi:schemaLocation="http://www.insite-gmbh.de/IDAT/DataDef
                             TypeDefinition/DataDef.xsd">
```  


Inside the element &#60;Consts&#62; all constants are defined. A constant is referenced by putting it in between two hash characters (&#35;). Constant references get replaced before the DDF is actually executed. Some constants contain (e.g. "ExcelFile") contain an XPath expression. This means that the value for the constant gets evaluated by dereferencing the XPath. For "ExcelFile" the XPath expression points to the IMON.XML as already explained in ["Configuration File IMON.xml"](#Configuration_File_IMON.xml). You’ll find a lot of information on XPath expressions on the web.
  
```html
    <Consts>
        <Const name="SetupFile">D:\Daten\DH\Konfigs\insite\XLAdapter\IMON.xml
        </Const>
        <Const name="ExcelFile">
            <![CDATA[><#SetupFile#//Setup/Instances/IMonitors/IMonitor
                       [@name='Monitor']/ContentMonitor/Comparer
                       [@impl='IMONFileComparer']/File]]></Const>
        <Const name="DataSheet">Current</Const>
        <Const name="GlobalSheet">Global</Const>
        <Const name="DBNumberIDATPGSData">241</Const>
        <Const name="OffsetInterface">0</Const>
        <Const name="OffsetData">40</Const>
        <Const name="ColumnBTBez">1</Const>
        <Const name="ColumnChannelNum">2</Const>
        <Const name="ColumnSlot">4</Const>
        <Const name="ColumnScrewOrder">5</Const>
        <Const name="ColumnScrewCase">6</Const>
        <Const name="ColumnUndoScrewCase">7</Const>
        <Const name="ColumnFirstProgram">11</Const>
        <Const name="ColumnLastProgram">74</Const>
        <Const name="FieldsBeforePrograms">6</Const>
        <Const name="NumberOfPrograms">64</Const>
        <Const name="NumberOfColumnsInExcel">74</Const>
        <Const name="ExcelSelection">
             <![CDATA[.Margin(0,1,#NumberOfColumnsInExcel#,GroupSameSequence)
             .Select(x => x.Where((y, index) => 
             (index == #ColumnBTBez# || index == #ColumnChannelNum# || 
              index == #ColumnSlot# || index == #ColumnScrewOrder# || 
              index == #ColumnScrewCase# || index == #ColumnUndoScrewCase# || 
	          (index >= #ColumnFirstProgram# && 
	           index <= #ColumnLastProgram#))).ToList())
                .Aggregate(new List<List<string>>(), (list, item) => 
                { if (list.Count < 1) { list.Add(item); } 
                else 
                { List<string> r = list.First(); 
                for (int i = (#NumberOfPrograms# + #FieldsBeforePrograms#) - 1;
                 i >= #FieldsBeforePrograms#; i--) 
                 { item.Insert(i, r[i]); } list.Add(item); } return list; },
                 list => { return list.Skip(1); })
			]]>
		</Const>
		<Const name="CurrentErrorCode">0</Const>
	</Consts>
	<!-- Structs are the userdefined types -->
```  


The element &#60;Types&#62; lists all types that are used in the PLC. These are normally PLC UDTs converted by the AWL converter.
  
```html
    <Types>
        <Struct name="UDT_IDATInterface">
            <Struct name="PLCtoIDAT">
                <Var name="WriteEnable" type="BOOL" />
                <Var name="UpdateRequired" type="BOOL" />
            </Struct>
            <Struct name="IDATtoPLC">
                <Var name="DataWritten" type="BOOL" />
                <Var name="UpdateRequiredDetected" type="BOOL" />
                <Var name="ErrorOccured" type="BOOL" />
                <Var name="Toggle" type="BOOL" />
                <Var name="ErrorCode" type="BYTE" />
            </Struct>
            <Var name="CurrentTimeFromPLC" type="DATE_AND_TIME" />
            <Var name="LastWriteTimeFromIDAT" type="DATE_AND_TIME" />
            <Var name="TimeToCopyFromXLS" type="DATE_AND_TIME" />
            <Var name="MonrToCopyFromXLS" type="STRING" length="8" />
            <Var name="CopyNowFromXLS" type="BOOL" />
        </Struct>
        <Struct name="UDT_Programm_PGS">
        <Struct name="Bauteil" countItems="20">
            <Var name="Bauteilbez" type="STRING" length="60" />
                <Var name="Kanal_Nr" type="INT" />
                <Var name="steckplatz" type="INT" />
                <Var name="Schraubreihenfolge" type="INT" />
                <Var name="SF" type="INT" />
                <Var name="Loeseschraubfall" type="INT" />
                <Struct name="Programm" countItems="64">
                    <Var name="Prg_Name" type="CHAR" countItems="2" />
                    <Var name="Anz_verschr" type="INT" />
                </Struct>
            </Struct>
        </Struct>
        <Struct name="DB_IDAT_PGSData">
            <Struct name="Bst" countItems="6">
                <Var name="Bez" type="STRING" length="8" />
                <Var name="Aktiv" type="BOOL" />
                <Var name="Ablauf" type="UDT_Programm_PGS" />
            </Struct>
        </Struct>
    </Types>
```  

Give the data you want to work on a name and a type, declare variables in other words.
  
```html
    <Vars>
        <Var name="IDATIf" type="UDT_IDATInterface" />
        <Var name="SchraubPara" type="DB_IDAT_PGSData" />
    </Vars>
```  

A mapping maps a variable to a data block in the PLC – in other words: a mapping assigns the memory used to store the content of a variable to the variable. Inside a mapping the read and write operations that should be performed during the Executor run are defined, too (see remarks below).
  
```html
    <Mappings>
        <Mapping name="IfRead" var="IDATIf" source="OPCReaderWriter" 
                 selector="#DBNumberIDATPGSData#" offset="#OffsetInterface#" 
                 type="BinaryFile" active="#(?)CurrentErrorCode==0#" >
            <Operations>
```  

The following read operations are the second part of the handshake protocol that handles the data exchange with the PLC. See ["Configuration File IMON.xml"](#Configuration_File_IMON.xml) for the first part (&#60;Actions&#62; in IMONDataComparer).
  
```html
                <Read name="WriteEnabled" var="PLCtoIDAT.WriteEnable" 
                      active="true" preex="true" />
                <Read name="CurrentTimeFromPLC" var="CurrentTimeFromPLC" 
                      preex="true" />
                <Read name="Toggle" var="IDATtoPLC.Toggle" active="true"/>
                <Read name="UpdateRequired" var="PLCtoIDAT.UpdateRequired" 
                      active="true" preex="true" />
            </Operations>
        </Mapping>

        <Mapping name="Schraubdaten" var="SchraubPara" source="OPCReaderWriter"
                 selector="#DBNumberIDATPGSData#" offset="#OffsetData#" 
                 type="BinaryFile" active="#(?)CurrentErrorCode==0#" >
            <Operations>
	            <Read name="NameBST1" var="Bst[1].Bez" preex="true"/>
                 <Read name="NameBST2" var="Bst[2].Bez" preex="true"/>
                <Read name="NameBST3" var="Bst[3].Bez" preex="true"/>
                <Read name="NameBST4" var="Bst[4].Bez" preex="true"/>
                <Read name="NameBST5" var="Bst[5].Bez" preex="true"/>
                <Read name="NameBST6" var="Bst[6].Bez" preex="true"/>

                <Read name="AktivBST1" var="Bst[1].Aktiv" preex="true"/>
                <Read name="AktivBST2" var="Bst[2].Aktiv" preex="true"/>
                <Read name="AktivBST3" var="Bst[3].Aktiv" preex="true"/>
                <Read name="AktivBST4" var="Bst[4].Aktiv" preex="true"/>
                <Read name="AktivBST5" var="Bst[5].Aktiv" preex="true"/>
                <Read name="AktivBST6" var="Bst[6].Aktiv" preex="true"/>
```  

The following write operations are doing the actual transfer of the Excel data to the PLC. See the “Matrix User Guide” for details. Which of the write operations is executed depends on the state of the “WriteEnabled” flags. These flags are evaluated at the pre-execution stage (see [Phases of Execution](#Phases_of_Execution)).
  
```html
               <Write var="Bst[1].Ablauf" active="#(?)AktivBST1==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST1#"R"#NameBST1#"
                    #ExcelSelection#]]>
               </Write>
               <Write var="Bst[2].Ablauf" active="#(?)AktivBST2==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST2#"R"#NameBST2#"
                       #ExcelSelection#]]>
               </Write>
               <Write var="Bst[3].Ablauf" active="#(?)AktivBST3==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST3#"R"#NameBST3#"
                           #ExcelSelection#]]>
               </Write>
               <Write var="Bst[4].Ablauf" active="#(?)AktivBST4==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST4#"R"#NameBST4#"
                           #ExcelSelection#]]>
               </Write>
               <Write var="Bst[5].Ablauf" active="#(?)AktivBST5==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST5#"R"#NameBST5#"
                           #ExcelSelection#]]>
               </Write>
               <Write var="Bst[6].Ablauf" active="#(?)AktivBST6==IfRead.WriteEnabled#">
                   <![CDATA[@#ExcelFile#
                    !#DataSheet#
                    !C"#NameBST6#"R"#NameBST6#"
                           #ExcelSelection#]]>
               </Write>
            </Operations>
        </Mapping>

        <Mapping name="IfWrite" var="IDATIf" source="OPCReaderWriter" 
                 selector="#DBNumberIDATPGSData#" offset="#OffsetInterface#" 
                 type="BinaryFile" active="#(?)CurrentErrorCode==0#" >
            <Operations>
                <Write var="TimeToCopyFromXLS" active="#IfRead.WriteEnabled#" >
                    <![CDATA[@#ExcelFile#
                        !#GlobalSheet#
                        !TimeToCopyFromXLS
                     ]]>
                </Write>
                <Write var="MonrToCopyFromXLS" active="#IfRead.WriteEnabled#" >
                    <![CDATA[@#ExcelFile#
                     !#GlobalSheet#
                     !MonrToCopyFromXLS
                     ]]>
                </Write>
                <Write var="CopyNowFromXLS" active="#IfRead.WriteEnabled#" >
                    <![CDATA[@#ExcelFile#
                     !#GlobalSheet#
                     !CopyNowFromXLS
                     ]]>
                </Write>
                <Write var="LastWriteTimeFromIDAT" active="#IfRead.WriteEnabled#" >
                 #(RAW)IfRead.CurrentTimeFromPLC#</Write>
                <Write name="DataWritten" var="IDATtoPLC.DataWritten" 
                       active="#IfRead.WriteEnabled#" >#(RAW)IfRead.WriteEnabled#
                </Write>
                <Write name="UpdateRequiredDetected" 
                       var="IDATtoPLC.UpdateRequiredDetected" 
                       active="#IfRead.WriteEnabled#" >#(RAW)IfRead.UpdateRequired#
                </Write>
                <Write name="Toggle" var="IDATtoPLC.Toggle" active="false" >0000
                </Write>
            </Operations>
        </Mapping>

        <Mapping name="IfError" var="IDATIf" source="OPCReaderWriter" 
                 selector="#DBNumberIDATPGSData#" offset="#OffsetInterface#" 
                 type="BinaryFile" active="true" >
            <Operations>
                <Write name="ErrorCode" var="IDATtoPLC.ErrorCode" >
                 #CurrentErrorCode#</Write>
                <Write name="ErrorOccured" var="IDATtoPLC.ErrorOccured">
                 #(?)CurrentErrorCode!=0#</Write>
            </Operations>
        </Mapping>
    </Mappings>
</DataDef>
```  


---  
#Document History#

<table><tr><th>Author </th><th> Date </th><th> Remarks</th></tr>
<tr><td>Karsten Gorkow </td><td> 2014-01-22 </td><td> Initial revision.</td></tr>
</table>