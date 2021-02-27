# Denon REST API
    
A very simple REST API to Denon receivers. 

## Server

### REST API
The API of the server is defined by the [`api/server.yml`](api/server.yml) Swagger specification. 

#### Examples
* `/status`: to the get connection status
* `/command/PWON`: to turn the receiver on
* `/command/PW%3F`: check the power
* `/command/ZM%3F`: check the status of main zone

For a list of commands check the Denon AVR Control Protocol (Google!).

### Configuration
The [`configs/config-template.yml`](configs/config-template.yml) offers a template for the service configuration. 

### Build 

Make sure you that
* you have Go version 1.11 or higher
* your `GOPATH` and `GOROOT` environments are set properly.

#### Makefile
There is a [`Makefile`](Makefile) provided that offers a number of targets for preparing, building and running the service. To build and run the service against the [`configs/test.yml`](configs/test.yml) configuration, simply call the `run` target:
```
make clean run
```

#### Systemd
I currently have a very basic systemd unit file defined under [`init/api-denon.service`](init/api-denon.service). This can be later improved. 

Before using the service definition, make sure that you go through the file and update the `WorkingDirectory` and `ExecStart` to match your installation.  

## Home Assistant Switch
Once you have the service running on a machine, you can use the following configuration in your Home Assistant's `configuration.yaml` file to add a power switch for your receiver: 
```
switch:
  - platform: command_line
    switches:
      denon_receiver_switch:
        command_on: "curl -X POST http://<IP-ADDR>/denon/command/PWON"
        command_off: "curl -X POST http://<IP-ADDR>/denon/command/PWSTANDBY"
        command_state: "curl -X POST http://<IP-ADDR>/denon/command/PW%3F | grep PWON" 
        friendly_name: Denon Receiver Switch
```

Change `<IP-ADDR>` to the IP address of the machine running the service. 


## License
The code is published under an [MIT license](LICENSE.md). 

## Contributions
Please report issues or feature requests using Github issues. Code contributions can be done using pull requests. 
