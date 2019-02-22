# AWLConverter - Release Notes
|date      |version      | change description |
|----------|-------------|:-------------|
|22.02.2019|v1.19.3|added tia datatypes, ignore devices without software component in tia |
|26.01.2019|v1.19.2|fixed disposed object bug, fixed assembly reference |
|25.01.2019|v1.19.1|ArrayDB support,  InstanceDb support, Fixed TIA Project load, fixed array of udt reading |
|23.01.2019|v1.19.0|TIA 15.1 Support |
|17.10.2018|v1.18.0|Some bugfixes (Filter, TIA, ...) |
|07.06.2018|v1.17.2|Fixed: Bug while filtering the Main Level of Variables in NgTemplate; Created a DirectoryPatternReaderWriter which works on Directories; UI Redesign; Changed to .Net Framework 4.6.1; Added TIA support |
|28.05.2018|v1.17.1|Fixed Template prefix issue. |
|28.05.2018|v1.17.0|Added Template prefixing to support papper. Updated Log4Net |
|06.02.2018|v1.16.0|Updated Log4Net and Blend |
|30.08.2017|v1.14.0|Minor fixes in NGTemplate |
|19.04.2017|v1.13.0|Fixed a bug in instance db creation and also in iDatTemplate.|
|15.02.2017||Optimized parasave converter. Now we also remove items which are in backup and filter.|
|07.02.2017||Change data type of TimeOfDay to Span instead of DateTime and update InacSM reference to newer version.|
|30.12.2016||Optimized filter add, remove (always insert at correct position); Use filter dialog also if no ReaderWriter was selected; Add some info messages.|
|07.12.2016||Bugfix in calculation of multidimensional arrays and UDT calculation.|
|30.11.2016||Bugfix in calculation of multidimensional arrays.|
|25.10.2016||Make changes on output format (Min Max were removed now, we use ArrayBounds now).|
|25.10.2016||Could handle also DI's now (IN_OUT,..).|
|07.07.2016||Ui improvements, fixes for parasave reader and address calculation.|
|29.06.2016||UI improvements, update on address calculation and integrate a reader for parasave files.|
|07.06.2016||Add addresses to filters to display the address of every filter item.|
|31.05.2016||optimize architecture to work easier with extensions, add row comments to generated data|
|25.05.2016||support SFBs|
|23.05.2016||add new template type and fix naming bug|
|04.05.2016||Bugfixes: handle unnamed symbols (before there was an exception)|
|08.04.2016||Bugfixes: filter calculation, structure renaming|
|25.03.2016||Bugfixes: inc of blocks, Array filtering, doubleclick|
|14.03.2016||Bugfix String array|

