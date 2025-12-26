package denon

import (
	"io/ioutil"
	"os"

	"github.com/home-IoT/api-denon/gen/restapi/operations"
	"github.com/home-IoT/api-denon/internal/log"
	"gopkg.in/yaml.v2"
)

const (
	DefaultServerHost = "127.0.0.1"
	DefaultServerPort = 8031
)

type receiverConfig struct {
	Host string `yaml:"host"`
}

type serverConfig struct {
	Host string `yaml:"host"`
	Port int    `yaml:"port"`
}

type denonConfigYAML struct {
	Receiver receiverConfig `yaml:"receiver"`
	Server   serverConfig   `yaml:"server"`
}

var configuration *denonConfigYAML

// Configure configures the server with a given configuration file
func Configure(api *operations.DenonAPI) {
	options := getConfigurationOptions(api)

	if options.Version {
		showVersion()
		os.Exit(0)
	}

	if options.ConfigFile == "" {
		printError("Configuration file is missing. Use flag `-c, --config' to provide a config file.")
		os.Exit(1)
	}
	loadConfig(options.ConfigFile)
}

func loadConfig(configFile string) {

	file, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Debugf("%v", err)
		log.Exitf(1, "Error loading the configuration file.")
	}

	config := new(denonConfigYAML)

	err = yaml.Unmarshal(file, config)
	if err != nil {
		log.Debugf("%v", err)
		log.Exitf(1, "Error loading the configuration file.")
	}

	configuration = config
}

// GetServerHost returns the configured server host, or DefaultServerHost if not set
func GetServerHost() string {
	if configuration != nil && configuration.Server.Host != "" {
		return configuration.Server.Host
	}
	return DefaultServerHost
}

// GetServerPort returns the configured server port, or DefaultServerPort if not set
func GetServerPort() int {
	if configuration != nil && configuration.Server.Port != 0 {
		return configuration.Server.Port
	}
	return DefaultServerPort
}
