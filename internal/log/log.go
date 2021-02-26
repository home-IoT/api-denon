package log

import (
	"fmt"
	"os"

	log "github.com/sirupsen/logrus"
)

// InitLog initialize the log supporting debug and non-debug mode
func InitLog(debug bool) {
	log.SetOutput(os.Stdout)
	if debug {
		log.SetLevel(log.DebugLevel)
	} else {
		log.SetLevel(log.InfoLevel)
	}
}

//Debugf logs a debug message
func Debugf(format string, args ...interface{}) {
	log.Debugf(format, args...)
}

//Fatalf logs un unexpected fatal error and shows a stack trace
func Fatalf(format string, args ...interface{}) {
	log.Panic(fmt.Sprintf(format, args...))
}

//Infof logs an info message
func Infof(format string, args ...interface{}) {
	log.Infof(format, args...)
}

//Errorf logs an error message
func Errorf(format string, args ...interface{}) {
	log.Error(args)
}

//Exitf logs a message and exits
func Exitf(code int, format string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, format+"\n", args...)
	os.Exit(code)
}

//HandleAPIExitWithPossibleError handle api exits in a uniformed way
func HandleAPIExitWithPossibleError(err error, apiMethod string) {
	if err != nil {
		Exitf(1, "ERROR: '%s' API operation failed.\nReason: %s\n", apiMethod, err.Error())
	}
	Debugf("%s successful\n", apiMethod)
}
