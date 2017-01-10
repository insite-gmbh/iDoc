# INACS7

INACS7 is a library which was developed completely in C# and is used to connect to a SIEMENS PLC by using the RFC1006 protocol to perform operations.  

[Click here to view the complete API-Documentation](https://insite-gmbh.github.io/InacS7Doc/api/)


# Sample-Code


## Principal Usage:

```cs
var connectionString = "Data Source=128.0.0.1:102,0,2";
var client = new Inacs7Client();

client.Connect(connectionString);

var length = 500;
var testData = new byte[length];
var offset = 0;
var dbNumber = 560;

_client.WriteAny(PlcArea.DB, offset, testData, new[] { length, dbNumber });

var readResult = _client.ReadAny(PlcArea.DB, offset, typeof(byte), new[] { length, dbNumber }) as byte[];

client.Disconnect();
```


## Generic Sample:

```cs
public static void GenericsSample()
{
    var boolValue = _client.ReadAny<bool>(TestDbNr, TestBitOffset);
    var intValue = _client.ReadAny<int>(TestDbNr, TestByteOffset);

    const int numberOfArrayElements = 2;
    var boolEnumValue = _client.ReadAny<bool>(TestDbNr, TestBitOffset, numberOfArrayElements);
    var intEnumValue = _client.ReadAny<int>(TestDbNr, TestByteOffset, numberOfArrayElements);
}
```

## Read/Write multiple variables in one call:

```cs
public static void MultiValuesSample()
{
    var operations = new List<ReadOperationParameter>
    {
        new ReadOperationParameter{Area = PlcArea.DB, Offset= TestByteOffset, 
                                   Type=typeof(byte), Args = new int[]{1, TestDbNr}},
        new ReadOperationParameter{Area = PlcArea.DB, Offset= TestBitOffset, 
                                  Type=typeof(bool), Args = new int[]{1, TestDbNr}}
    };

    var result = _client.ReadAny(operations); //result is IEnumerable<byte[]>

    var writeOperations = new List<WriteOperationParameter>
    {
        new WriteOperationParameter{Area = PlcArea.DB, Offset= TestByteOffset, 
                                    Type=typeof(byte), Args = new int[]{1, TestDbNr}, Data = (byte)0x05},
        new WriteOperationParameter{Area = PlcArea.DB, Offset= TestBitOffset, 
                                    Type=typeof(bool), Args = new int[]{1, TestDbNr}, Data = true}
    };

    _client.WriteAny(writeOperations);

}
```
