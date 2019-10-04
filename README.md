# Denon REST API
    
A very simple REST API to Denon receivers. 

## Server

### REST API
The API of the server is defined by the [`api/server.yml`](api/server.yml) Swagger specification. 

### Configuration
The [`configs/config-template.yml`](configs/config-template.yml) offers a template for the service configuration. 

### Build 

Make sure you that
* you have `dep` installed. Visit https://github.com/golang/dep 
* your `GOPATH` and `GOROOT` environments are set properly.

#### Makefile
There is a [`Makefile`](Makefile) provided that offers a number of targets for preparing, building and running the service. To build and run the service against the [`configs/test.yml`](configs/test.yml) configuration, simply call the `run` target:
```
make clean dep run
```

#### Systemd
I currently have a very basic systemd unit file defined under [`init/api-denon.service`](init/api-denon.service). This can be later improved. 

Before using the service definition, make sure that you go through the file and update the `WorkingDirectory` and `ExecStart` to match your installation.  

## License
The code is published under an [MIT license](LICENSE.md). 

## Contributions
Please report issues or feature requests using Github issues. Code contributions can be done using pull requests. 
