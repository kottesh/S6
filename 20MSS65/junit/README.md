# JUNIT


Structure of the program  

Eg.  
```
StringCompare
├── bin
│   ├── StringCompare.class
│   └── StringCompareTest.class
├── lib
│   ├── junit-jupiter-api-5.10.3.jar
│   ├── junit-jupiter-engine-5.10.3.jar
│   └── junit-platform-console-standalone-1.10.3.jar
└── src
    ├── StringCompare.java
    └── StringCompareTest.java
```


```bash
$ javac -d bin src/<File>.java

# compile the test classes
$ javac -d bin -cp "../lib/junit-jupiter-api-5.10.3.jar:../lib/junit-jupiter-engine-5.10.3.jar:../lib/junit-platform-console-standalone-1.10.3.jar:bin" src/<FileTest>.java

# to execute the junit test cases
$  java -jar ../lib/junit-platform-console-standalone-1.10.3.jar execute -cp bin --scan-classpath
```

