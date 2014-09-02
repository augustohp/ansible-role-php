#!/usr/bin/env bash
#
# Execute local tests

set -o pipefail

VAGRANT=`which vagrant`
TAIL_LINES=15

[[ -z "$VAGRANT" ]] && { echo "vagrant not installed."; exit 1; }

function indent
{
    sed "s/^/    /"
}

function testMachineProvisioning
{
    machineName=$1
    logFile=$2
    [[ -z "$machineName" ]] && { echo "Missing machine name on machine provisioning."; return 1; }
    [[ -z "$logFile" ]] && { echo "Missing log file on machine provisioning."; return 1; }

    echo ">>> Execute test assertion on VM."
    $VAGRANT ssh $machineName --command "php -v" &> $logFile || { return 4; }
    $VAGRANT ssh $machineName --command "sudo php5-fpm -v" &> $logFile || { return 4; }
    return 0;
}

function setUp
{
    machineName=$1
    logFile=$2
    [[ -z "$machineName" ]] && { echo "Missing machine name on set up."; return 1; }
    [[ -z "$logFile" ]] && { echo "Missing log file on machine set up." return 1; }

    echo ">>> Create VM.";
    $VAGRANT up --no-provision  $machineName 1>> $logFile 2>> $logFile || { return 2; }
    echo ">>> Execute provision on created VM."
    $VAGRANT provision $machineName 1>> $logFile 2>> $logFile || { return 3; }

    return 0;
}

function tearDown
{
    machineName=$1
    logFile=$2
    [[ -z "$machineName" ]] && { echo "Missing machine name on tear down."; return 1; }
    [[ -z "$logFile" ]] && { echo "Missing log file on tear down."; return 1; }

    echo ">>> Tear down."
    $VAGRANT halt $machineName 1>> $logFile 2>> $logFile
}

function outputTestResult
{
    result=$1
    logFile=$2
    [[ -z "$result" ]] && { echo "Missing result on output control."; return 1; }
    [[ -z "$logFile" ]] && { echo "Missing log file on output control."; return 1; }

    if [ "$result" -eq "0" ]; then
        echo ">>> Test successful."
    else
        echo "!!! Test failed."
        tail -n $TAIL_LINES $logFile | indent
        finalLogFile="test_${machineName}.log"
        mv $logFile $finalLogFile
        echo "Full log available on: $finalLogFile"
    fi

    return $result;
}

function runTest
{
    machineName=$1
    testName=$2
    debugFile=/tmp/augustohp.ansible-role-php.log

    [[ -z "$machineName" ]] && { echo "Missing machine name on test execution."; return 1; }
    [[ -z "$testName" ]] && { echo "Missing test name on test execution."; return 1; }
    echo ">>> $testName ... "
    echo "" > $debugFile
    setUp $machineName $debugFile | indent && testMachineProvisioning $machineName $debugFile | indent
    testResult=$?
    tearDown $machineName $debugFile | indent
    outputTestResult $testResult $debugFile | indent
}

echo "Ansible PHP Role: Test Suite"
echo ""
runTest squeeze53 "PHP 5.3: Debian 6 (Squeeze)"
runTest squeeze54 "PHP 5.4: Debian 6 (Squeeze)"
runTest wheezy54 "PHP 5.4: Debian 7 (Wheezy)"
runTest wheezy55 "PHP 5.5: Debian 7 (Wheezy)"
runTest precise53 "PHP 5.3: Ubuntu 12.04 LTS (Precise Pangolin)"
runTest precise54 "PHP 5.4: Ubuntu 12.04 LTS (Precise Pangolin)"
runTest precise55 "PHP 5.5: Ubuntu 12.04 LTS (Precise Pangolin)"
runTest trusty55 "PHP 5.5: Ubuntu 14.04 LTS (Trusty Tahr)"
