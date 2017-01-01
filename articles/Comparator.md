<h1>Software Specification</h1>  

<h1>Comparator</h1>
  


**insite GmbH**



	
---  
#Introduction#

The Comparator is a software application which is part of the **IDAT** system and used for comparing data.

---  
##Purpose and Objective##

A Comparator is an interchangeable component. The data read from a PLC is checked for changes. These components can be interchanged depending on what the comparison and feedback should be like.

---  
##Definitions, Acronyms, Abbreviations##

*  **PLC:** Programmable Logic Controller
*  **SPS:** Speicher Programmierbare Steuerung (German for PLC)
*  **LibNoDave:** A free library for the communication with a PLC
*  **Data definition:** A file which describes the structure and mapping of the data
*  **Mapping:** A variable is mapped to a defined data area

---  
#General Description#

The special features and setting options of the software are described below.

---  
##System Environment##

The software is written with C&#35; Visual Studio 2010 for the Target framework .NET 4.0.
  


![warning_icon.png](../images/warning_icon.png)
 .NET 4.5 is not used since it does not guarantee any compatibility with XP.

---  
##Framework##

The Comparators are a part of IDAT, and are also configured using the IoC components of IDAT. (For more details, please refer to the chapter Configuration)

---  
##Test and Standalone Program##

---  
###ComparatorTest.exe###

This software tool is used to test the Comparator.

---  
###ComparatorCmdLineHost.exe###

The ComparatorCmdLineHost.exe is started as follows:
  

Usage: ComparatorCmdLineHost.exe -d&#60;datadeffile&#62; [-c&#60;configfile&#62;] [-o&#60;outputfile&#62;]

  

The data of the file is mandatory here for the data definition. The config file is "execconf.xml" by default if you do not specify any other. However, a config file must be available. The output file, in which the written data is output in Hex format, is optional.

---  
#Comparators#

The following section examines the currently existing Comparators and points out the options and configurations.
  

All Comparators are linked to the application of the following interface:
  
```javascript
.Interfaces
{
    public interface ResultSink
    {
        void ProcessComparisonResult(string text);
    }
    public interface Comparator
    {
        Resolver Resolver { get; set; }
        Converter Converter { get; set; }
        ResultSink ResultSink { get; set; }
        void Configure(XElement xmlSetup);
        bool RunOnce(string dataDefA = "", string dataDefB = "");
        void Start();
        void Stop();
    }
}
  

```  

The RunOnce method additionally returns true in the case of OK.

---  
##ComparatorUC##

This Comparator is used e.g. for the PLCDataManager application.
  

It compares the transferred data definitions and returns the negative comparison result via the ResultSink.
  

Possible events are:
  
```javascript
    {
            A_And_B_Uncomparable,
            A_DoesNotExist,
            B_DoesNotExist,
            A_And_B_DoesNotExist,
            A_Equal_B,
            A_Unequal_B
        }
  

```  

The results are transferred to the ResultSink as a string in the following format:
  

[EventDef]&#60;[Mapping]-[VarName]&#62;[{INDEX]}
  

**Examples:**  

A&#95;Unequal&#95;B&#60;AnAbWahl:1005.0.BSTAnAbWahl-BSTAnAbWahl.Bearbeiten[1].Origin&#62;  

A&#95;Unequal&#95;B&#60;AnAbWahl:1005.0.BSTAnAbWahl-BSTAnAbWahl.Bearbeiten[1].Destination&#62;  

A&#95;Unequal&#95;B&#60;BSTOrg:1000.0.Org-Org.UDT&#95;Organisation&#95;BST.ZP&#95;name&#62;{16}  


---  
##ComparatorXLAdapter##

This Comparator, as the name implies, is used for the XLAdapter.
  

With this Comparator an additional configuration file must be created in order to declare the variables and events to be compared.
  

Here is an example:
  
```html
<?xml version="1.0" encoding="utf-8"?>
<Comparators>
    <Comparator>
        <XmlOutA>..\Dat\ExecutorCmdLineHostOutput1.xml</XmlOutA>
        <XmlOutB>..\Dat\ExecutorCmdLineHostOutput2.xml</XmlOutB>
        <Events>
            <Event name="A_And_B_Uncomparable">
{{Die Datenstrukturen sind nicht vergleichbar}}
</Event>
            <Event name="A_DoesNotExist">{{A ist nicht vorhanden}}</Event>
            <Event name="B_DoesNotExist">{{B ist nicht vorhanden}}</Event>
            <Event name="A_And_B_DoesNotExist">{{A und B sind nicht vorhanden}}</Event>
            <Event name="A_Equal_B"><![CDATA[{{A == B}}]]></Event>
            <Event name="A_Unequal_B"><![CDATA[{{A <> B}}]]></Event>
        </Events>
        <Vars>
            <Var name="MyDBSchraub.Konfig[3].KanalNr">
                <Event name="A_DoesNotExist">{{AAAA ist nicht vorhanden}}</Event>
                <Event name="B_DoesNotExist">{{BBBB ist nicht vorhanden}}</Event>
                <Event name="A_And_B_DoesNotExist">
                    {{AAAA und BBBB sind nicht vorhanden}}
                </Event>
                <Event name="A_Equal_B"><!-- Fire the global event --></Event>
                <Event name="A_Unequal_B"><!-- Fire the global event --></Event>
            </Var>
        </Vars>
    </Comparator>
</Comparators>
```  


---  
#Installation#

This requires that

  1.   Microsoft .NET Framework 4.0 Servicepack 1 and
  2.   Microsoft Visual C++ 2010 Redistributable Package

are installed and available on the destination system under Windows.

---  
##Files generated during runtime##

XLAdapterExecutor.exe or ExecutorCmdLineHost.exe generate files independently.
  

Here are the meanings:

  1.   **Log files:** Files configured for Log4net

---  
#Change directory#

<table><tr><th>Author </th><th> Date </th><th> Remarks</th></tr>
<tr><td>Ralf Gedrat </td><td> September 2012 </td><td> Creation</td></tr>
<tr><td>Benjamin Prömmer </td><td> January 2013 </td><td> Extension to several Comparators</td></tr>
<tr><td>Ralf Gedrat </td><td> January 2013 </td><td> Brief editing</td></tr>
</table>