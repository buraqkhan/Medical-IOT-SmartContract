// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MedicalIOT {
    struct Device{
        string patient;
        string readings;
        string ailment;
        string doctor;
    }

    Device[] devices;
    mapping(string => address) doctors; 
    mapping (address => string) patientToDoctor;
    mapping (uint => address) deviceToPatient;

    constructor() {
        doctors["Garry"] = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    }
    
    modifier onlyOnce(){
        require(bytes(patientToDoctor[msg.sender]).length <= 0,
                "Cannot initialize same device twice");
        _;
    }

    modifier onlyAllowed(uint _device_id){
        require(msg.sender == deviceToPatient[_device_id] || msg.sender == doctors[patientToDoctor[deviceToPatient[_device_id]]],
        "Can only be called from patient or doctor address");
        _;
    }

    modifier onlyPatient(uint _device_id){
        require(msg.sender == deviceToPatient[_device_id],
        "Can only be called by patient address");
        _;
    }

    function _initDevice(string memory _patient, string memory _readings,
                        string memory _ailment, string memory _doctor) external onlyOnce(){
        devices.push(Device(_patient, _readings, _ailment, _doctor));
        uint id = devices.length - 1;
        deviceToPatient[id] = msg.sender;
        patientToDoctor[msg.sender] = _doctor;
    }
    
    function readPatientData(uint _device_id) public view onlyAllowed(_device_id) returns(Device memory){
        return devices[_device_id];
    }

    function updateReadings(uint _device_id, string memory _readings) external onlyPatient(_device_id){
        devices[_device_id].readings = _readings;   
    }

}
