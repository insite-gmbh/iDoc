<h1>Software Specification</h1>  

<h1>IDAT - DataDef</h1>
  


**insite GmbH**



	
---  
#Introduction#

The IDAT data definition is the heart of IDAT. All modules use this component to be able to handle the different structures, variables and mappings.

---  
##Purpose and Objective##

This module defines a serializable data structure that can map the PLC structures in XML, declare variables as well as define mappings and operations.

---  
##Definitions, Acronyms, Abbreviations##

*  **PLC:** Programmable Logic Controller
*  **SPS:** Speicher Programmierbare Steuerung (German for PLC)
*  **LibNoDave:** A free library for the communication with a PLC
*  **Data definition:** A file that describes the structure and mapping of the data
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

The data definition is a main component of IDAT. It is serialised based on XML and transferred to an executor for execution.

---  
#Structure#

The example of an empty data definition is shown here. Such an empty definition also serves as a template for the AWLXMLConverter. The individual sections are described in detail below.
  
```html
<?xml version="1.0" encoding="utf-8"?>
<DataDef Endianness="Host-Endianess" Encoding="Base16" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xmlns="http://www.insite-gmbh.de/IDAT/DataDef" 
         xsi:schemaLocation="http://www.insite-gmbh.de/IDAT/DataDef 
                             TypeDefinition/DataDef.xsd">
  <!--Const could use in the datadefinition -->
  <Consts>
  </Consts>
  <!-- Structs are the userdefined types -->
  <Types>
  </Types>
  <!-- declare the Values you want to use -->
  <Vars>
  </Vars>
  <!-- define the mapping and the operations on the values-->
  <Mappings>
  </Mappings>
</DataDef>
```  

Global Attributes:
  

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>Endianess </td><td> Specifies the byte order of the binary data in the document.</td></tr>
<tr><td>   </td><td> Possible values:</td></tr>
<tr><td>   </td><td> - Host Endianess</td></tr>
<tr><td>   </td><td> - LittleEndian</td></tr>
<tr><td>   </td><td> - BigEndian</td></tr>
<tr><td>Encoding </td><td> Specifies the encoding of the binary data in the document.</td></tr>
<tr><td>   </td><td> Possible values:</td></tr>
<tr><td>   </td><td> - Base16</td></tr>
<tr><td>   </td><td> - Base32</td></tr>
<tr><td>   </td><td> - Base64</td></tr>
</table>



---  
##Consts##

This section is used in order to perform replacements in the remaining document. Here is an example of the constant declaration
  
```html
<Consts>
    <Const name="SetupFile">execconf.xml</Const>
    <Const name="ColumnBTBez">1</Const>
    <Const name="ColumnChannelNum">2</Const>
    <Const name="ColumnSlot">4</Const>
</Consts>
```  

Constants can also be nested, but before using it a constant must first have been declared. The following figure shows an example of this:
  
```html
<Const name="SetupFile"> execconf.xml</Const>
<Const name="ExcelFile"><![CDATA[><#SetupFile#//Setup/.../IDAT[@name='IDAT']/Excel]]>
</Const>
```  

Here, the constant SetupFile is used in the constant ExcelFile for example. Before using a constant, it is necessary to enclose the constant name within hashes.  

&#35;[NAME&#95;OF&#95;THE&#95;CONSTANT]&#35;
  

As can be seen in the example above, the data of the constant ExcelFile is not defined here, but is only defined where the data can be found.  
 There are two options here:
  

<table><tr><th>Character </th><th> Description</th></tr>
<tr><td>@ </td><td> Reading the data from Excel</td></tr>
<tr><td>&#62;&#60; </td><td> Reading the data via XPath</td></tr>
</table>



  

Constants can be used with the following elements:  

**Mapping:** name, var, active, source, selector, offset;  

**Read/Write:** name, var, active, Value;  

---  
##Types##

This section is filled by the Tool AWLXMLConverter and contains the definitions of the data blocks. 
  
```html
<Types>
    <Struct name="UDT_IDATInterface">
        <Struct name="PLCtoIDAT">
            <Var name="WriteEnable" type="BOOL" />
        </Struct>
        <Struct name="IDATtoPLC">
            <Var name="DataWritten" type="BOOL" />
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

There are 2 elements in this section:

---  
###Struct###

A structure can also have sub-elements. It is possible to declare structures below structures or assign structures simply to another structure, which requires using a Var, as this examples shows:
  
```html
<Struct name="UDT_Funktionsgruppe">
    <Var name="Ueberschrift" type="STRING" length="20" />
</Struct>

<Struct name="Funktionsgruppe" countItems="19">
    <Var name="FG" type="UDT_Funktionsgruppe" />
</Struct>
```  

The Struct element has the following attributes:
  

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>name </td><td> Name of the structure</td></tr>
<tr><td>description </td><td> Description of the structure</td></tr>
<tr><td>countItems </td><td> An array of this structure can be declared with this. Firstly, the</td></tr>
<tr><td>   </td><td> number of items can be specified, and secondly, an area as well</td></tr>
<tr><td>   </td><td> (e.g.: 2..4). It is also possible to use several dimensions</td></tr>
<tr><td>   </td><td> (e.g. 0..3,0..2)</td></tr>
</table>

  



---  
###Var###


![warning_icon.png](../images/warning_icon.png)
 Var is a leaf element, i.e. no element can be below Var.
  

Therefore, this is a valid definition:
  
```html
<Struct name="UDT_Stat_Uebersicht_RF">
    <Var name="Name_RF300" type="STRING" length="4" />
</Struct>
```  

But this **NOT** a valid definition:
  
```html
<Struct name="UDT_Stat_Uebersicht_RF">
    <Var name="Name_RF300" type="STRING" length="4" >
        <Var name="lesen_aktiv" type="BOOL" />
    </Var>
</Struct>
```  

The Var element has the following attributes:
  

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>name </td><td> Name of the structure</td></tr>
<tr><td>type </td><td> Description of the structure</td></tr>
<tr><td>length </td><td> This information is used for the String data type</td></tr>
<tr><td>   </td><td> in order to specify its length.</td></tr>
<tr><td>countItems </td><td> An array of this structure can be declared with this. Firstly, the</td></tr>
<tr><td>   </td><td> number of items can be specified, and secondly, an area aswell</td></tr>
<tr><td>   </td><td> (e.g.: 2..4). It is also possible to use several dimensions</td></tr>
<tr><td>   </td><td> (e.g. 0..3,0..2)</td></tr>
</table>



---  
##Vars##

In this section variables are declared that are elements of the type of element that are declared in Types. These variables can then be used in the mappings.
  
```html
<Vars>
    <Var name="DB_Ergebnis_BST1" type="STRUCT_DB_Ergebnis_BST1" 
         countItems="0..3,0..2" />
    <Var name="DB_Ergebnis_BST2" type="DB_BST1_Tel_Material_Anf" />
    <Var name="ASimpleInt" type="INT" countItems="3"/>
    <Var name="TestBinData" type="BinDat"/>
</Vars>
```  

As can be seen in the example, these variables all have attributes and characteristics of variables in Types and thus will not be elaborated in more detail here.

---  
##Mappings##

Variables can be mapped to different areas and operations can then be executed via the Mappings.
  

The example below shows two Mappings with multiple operations.  

  
```html
<Mappings>
    <Mapping name="Test" var="SchraubPara" source="OPCReaderWriter" selector="400"
             offset="40" type="BinaryFile" active="#If.WriteEnabled#" >
        <Filters>
        </Filters>
        <Operations>
            <Read name="NameBST1" var="Bst[1].Bez" preex="true"/>
            <Read name="AktivBST1" var="this[1].Aktiv" preex="true"/>

            <Write var="Bst[1].Ablauf" active="#AktivBST1#">   
                <![CDATA[@ExcelTestdaten.xlsx
                 !Data
                 !C"#NameBST1#"R"#NameBST1#"
                 #ExcelSelection#]]>
            </Write>

        </Operations>
    </Mapping>
    <Mapping name="If" var="IDATIf" source="OPCReaderWriter" selector="400"
             offset="0" type="BinaryFile" aktive="true" >
        <Operations>
            <Read name="WriteEnabled" var="PLCtoIDAT.WriteEnable" preex="true" />
        </Operations>
    </Mapping>
</Mappings>
```  

The Mapping element has the following attributes:
  

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>name </td><td> The name of the Mapping can be assigned to the Mapping in</td></tr>
<tr><td>   </td><td> further Mappings using this name (as can be seen in the</td></tr>
<tr><td>   </td><td> first Mapping on the active Attribute)</td></tr>
<tr><td>var </td><td> A variable declared in Vars is entered here</td></tr>
<tr><td>source </td><td> Specifies the BinaryReaderWriter to be used</td></tr>
<tr><td>selector </td><td> See documentation on BinaryReaderWriters</td></tr>
<tr><td>offset </td><td> See documentation on BinaryReaderWriters</td></tr>
<tr><td>type </td><td> The type of underlying data</td></tr>
<tr><td>active </td><td> A Mapping can be deactivated using this variable</td></tr>
</table>



  

A Mapping can contain two sub-elements.

---  
###Filters###

Filters can be declared for write operations. A filtered variable is not rewritten. The example below shows that the entire variable is read and everything is also rewritten with the exception of the Safety&#95;Checksum sub-variable.
  
```html
<Mappings>
    <Mapping name="Opt" var="Options" source="OPCReaderWriter" selector="251" 
             offset="0" type="BinaryFile" active="true">
        <Filters>
            <Filter var="Safety_Checksum" />
        </Filters>
        <Operations>
            <Read/>
            <Write/>
        </Operations>
   </Mapping>
</Mappings>
```  


---  
###Operations###

Operations are executed by the Executor. There are two types of operations, which are described in the two subsections below.

---  
####Read####
   

The following options are available for the declaration of a Read Operation.
  
```html
<Mapping name="Opt" var="Options" ... >
    <Operations>
        <Read/>
        <Read var="this"/>
        <Read var="Safety_Checksum"/>
        <Read var="this.Safety_Checksum"/>
        <Read var="AP"/>
        <Read var="this.AP"/>
        <Read var="AP.virtuell"/>
    </Operations>
</Mapping>
```  

An empty Read Operation always refers to the variable specified in var. The same applies to this. If just individual sub-variables are to be read from the Mapping variable, then a separate Read Operation can be specified for each variable.
  

After the read operation has been performed, the ReadElement is extended by a data node with the data that was read, as can be seen in the figure below.
  
```html
<Mapping name="Opt" var="Options" source="OPCReaderWriter" selector="251" 
         type="BinaryFile">
    <Filters>
        <Filter var="Safety_Checksum" />
    </Filters>
    <Operations>
        <Read>
            <Data>0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000</Data>
        </Read>
    </Operations>
</Mapping>
```  

The Attributes of a Read Operation are:
  

<table><tr><th>Attribute </th><th> Description</th></tr>
<tr><td>name </td><td> If these variables are to be used as a preexecutor variable, a</td></tr>
<tr><td>   </td><td> name must be specified (For Preexecutor see ???)</td></tr>
<tr><td>var </td><td> A variable declared in Vars is entered here</td></tr>
<tr><td>active </td><td> Specifies whether the variable is active or not</td></tr>
<tr><td>preex </td><td> If this option is set to true, then you can use this variable as a</td></tr>
<tr><td>   </td><td> constant (Attention: This is only possible with Read!!! If the preex</td></tr>
<tr><td>   </td><td> is set for Write, no writing is performed)</td></tr>
</table>



---  
####Write####
   

The same declaration rules apply to the Write Operation as with the Read Operation, except that there is no preexecutor and the value to be written is not included in the Data Element. The next figure shows what a Write Operation looks like.
  
```html
<Mapping name="DB_Ergebnis_BST1[0]" var="DB_Ergebnis_BST1" ... >

    <Operations>
        <Write>
            0A0B0C0D0E0F1122334455667788998877665544332211AABBCCDDEEFF
        </Write>
        <Write var="Ergebnis.Ges_Ergebnis.ABGW">01</Write>
        <Write var="Ergebnis.Ges_Ergebnis.SIO">01</Write>
        <Write var="Ergebnis.Ges_Ergebnis.HIO">01</Write>
        <Write var="Ergebnis.Ges_Ergebnis.ZIO">01</Write>
    </Operations>

</Mapping>
```  


In the Write operations, an external source can also be specified. This is introduced by the @ sign. An example can be seen here:
  
```html
<Write var="Ablauf" active="#AktivBST4#">   
    <![CDATA[@ExcelTestdaten.xlsx
     !Data
     !C"#NameBST4#"R"#NameBST4#"
     #ExcelSelection#]]>
</Write>
```  

For further details on external Excel data, please refer to the documentation of Matrix.

---  
#Execution#

A data definition is transferred to the Executor, which performs the execution as follows.

---  
##Read in constants##

If a constant refers to an external source, this is read in.

---  
##Resolving Variables/Constants##

A replacement of the constants with the values is executed.
  

e.g.: Value=&#35;Name&#35;  -->  Value=Test 
  

There are two special variants:

---  
###RAW###

A preex variable can be used to write a value, which must be prefixed by the qualifier RAW.
  

e.g.: Value=&#35;(RAW)ReadedBoolVal&#35;  -->  Value=01 

---  
###?###

A compare operation.
  

e.g.: active="&#35;(?)CurrentErrorCode==0&#35;"  -->  if the CurrentErrorCode equals 0
  

Please note that only ==(is equal) and !=(is not equal) are supported at present

---  
##Perform preexecutor##

The first read cycle is performed, and at the same time, all variables that have set the attribute preex to true are read in.

---  
##Resolve preexecutor##

The values of the preex variables are added to the remaining attributes marked by &#35;Variable&#35;.

---  
##Perform Read/Write operations##

The write operations are first performed and then the read operations.  

The read operation, in turn, intrinsically has the following sequence:

  

This means, that after reading, the written data is reread and verified.

---  
#Installation#

This requires that 

  1.   Microsoft .NET Framework 4.0 Servicepack 1 and
  2.   Microsoft Visual C++ 2010 Redistributable Package

are installed and available on the destination system under Windows.

---  
#Change directory#

<table><tr><th>Author </th><th> Date </th><th> Remarks</th></tr>
<tr><td>Benjamin Prömmer </td><td> January 2013 </td><td> Creation</td></tr>
<tr><td>Ralf Gedrat </td><td> January 2013 </td><td> Brief editing</td></tr>
<tr><td>Benjamin Prömmer </td><td> July/August 2013 </td><td> Resolving the extension of</td></tr>
<tr><td>   </td><td>    </td><td> variables/constants</td></tr>
</table>