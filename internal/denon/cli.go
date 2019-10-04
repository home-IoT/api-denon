package denon

import (
	"fmt"
	"os"

	"github.com/go-openapi/swag"
	"github.com/home-IoT/api-denon/gen/restapi/operations"
)

// GitRevision holds the git revision based on which this service is compiled
var GitRevision string

// BuildVersion holds the version of this service
var BuildVersion string

// BuildTime holds the time of build
var BuildTime string

type denonCommandLineOptions struct {
	Version    bool   `short:"v" long:"version" description:"Show version"`
	ConfigFile string `short:"c" long:"config" description:"Config file"`
}

var denonCommandLineGroup = swag.CommandLineOptionsGroup{
	ShortDescription: "Denon API",
	LongDescription:  "Denon API options",
	Options:          new(denonCommandLineOptions),
}

// CommandLineOptionsGroups holds the CL option groups
var CommandLineOptionsGroups = []swag.CommandLineOptionsGroup{
	denonCommandLineGroup,
}

func getConfigurationOptions(api *operations.DenonAPI) *denonCommandLineOptions {
	for _, v := range api.CommandLineOptionsGroups {
		options, ok := v.Options.(*denonCommandLineOptions)
		if ok {
			return options
		}
	}
	return nil
}

func showVersion() {
	fmt.Printf("app version : %s\n", BuildVersion)
	fmt.Printf("git revision: %s\n", GitRevision)
	fmt.Printf("build time  : %s\n", BuildTime)
}

func printError(msg string) {
	fmt.Fprintln(os.Stderr, msg)
}
