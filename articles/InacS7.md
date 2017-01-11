# INACS7

INACS7 is a library which was developed completely in C# and is used to connect to a SIEMENS PLC by using the RFC1006 protocol to perform operations.

[Click here to view the complete API-Documentation](https://insite-gmbh.github.io/InacS7/api/)

# Sample-Code


## Principal Usage:

```cs
var connectionString = "Data Source=128.0.0.1:102,0,2";
var client = new Inacs7Client();

client.Connect(connectionString);

var length = 500;
var testData = new byte[length];
var offset = 10;
var dbNumber = 560;

//the offset is in bytes
_client.WriteAny(PlcArea.DB, offset, testData, new[] { length, dbNumber });
var readResult = _client.ReadAny(PlcArea.DB, offset, typeof(byte), new[] { length, dbNumber });


//for writing bits like here the offset is in bits  (byteoffset * 8 + bitnumber)
client.WriteAny(PlcArea.DB, offset*8, true, new int[] { 1, dbNumber });
var state = client.ReadAny(PlcArea.DB, offset*8, typeof(bool), new int[] { 1, dbNumber });

client.Disconnect();
```


## Generic Sample:

```cs
public static void Sample()
{
    client.WriteAny<bool>(TestDbNr, TestBitOffset, true);
    var boolRes = client.ReadAny<bool>(TestDbNr, TestBitOffset);

    client.WriteAny<bool>(TestDbNr, TestBitOffset, false);
    boolRes = client.ReadAny<bool>(TestDbNr, TestBitOffset);

    client.WriteAny(TestDbNr, TestByteOffset, (short)1);
    var shortRes = client.ReadAny<short>(TestDbNr, TestByteOffset);

    client.WriteAny(TestDbNr, TestByteOffset, (short)0);
    shortRes = client.ReadAny<short>(TestDbNr, TestByteOffset);

    client.WriteAny(TestDbNr, TestByteOffset, "TEST");
    var stringRes = client.ReadAny<string>(TestDbNr, TestByteOffset,4);

    client.WriteAny(TestDbNr, TestByteOffset, "    ");
    stringRes = client.ReadAny<string>(TestDbNr, TestByteOffset, 4);

    client.WriteAny(TestDbNr, TestByteOffset, "TEST".ToArray());
    var charRes = client.ReadAny<char>(TestDbNr, TestByteOffset, 4);

    client.WriteAny(TestDbNr, TestByteOffset, "    ".ToArray());
    charRes = client.ReadAny<char>(TestDbNr, TestByteOffset, 4);

	var writeVal = new bool[] { true, true };
    client.WriteAny(TestDbNr, TestBitOffset, writeVal);
    var boolarrayRes = client.ReadAny<bool>(TestDbNr, TestBitOffset, 2);

}
```

## Read/Write multiple variables in one call:

```cs
public static void Sample()
{
    var operations = new List<ReadOperationParameter>
    {
        new ReadOperationParameter{Area = PlcArea.DB, Offset= TestByteOffset, 
                                   Type=typeof(byte), Args = new int[]{1, TestDbNr}},
        new ReadOperationParameter{Area = PlcArea.DB, Offset= TestBitOffset, 
                                  Type=typeof(bool), Args = new int[]{1, TestDbNr}}
    };

    var result = _client.ReadAny(operations); //result is IEnumerable<object>

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

## Read/Write multiple variables simplified in one call:

```cs
public static void Sample()
{
    client.WriteAny(new List<WriteOperationParameter>
    {
        WriteOperationParameter.Create(TestDbNr,TestByteOffset,(byte)0x05),
        WriteOperationParameter.Create(TestDbNr,TestBitOffset,true),
        WriteOperationParameter.Create(TestDbNr,TestByteOffset+100,"TEST")
    });

    result = client.ReadAny(new List<ReadOperationParameter>
    {
        ReadOperationParameter.Create<byte>(TestDbNr,TestByteOffset),
        ReadOperationParameter.Create<bool>(TestDbNr,TestBitOffset),
        ReadOperationParameter.Create<string>(TestDbNr, TestByteOffset+100, 4)
    }).ToArray();

    Assert.AreEqual((byte)0x05, result[0]);
    Assert.AreEqual(true, result[1]);
    Assert.AreEqual("TEST", result[2]);

}
```


