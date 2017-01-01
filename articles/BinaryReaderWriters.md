<h1>Software Specification</h1>  

<h1>BinaryReaderWriters</h1>
  


**insite GmbH**



	
---  
#Introduction#

A BinaryReaderWriter is a software component which is part of the IDAT systems and is used for reading and writing data. There are various versions of such BinaryReaderWriters, such as for reading and writing from PLC, files or data definitions.

---  
##Purpose and Objective##

A BinaryReaderWriter is an interchangeable component. Depending on which technology or target should be written or read, a selection can be made without making changes to the code. This also facilitates the support of future technologies and media, since only a new BinaryReaderWriter needs to be created without having to intervene in existing applications.

---  
##Definitions, acronyms, abbreviations##

*  **PLC:** Programmable Logic Controller
*  **SPS:** Speicher Programmierbare Steuerung (german for PLC)
*  **LibNoDave:** Free library for the communication with a PLC
*  **ODK:** Simatic WinAC Open Development Kit
*  **Data Definition:** Is a file that describes the structure and mapping of the data
*  **Mapping:** A variable is mapped to a defined data area
*  **IoC:** Inversion of control

---  
#General Description#

The special features and setting options of the components are described below. 

---  
##System Environment##

The software is written with C&#35; Visual Studio 2010 for the Target framework .NET 4.0.  


![warning_icon.png](../images/warning_icon.png)
 .NET 4.5 is not used since it does not guarantee any compatibility with XP.

---  
##Framework##

The BinaryReaderWriters are a part of IDAT, and are also configured using the IoC components of IDAT. (For more details, please refer to the chapter [Configuration](#Configuration5))

---  
#BinaryReaderWriters#

The following section examines the currently existing BinaryReaderWriters and points out the options and configurations.
  

All BinaryReaderWriters are linked to the application of the following interface:
  
```javascript
.Interfaces
{
    public class BinaryDataRef
    {
        public string Selector { get; set; }
        public string Offset { get; set; }
        public string Length { get; set; }
        public string BitNumber { get; set; }
        public override string ToString()
        {
            return String.Format("{0} (sel={1}, off={2}, len={3}, bit#={4})", 
                base.ToString(), Selector, Offset, Length, BitNumber);
        }
    }

    public class DataChangedEvent : EventArgs
    {
        public BinaryDataRef DataRef { get; set; }
        public byte[] Data { get; set; }
    }

    public interface BinaryReaderWriter
    {
        event EventHandler<DataChangedEvent> DataChanged;

        bool Connected { get; }

        void Init(string initString);
        void Connect(string connectionString);
        void Disconnect();
        byte[] Read(BinaryDataRef dataRef);
        void Write(BinaryDataRef dataRef, byte[] data);
        void Subscribe(BinaryDataRef dataRef);
        void Unsubscribe(BinaryDataRef dataRef);
    }
}
  

```  


---  
##BinFileReaderWriter##

This BinaryReaderWriter is used to read and write files in binary format.

---  
###Method Parameter###

---  
####Init####
   

The parameter of these methods is not used with this component.

---  
####Connect####
   

The parameter of these methods is not used with this component.

---  
####Read/Write####
   

BinaryDataRef datRef:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Selector </td><td> File name and path</td></tr>
<tr><td>Offset </td><td> Offset in the file from which reading/writing is to be performed</td></tr>
<tr><td>Length </td><td> Length of the data in bytes that should be read/written</td></tr>
<tr><td>BitNumber </td><td> Bit number whose status is to be determined in the specified area</td></tr>
<tr><td>   </td><td> (e.g. Offset=0, Length=2, BitNumber=8  -->  Bit 1.0 )</td></tr>
</table>

  

%latexverttaableend
Byte[] data:
  

Contains the data to be written. If a bit number is specified, only the state of the byte is evaluated, i.e. if any byte is &#60;&#62; 0, then the state is true.

---  
###Configuration###

No further configuration parameters are necessary. It is sufficient to use the default implementation:
  
```html
<BinaryReaderWriter name="BinFileReaderWriter">
</BinaryReaderWriter>
```  


---  
###Additional Dependencies###

<table><tr><th>Assembly </th><th> Manufacturer</th></tr>
<tr><td>log4net.dll </td><td> the Apache Software Foundation</td></tr>
</table>



---  
##DataDefReaderWriter##

This BinaryReaderWriter is used to read and write data definitions. (For details, see Data Definitions section)

---  
###Method Parameter###

---  
####Init####
   

The parameter of these methods is not used with this component.

---  
####Connect####
   

The parameter of this method is provided by the configuration and is an XML node. It configures the following properties:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Files </td><td> Contains all data definition files that can be read or written</td></tr>
<tr><td>OutPath </td><td> Contains the path where the written file is saved</td></tr>
<tr><td>PostFix </td><td> Specifies the text placed behind written data. E.G.: ".out.xml"</td></tr>
<tr><td>BulkWrite </td><td> Specifies that an Out file is first written if another Out file is to be</td></tr>
<tr><td>   </td><td> processed, if an error occurs or if Disconnect is called (Default: true)</td></tr>
</table>



---  
####Read/Write####
   

BinaryDataRef dataRef:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Selector </td><td> Selector of the target mapping</td></tr>
<tr><td>Offset </td><td> Offset in the mapping of the data definition</td></tr>
<tr><td>Length </td><td> Length of the data in bytes that should be read/written</td></tr>
<tr><td>BitNumber </td><td> Bit number whose status is to be determined in the specified area</td></tr>
<tr><td>   </td><td> (e.g. Offset=0, Length=2, BitNumber=8  -->  Bit 1.0)</td></tr>
</table>

  


Byte[] data:
  

Contains the data to be written. If a bit number is specified, only the state of the byte is evaluated, i.e. if any byte is &#60;&#62; 0, then the state is true.

---  
###Configuration###

  
```html
<BinaryReaderWriter name="DataDefReaderWriter">
  <File><![CDATA[><..\Dat\Konfig\PLCDataManagerConfig.xml//Setup/Instances/
  PLCDataManagers/PLCDataManager[@name='PLCDataManager']/DefPaths;..\Dat\
  Konfig\PLCDataManagerConfig.xml//Setup/Instances/PLCDataManagers/PLCDataManager
  [@name='PLCDataManager']/DefPathsAuto]]></File> <OutPath><![CDATA[><..\Dat\Konfig\
  PLCDataManagerConfig.xml//Setup/Instances/PLCDataManagers/PLCDataManager
  [@name='PLCDataManager']/OutPaths]]></OutPath>
  <PostFix>.out.xml</PostFix>
  <BulkWrite>true</BulkWrite>
</BinaryReaderWriter>
```  


<table><tr><th>Variable </th><th> Description</th></tr>
<tr><td>File </td><td> The file definitions are specified here. There are several options here:</td></tr>
<tr><td>   </td><td> 1. Specification of the file name separated by a semicolon</td></tr>
<tr><td>   </td><td> 2. Specification of paths to the data definitions separated by a</td></tr>
<tr><td>   </td><td> semicolon</td></tr>
<tr><td>   </td><td> 3. Speecification of an XPath entry that regers to another entry.</td></tr>
<tr><td>   </td><td> Introduction of XPath is indicated by &#62;&#60;</td></tr>
</table>

  



---  
###Additional Dependencies###

<table><tr><th>Assembly </th><th> Manufacturer</th></tr>
<tr><td>ResolverImpl.dll </td><td> insite GmbH</td></tr>
<tr><td>log4net.dll </td><td> The Apache Software Foundation</td></tr>
</table>

  



---  
##LibNoDaveReaderWriter##

This BinaryReaderWriter is used to read and write PLC data. 
  

LibNoDave is a library that provides the necessary functions for connecting and exchanging data of a Siemens S7 300/400 PLC and other types.

---  
###Method Parameter###

---  
####Init####
   

The parameter of these methods is not used with this component.

---  
####Connect####
   

The parameter of this method is provided by the configuration and is an XML node. It configures the following properties:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>IP </td><td> IP address of the control (Default= 127.0.0.1)</td></tr>
<tr><td>Port </td><td> Access port of the control (Default=102)</td></tr>
<tr><td>Rack </td><td> Rack number (Default=0)</td></tr>
<tr><td>Slot </td><td> Slot (Default=2)</td></tr>
</table>

  



---  
####Read/Write####
   

BinaryDataRef dataRef:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Selector </td><td> Selector of the target mapping</td></tr>
<tr><td>Offset </td><td> Offset in the mapping of the data definition</td></tr>
<tr><td>Length </td><td> Length of the data in bytes that should be read/written</td></tr>
<tr><td>BitNumber </td><td> Bit number whose status is to be determined in the specified area</td></tr>
<tr><td>   </td><td> (e.g. Offset=0, Length=2, BitNumber=8  -->  Bit 1.0 )</td></tr>
</table>

  


Byte[] data:
  

Contains the data to be written. If a bit number is specified, only the state of the byte is evaluated, i.e. if any byte is &#60;&#62; 0, then the state is true.

---  
###Configuration###

  
```html
<BinaryReaderWriter name="LibNoDaveReaderWriter">
    <IP>127.0.0.1</IP>
    <Port>102</Port>
    <Rack>0</Rack>
    <Slot>2</Slot>
</BinaryReaderWriter>
```  

For details on the parameters, see Connect  

---  
###Additional Dependencies###

<table><tr><th>Assembly </th><th> Manufacturer</th></tr>
<tr><td>libnodave.dll </td><td>   </td></tr>
<tr><td>libnodave.net.dll </td><td>   </td></tr>
<tr><td>log4net.dll </td><td> The Apache Software Foundation</td></tr>
</table>

  



---  
##ODKCCXReaderWriter##

This BinaryReaderWriter is used to read and write PLC data.
  

The new WinAC option Open Development Kit (ODK) allows all resources of the PC to be used flexibly from the control program via three different interfaces in order to extend the PLC functionality to a high level of performance.

---  
###Method Parameter###

---  
####Init####
   

The parameter of these methods is not used with this component.

---  
####Connect####
   

By calling this method, the system checks whether the Shared Memory was already created, the parameter is not necessary. (For details, see Additional Dependencies.)

---  
####Read/Write####
   

BinaryDataRef dataRef:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Selector </td><td> Selector of the target mapping</td></tr>
<tr><td>Offset </td><td> Offset in the mapping of the data definition</td></tr>
<tr><td>Length </td><td> Length of the data in bytes that should be read/written</td></tr>
<tr><td>BitNumber </td><td> Bit number whose status is to be determined in the specified area</td></tr>
<tr><td>   </td><td> (e.g. Offset=0, Length=2, BitNumber=8 -&#62; Bit 1.0 )</td></tr>
</table>

  


Byte[] data:
  

Contains the data to be written. If a bit number is specified, only the state of the byte is evaluated, i.e. if any byte is &#60;&#62; 0, then the state is true.

---  
###Configuration###

<a name="Configuration5"></a>
  
```html
<BinaryReaderWriter name="ODKCCXReaderWriter">
</BinaryReaderWriter>
```  

No further configuration is necessary here. (For further details, see Additional Dependencies.)

---  
###Additional Dependencies###

<table><tr><th>Assembly </th><th> Manufacturer</th></tr>
<tr><td>ODKCCXLib&#95;CS.dll </td><td> insite GmbH</td></tr>
<tr><td>SMHeapManager.dll </td><td> insite GmbH</td></tr>
<tr><td>ODKCCXLib.dll </td><td> insite GmbH</td></tr>
<tr><td>log4net.dll </td><td> The Apache Software Foundation</td></tr>
</table>

  


Before ODKCCXReaderWriter can be used, additional components must be configured and installed.

---  
####Registration of the Components####
   

The file ODKCCXLib.dll must be saved in the Windows\System32 directory.
  

Registration of the ODKCCXLib&#95;CS.dll in order to be controlled by PLC.  

regasm.exe ODKCCXLib&#95;CS.dll /codebase  

Entry of the Dlls in the Global Assembly Cache in order to use the serialisation from different directories.  

gacutil.exe -i ODKCCXLib&#95;CS.dll  

gacutil.exe -i SMHeapManager.dll  


---  
####Configuration and Programming in the PLC####
   

An implementation must be performed in the PLC in order to use the ODKBinaryReaderWriter.

---  
#####System Function Blocks#####
   

<table><tr><th>Block </th><th> Name </th><th> Description</th></tr>
<tr><td>SFB65001 </td><td> CREA&#95;COM </td><td> Loads the Dll. Must be called at the start</td></tr>
<tr><td>SFB65002 </td><td> ASYN&#95;COM </td><td> Must be called cyclically in order to process</td></tr>
<tr><td>   </td><td>    </td><td>  the read and write commands</td></tr>
</table>



---  
#####Example Blocks#####
   

An example implementation is shown here.

---  
#####Data Block for Configuration#####
   

  
```javascript
CXKonfig"
TITLE =
VERSION : 0.1


  STRUCT    
   CREA_COM_STAT : WORD ;   
   EXEC_COM_STAT : WORD ;   
   ASYN_COM_STAT : WORD ;   
   ASYN_BUSY : BOOL ;   
   ASYN_REQ : BOOL ;    
   DelayCount : DWORD ; 
   DLL_NAME : STRING  [254 ] := '*dll:ODKCCXLib.dll';   
   RTDLL_NAME : STRING  [254 ] := '';   
   OB100Counter : WORD ;    
   OB100Counter1 : WORD ;   
  END_STRUCT ;  
BEGIN
   CREA_COM_STAT := W#16#0; 
   EXEC_COM_STAT := W#16#0; 
   ASYN_COM_STAT := W#16#0; 
   ASYN_BUSY := FALSE; 
   ASYN_REQ := FALSE; 
   DelayCount := DW#16#0; 
   DLL_NAME := '*dll:ODKCCXLib.dll'; 
   RTDLL_NAME := ''; 
   OB100Counter := W#16#0; 
   OB100Counter1 := W#16#0; 
END_DATA_BLOCK

  

```  


---  
#####Function Block for calling up#####
   

  
```javascript
CX"
TITLE =
AUTHOR : SIMATIC
FAMILY : COM_FUNC
VERSION : 0.0

"ASYN_COM"
BEGIN
   REQ := FALSE; 
   OBJHANDLE := W#16#0; 
   COMMAND := DW#16#0; 
   BUSY := FALSE; 
   ERROR := FALSE; 
   STATUS := W#16#0; 
END_DATA_BLOCK

FUNCTION_BLOCK "FB_ODKCCX"
TITLE =
VERSION : 0.1


VAR_INPUT
  IN_ObjHandle : WORD ; 
END_VAR
VAR
  STAT_RunReq : BOOL  := TRUE;  
  STAT_StopReq : BOOL ; 
  STAT_Busy : BOOL ;    
  STAT_AsynCommStat : WORD ;    
  STAT_Command : DWORD ;    
  STAT_Dummy : DWORD ;  
END_VAR
BEGIN
NETWORK
TITLE =ASYNCHRONOUS CALL (SFB65003) 

      L     W#16#FFFF; 
      T     #STAT_AsynCommStat; 
      CALL "ASYN_COM" , "DB_ASYNC_COM" (
           REQ                      := #STAT_RunReq,
           OBJHANDLE                := #IN_ObjHandle,
           COMMAND                  := #STAT_Command,
           INPUTDATA                := #STAT_Dummy,
           OUTPUTDATA               := #STAT_Dummy,
           BUSY                     := #STAT_Busy,
           STATUS                   := #STAT_AsynCommStat);

      L     #STAT_AsynCommStat; 
      L     0; 
      >I    ; // ODK Status > 0
      SPN   end; // Async call not yet completed continue polling

// ASYN_COM JOB completed. Finish the test and make it ready for the next

      CALL "ASYN_COM" , "DB_ASYNC_COM" (
           REQ                      := #STAT_StopReq,
           OBJHANDLE                := #IN_ObjHandle,
           COMMAND                  := #STAT_Command,
           BUSY                     := #STAT_Busy,
           STATUS                   := #STAT_AsynCommStat);


NETWORK
TITLE =

end:  NOP   0; 

END_FUNCTION_BLOCK

  

```  


---  
#####Calling up Blocks#####
   

  
```javascript
"CYCL_EXC"
TITLE = "Main Program SMX Start"
VERSION : 0.1


VAR_TEMP
  OB1_EV_CLASS : BYTE ; //Bits 0-3 = 1 (Coming event), Bits 4-7 = 1 (Event class 1)
  OB1_SCAN_1 : BYTE ;   //1 (Cold restart scan 1 of OB 1), 3 (Scan 2-n of OB 1)
  OB1_PRIORITY : BYTE ; //1 (Priority of 1 is lowest)
  OB1_OB_NUMBR : BYTE ; //1 (Organization block 1, OB1)
  OB1_RESERVED_1 : BYTE ;   //Reserved for system
  OB1_RESERVED_2 : BYTE ;   //Reserved for system
  OB1_PREV_CYCLE : INT ;    //Cycle time of previous OB1 scan (milliseconds)
  OB1_MIN_CYCLE : INT ; //Minimum cycle time of OB1 (milliseconds)
  OB1_MAX_CYCLE : INT ; //Maximum cycle time of OB1 (milliseconds)
  OB1_DATE_TIME : DATE_AND_TIME ;   //Date and time OB1 started
  Dummy : BOOL ;    
END_VAR
BEGIN
NETWORK
TITLE =WinAC ODK Initialisieren

      CALL "CREA_COM" , "DB_CREA_COM" (
           PROGID                   := "DB_ODKCCXKonfig".DLL_NAME,
           STATUS                   := "DB_ODKCCXKonfig".CREA_COM_STAT);
      NOP   0; 
NETWORK
TITLE =WinAC ODK Aufrufen

      CALL "FB_WACUniCycle" , "DI_WACUniCycle" (
           IN_ObjHandle             := "DB_ODKCCXKonfig".CREA_COM_STAT);
      NOP   0; 
END_ORGANIZATION_BLOCK
  

```  


---  
##OPCReaderWriter##

This BinaryReaderWriter is used to read and write PLC data. 
  

OLE for Process Control (OPC) was the original name for the standardised software interfaces that should enable the data exchange between applications of various manufacturers in automation technology. Thanks to the progressive development of these interfaces and associated acceptance concerning the relevance of the OLE object system, only the name OPC without reference to an abbreviation is used today.

---  
###Method Parameter###

---  
####Init####
   

The parameter of these methods is not used with this component.

---  
####Connect####
   

The parameter of this method is provided by the configuration and is an XML node. It configures the following properties:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>ServerName </td><td> Name of the OPCServer (Default= insite.opc.simu)</td></tr>
<tr><td>ProtocolName </td><td> Name of the access protocol (Default=S7)</td></tr>
<tr><td>ConnectionName </td><td> Name of the connection (Default=RTX) </td></tr>
<tr><td>IntemSyntax </td><td> Syntax of the items (Default=SimaticNet) possible values:</td></tr>
<tr><td>   </td><td> -SimaticNet</td></tr>
<tr><td>   </td><td> -&#62; e.g.: Bit = [pref]DB[DBNr].X[Offset+ Bit/8].[BitNr %8]</td></tr>
<tr><td>   </td><td> -Sinumerik</td></tr>
<tr><td>   </td><td> -&#62; e.g.: Bit = DB[DBNr].DBX[Offset+ Bit/8].[BitNr %8]</td></tr>
<tr><td>   </td><td> -WinAC</td></tr>
<tr><td>   </td><td> -&#62; e.g.: Bit = DB[DBNr].DBX[Offset+ Bit/8].[BitNr %8]</td></tr>
<tr><td>   </td><td> -INAT -&#62; e.g.: Bit = DB[DBNr].B[Offset+ Bit/8].[BitNr %8]</td></tr>
</table>



---  
####Read/Write####
   

BinaryDataRef dataRef:  

<table><tr><th>Property </th><th> Description</th></tr>
<tr><td>Selector </td><td> Selector of the target mapping</td></tr>
<tr><td>Offset </td><td> Offset in the mapping of the data definition</td></tr>
<tr><td>Length </td><td> Length of the data in bytes that should be read/written</td></tr>
<tr><td>BitNumber </td><td> Bit number whose status is to be determined in the specified area</td></tr>
<tr><td>   </td><td> (e.g. Offset=0, Length=2, BitNumber=8 -&#62; Bit 1.0 )</td></tr>
</table>



Byte[] data:
  

Contains the data to be written. If a bit number is specified, only the state of the byte is evaluated, i.e. if any byte is &#60;&#62; 0, then the state is true.

---  
###Configuration###

  
```html
<BinaryReaderWriter name="OPCReaderWriter">
    <ServerName>OPC.SimaticNet</ServerName>
    <ProtocolName>S7</ProtocolName>
    <ConnectionName>RTX</ConnectionName>
    <ItemSyntax>SimaticNet</ItemSyntax>
</BinaryReaderWriter>
```  

For details on the parameters, see Connect.

---  
###Additional Dependencies###

<table><tr><th>Assembly </th><th> Manufacturer</th></tr>
<tr><td>PLCOPCdotNETLib.dll </td><td> VISCOM</td></tr>
<tr><td>PLCOPCAccessor.dll </td><td> insite GmbH</td></tr>
<tr><td>log4net.dll </td><td> The Apache Software Foundation</td></tr>
</table>



---  
#Configuration#

  
```html
<?xml version="1.0" encoding="UTF-8"?>
<Setup>
    <Assemblies>
        <Assembly path="OPCReaderWriter.dll"/>
    </Assemblies>
    <Instances>
        <BinaryReaderWriters>            
            <BinaryReaderWriter name="OPCReaderWriter">
                <ServerName>OPC.SimaticNet</ServerName>
                <ProtocolName>S7</ProtocolName>
                <ConnectionName>RTX</ConnectionName>
                <ItemSyntax>SimaticNet</ItemSyntax>
            </BinaryReaderWriter>
        </BinaryReaderWriters>
    </Instances>
</Setup>
```  

A BinaryReaderWriter as well any IDAT component in the configuration must be made known, this firstly happens in the Assemblies section, where the name of the DLL is entered; secondly, the instance must be declared, which occurs in the Instances/BinaryReaderWriters section. Each BinaryReaderWriter used must be configured here with its name.

---  
#Data Definition#

  
```html
<?xml version="1.0" encoding="utf-8"?>
<DataDef Endianness="Host-Endianess" Encoding="Base16" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xmlns="http://www.insite-gmbh.de/IDAT/DataDef" xsi:schemaLocation=
         "http://www.insite-gmbh.de/IDAT/DataDef TypeDefinition/DataDef.xsd">
  <!-- Structs are the userdefined types -->
  <Types>
    <Struct name="DB_Optionen_Allgemein">
      <Var name="Rechnername" type="STRING" length="16" />
      <Var name="Ziel_BST1" type="STRING" length="8" />
      <Var name="Ziel_BST2" type="STRING" length="8" />
      <Var name="Ziel_BST3" type="STRING" length="8" />
      <Var name="Ziel_BST4" type="STRING" length="8" />
      <Var name="Ziel_BST5" type="STRING" length="8" />
      <Var name="Ziel_BST6" type="STRING" length="8" />
      <Var name="BST1_vorh" type="BOOL" />
      <Var name="BST2_vorh" type="BOOL" />
      <Var name="BST3_vorh" type="BOOL" />
      <Var name="BST4_vorh" type="BOOL" />
      <Var name="BST5_vorh" type="BOOL" />
      <Var name="BST6_vorh" type="BOOL" />
      <Var name="Repaplatz" type="BOOL" />
      <Var name="HAP_NOT_Aus_vorhanden" type="BOOL" />
      <Var name="Ausw_WT_zu_PalRepa_BST1" type="BOOL" />
      <Var name="Fliessmontage" type="BOOL" />
      <Var name="Pneumatik_vorhanden" type="BOOL" />
      <Struct name="AP" countItems="6">
        <Var name="virtuell" type="BOOL" />
        <Var name="ApVisu_Vorh" type="BOOL" />
        <Var name="AP_IST_DT" type="BOOL" />
        <Var name="zugeordnet_zu" type="INT" />
      </Struct>
      <Var name="Konfig_Ordner_Pfad" type="STRING" length="80" />
      <Var name="Safety_Checksum" type="DWORD" />
      <Var name="SHUT_DOWN_Verz_Zeit" type="INT" />
      <Var name="Shut_down_abgew" type="BOOL" />
      <Var name="Shut_Down_OPC2USV" type="BOOL" />
    </Struct>
  </Types>
  <!-- declare the Values you want to use -->
  <Vars>
    <Var name="Options" type="DB_Optionen_Allgemein" />
  </Vars>
  <!-- define the mapping and the operations on the values-->
  <Mappings>
    <Mapping name="Opt" var="Options" source="OPCReaderWriter" selector="251"
             offset="0" type="BinaryFile" active="true" >
      <Filters>
        <Filter var="Safety_Checksum" />
      </Filters>
      <Operations>
        <Read/>
        <Write/>
      </Operations>
    </Mapping>
  </Mappings>
</DataDef>
```  


---  
##Types##

This section is filled by the Tool AWLXMLConverter and contains the definitions of the data blocks. For further details, please refer to the documentation for AWLXMLConverter.

---  
##Vars##

In this section variables are declared that are elements of the type of element which are declared in Types. These variables can then be used in the mappings.

---  
##Mappings##

Variables can be mapped to different areas and operations can then be executed via the Mappings. Additionally, filters can be declared, too. These filters only apply to write operations. A filtered variable is not rewritten to the PLC.

---  
#Installation#

This requires that

  1.   Microsoft .NET Framework 4.0 Servicepack 1 and
  2.   Microsoft Visual C++ 2010 Redistributable Package
  3.   WIN AC RTX 2009 or higher for using ODK

are installed and available on the destination system under Windows.

---  
##Files generated during runtime##

These components generate files independently. Here are the meanings:

  1.   **Log files:** Files configured for Log4net.

---  
#Change directory#

<table><tr><th>Author </th><th> Date </th><th> Remarks</th></tr>
<tr><td>Benjamin Prömmer </td><td> January 2013 </td><td> Creation</td></tr>
<tr><td>Ralf Gedrat </td><td> January 2013 </td><td> Brief editing</td></tr>
<tr><td>Benjamin Prömmer </td><td> February 2013 </td><td> Adding parameters for</td></tr>
<tr><td>   </td><td>    </td><td> DataDefReaderWriter;</td></tr>
<tr><td>   </td><td>    </td><td> Configuration of BinaryReaderWriter</td></tr>
</table>