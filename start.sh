#!/bin/bash
#mvn clean test -DsuiteXmlFile=suite-files/Testng.xml
mvn clean test -DsuiteXmlFile=suite-files/BodySearch.xml -DtestEnvironment=staging -Dheadless=true

