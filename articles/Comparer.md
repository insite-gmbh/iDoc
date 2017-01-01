<h1>Software Specification</h1>  

<h1>Comparer</h1>
  


**insite GmbH**



	
---  
#Introduction#

A Comparer is a software component that is part of the IDAT system and is used for a cyclical comparison of data. Various comparers exist, depending on the type of data they observe. Depending on the comparison results, different actions can be defined.

---  
##Purpose and Objective##

A Comparer is an interchangeable component that monitors and compares data (files, Excel data, PLC data ...)

---  
##Definitions, Acronyms, Abbreviations##

*  **PLC:** Programmable Logic Controller
*  **SPS:** Speicher Programmierbare Steuerung
*  **LibNoDave:** A free library for the communication with a PLC
*  **Data definition file (DDF):** A file that describes the structure and mapping of (PLC) data
*  **Mapping:** A variable is mapped to a defined data area

---  
#General Description#

The special features and setting options of the software are described below. 

---  
##System Environment##

The software is written in C&#35; with Visual Studio 2010 for the Target framework .NET 4.0. 
  


![warning_icon.png](../images/warning_icon.png)
 .NET 4.5 is not used since it does not guarantee any compatibility with XP.

---  
##Framework##

This components are a part of IDAT and are also configured using the IoC components of IDAT (for more details, please refer to the chapter Configuration).

---  
##Host application##

In this installation and use case, there is one host application that uses comparers. It is called "IMON" and has it's own "IMON User Guide".

---  
#Comparers#

The following section examines the currently existing comparers and points out the options and configurations.
  

All comparers are linked to the application by implementing the following interface:
  
```javascript
arer
{
    public interface IComparer
    {
        void Configure(XElement xmlSetup);
        void RunOnce(); 
        void Start();
        void Stop();
    }
}
  

```  


---  
##FileComparer##

This component compares files as well as their contents if necessary (see [ContentComparison](#ContentComparison)). On a change of the monitored file, an event can be created.

---  
###Configuration###

  
```html
<Comparer impl="IMONFileComparer">
    <PollingCycle>10</PollingCycle>
    <Source><![CDATA[D:\Test.xlsx]]></Source>
    <Destination><![CDATA[D:\tmp\]]></Destination>
    <Executor>
        ...
    </Executor>
</Comparer>
```  


<table><tr><th>Parameter </th><th> Description</th></tr>
<tr><td>PollingCycle </td><td> Test every x seconds for a change</td></tr>
<tr><td>Source </td><td> The files to be checked are specified here</td></tr>
<tr><td>   </td><td> (file name with wildcards possible)</td></tr>
<tr><td>Destination </td><td> Destination directory. It contains the last version of the file. The</td></tr>
<tr><td>   </td><td> source file may change and is compared to the version stored here</td></tr>
<tr><td>Executor </td><td> Actions that are executed in the case of inequality</td></tr>
</table>



  


---  
####Execute####
   

  
```html
<Executor>
    <Execute filter="(.*\.xlsx)" eventHandler="IDATExecutor" 
             errorEventHandler="IDATErrorExecutor"  
             errorValueName="CurrentErrorCode" hint="none" />
    <Execute filter="(.*\.xlsx)" 
             eventHandler="C:\Execute.bat" />
</Executor>
```  


---  
#####ContentComparison#####
   

<a name="ContentComparison"></a>

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>filter </td><td> RegEx file filter (e.g.: .&#42;\.xlsx for all xlsx files )</td></tr>
<tr><td>eventHandler </td><td> Can either be an EventHandler or an executable file</td></tr>
<tr><td>   </td><td> (see document EventHandler)</td></tr>
<tr><td>errorEventHandler </td><td> EventHandler executed when an error occurs</td></tr>
<tr><td>errorValueName </td><td> Name of the constant that should record the Errorcode</td></tr>
<tr><td>hint </td><td> Not used at present</td></tr>
</table>



---  
##DataComparer##

This component was developed to integrate interfaces to the PLC. For example, you can implement a handshake protocol that works on different flags written/read by the PLC and the PC to implement a safe data exchange mechanism. You can declare actions that depend on a certain flag in the PLC so it is executed when a certain condition is met.
  

Such actions can be

*  Opening batch files or invoking processes.
*  Writing a block of data to the PLC.
*  Setting other handshake flags in the PLC.

and more.

---  
###Configuration###

  
```html
<Comparer impl="IMONDataComparer">
    <PollingCycle>3</PollingCycle>
    <DataDefFilename>D:\IDATSchrauberDB.xml</DataDefFilename>
    <OutputFilename>IMONDataComparerOutput.xml</OutputFilename>
    <Actions>
        <Action writeVar="IfError.ErrorCode" eventHandler="IDATExecutor"  />
        <Action writeVar="IfError.ErrorOccured" eventHandler="IDATExecutor"  />
        <Action readVar="IfRead.UpdateRequired" compValue="true" 
                eventHandler="IDATExecutor" errorEventHandler="IDATErrorExecutor" 
                errorValueName="CurrentErrorCode" hint="none" />
        <Action readVar="IfRead.UpdateRequired" compValue="false" 
                writeVar="IfWrite.UpdateRequiredDetected" writeValue="false" 
                errorEventHandler="IDATErrorExecutor" errorValueName="CurrentErrorCode" 
                hint="none" />
        <Action readVar="IfRead.Toggle" compValue="true" writeVar="IfWrite.Toggle" 
                writeValue="false" errorEventHandler="IDATErrorExecutor" 
                errorValueName="CurrentErrorCode" hint="none" />
        <Action readVar="IfRead.Toggle" compValue="false" writeVar="IfWrite.Toggle" 
                writeValue="true" errorEventHandler="IDATErrorExecutor" 
                errorValueName="CurrentErrorCode" hint="none" />
        <Action readVar="IfRead.WriteEnabled" compValue="false" 
                writeVar="IfWrite.DataWritten" writeValue="false" 
                errorEventHandler="IDATErrorExecutor" errorValueName="CurrentErrorCode" 
                hint="none" edge="true" />
    </Actions>
</Comparer>
```  


<table><tr><th>Parameter </th><th> Description</th></tr>
<tr><td>PollingCycle </td><td> Test every x seconds for a change</td></tr>
<tr><td>DataDefFilename </td><td> Data definition (see documentation Data Definition)</td></tr>
<tr><td>OutputFilename </td><td> A dump of the read and written data</td></tr>
<tr><td>Actions </td><td> A series of defined actions</td></tr>
</table>



  

---  
####Action####
   

  
```html
<Action readVar="IfRead.WriteEnabled" compValue="false" edge="true"
                writeVar="IfWrite.DataWritten" writeValue="false" 
                errorEventHandler="IDATErrorExecutor" errorValueName="CurrentErrorCode" 
                hint="none" />

        <Action readVar="IfRead.WriteEnabled" compValue="true" edge="true"
                eventHandler="C:\Action.bat"
                errorEventHandler="IDATErrorExecutor" errorValueName="CurrentErrorCode" 
                hint="none" />

<Action writeVar="IfError.ErrorCode" eventHandler="IDATExecutor"/>
```  

Structure of the variable names: [Mappingname].[Varname]
  
```html
<Mapping name="IfRead" var="IDATIf" ...>
    <Operations>
        <Read name="WriteEnabled" var="PLCtoIDAT.WriteEnable" active="true" />
    </Operations>
</Mapping>
```  


<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>readVar </td><td> PLC variable to be read</td></tr>
<tr><td>compValue </td><td> Value to be compared with</td></tr>
<tr><td>edge </td><td> Execute action only if value changes</td></tr>
<tr><td>writeVar </td><td> PLC variable to be written</td></tr>
<tr><td>writeValue </td><td> Value to be written</td></tr>
<tr><td>eventHandler </td><td> Can either be an EventHandler or an executable file</td></tr>
<tr><td>   </td><td> (see document EventHandler)</td></tr>
<tr><td>errorEventHandler </td><td> EventHandler executed when an error occurs</td></tr>
<tr><td>errorValueName </td><td> Name of the constant that should record the Errorcode</td></tr>
<tr><td>hint </td><td> Not used at present</td></tr>
</table>



  

**Examples:**  

  
```html
<Action readVar="IfRead.UpdateRequired" compValue="true"
        eventHandler="IDATExecutor" errorEventHandler="IDATErrorExecutor"
        errorValueName="CurrentErrorCode" hint="none" />
```  


*  Read the Variable UpdateRequired from the Mapping IfRead (=readVar)
*  Compare the read value with the value in compValue
*  If the value is equal, then execute the EventHandler
*  If an error occurs, then execute the ErrorEventhandler and initialise the constant CurrentErrorCode that is to be defined in the DDF as CONST with the error code

  
```html
<Action readVar="IfRead.UpdateRequired" compValue="false" 
        writeVar="IfWrite.UpdateRequiredDetected" writeValue="false" 
        errorEventHandler="IDATErrorExecutor" errorValueName="CurrentErrorCode"
        hint="none" />
```  


*  Read the Variable UpdateRequired from the Mapping IfRead (=readVar)
*  Compare the read value with the value in compValue
*  If the value is equal, then set the variable UpdateRequiredDetected (writeVar) from Mapping IfWrite in the data definition to the value defined in writeValue

  
```html
<Action writeVar="IfError.ErrorCode " eventHandler="IDATExecutor" />
```  

The variable ErrorOccured is written with each call (i.e. cyclic), the value to be written is the value entered in the DDF.

---  
#Installation#

The different comparers come as DLLs and are installed via a simple copy operation together with the other IDAT files.

---  
#Change Directory#

<table><tr><th>Author </th><th> Date </th><th> Remarks</th></tr>
<tr><td>Benjamin Prömmer </td><td> August 2013 </td><td> Creation</td></tr>
<tr><td>Karsten Gorkow </td><td> 2016-01-15 </td><td> Revised document</td></tr>
</table>