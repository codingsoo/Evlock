'use strict';

const fs = require('fs');

const ADCPinNumber = 0;
const mVperAmp = 185;
const ACSoffset = 1650;

const GPIO_HIGH = 1;
const GPIO_LOW = 0;

const gpioPin = 128;

let total_mAh = 0;
let test_limit_mAh = 1;

// need only first time.
setupRelep(gpioPin);

startTransferEV(1);

function setupRelep(pin) {
    digitalPinMode(pin, 'out');
}

function startTransferEV(amount) {
    digitalWrite(gpioPin, GPIO_HIGH);

    while (true) {
        let aveAmps = averageAmps();
        if (aveAmps > 0.1) {
            total_mAh += aveAmps * 1000 * 5 / 3600;
        }
        console.log('total mAh : ' + total_mAh);

        if (total_mAh > amount) {
            digitalWrite(gpioPin, GPIO_LOW);
        }
    }
}

function averageAmps() {
    let Voltage, Amps = 0;
    for (let i = 0; i < 50; i++) {
        let RawValue = analogRead(ADCPinNumber);

        Voltage = RawValue * 0.439453125;
        Amps += ((Voltage - ACSoffset) / mVperAmp);
        sleep(100);
    }
    console.log('mV = ' + Voltage + '\t Amps : ' + Amps / 50);
    return Amps / 50;
}

function analogRead(pin) {
    return fs.readFileSync(
        '/sys/devices/platform/c0000000.soc/c0053000.adc/iio:device0/in_voltage'
        + pin + '_raw', 'utf8');
}

function digitalPinMode(pin, init_mode) {
    try {
        fs.writeFileSync('/sys/class/gpio/export', pin, 'utf-8');
    } catch(e) {
        console.log("Already Export gpio" + pin);
    }

    try {
        fs.writeFileSync('/sys/class/gpio/gpio' + pin + '/direction', init_mode, 'utf8');
    } catch(e) {
        console.log(e);
    }
}

function digitalWrite(pin, val) {
    try {
        fs.writeFileSync('/sys/class/gpio/gpio' + pin + '/value', val, 'utf8');
    } catch(e) {
        console.log('Error : can\'t open pin value');
    }
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}