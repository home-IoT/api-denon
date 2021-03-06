// This file is safe to edit. Once it exists it will not be overwritten

package restapi

import (
	"crypto/tls"
	"net/http"

	"github.com/go-openapi/errors"
	"github.com/go-openapi/runtime"
	"github.com/go-openapi/runtime/middleware"

	"github.com/home-IoT/api-denon/gen/restapi/operations"
	"github.com/home-IoT/api-denon/internal/denon"
)

//go:generate swagger generate server --target ../../gen --name Denon --spec ../../api/server.yml

func configureFlags(api *operations.DenonAPI) {
	api.CommandLineOptionsGroups = denon.CommandLineOptionsGroups
}

func configureAPI(api *operations.DenonAPI) http.Handler {
	// configure the api here
	api.ServeError = errors.ServeError

	// Set your custom logger if needed. Default one is log.Printf
	// Expected interface func(string, ...interface{})
	//
	// Example:
	// api.Logger = log.Printf

	denon.Configure(api)

	api.JSONConsumer = runtime.JSONConsumer()

	api.JSONProducer = runtime.JSONProducer()

	api.GetStatusHandler = operations.GetStatusHandlerFunc(denon.GetStatus)
	api.PostCommandHandler = operations.PostCommandHandlerFunc(denon.PostCommand)

	if api.GetStatusHandler == nil {
		api.GetStatusHandler = operations.GetStatusHandlerFunc(func(params operations.GetStatusParams) middleware.Responder {
			return middleware.NotImplemented("operation operations.GetStatus has not yet been implemented")
		})
	}
	if api.PostCommandHandler == nil {
		api.PostCommandHandler = operations.PostCommandHandlerFunc(func(params operations.PostCommandParams) middleware.Responder {
			return middleware.NotImplemented("operation operations.PostCommand has not yet been implemented")
		})
	}

	api.PreServerShutdown = func() {}

	api.ServerShutdown = func() {}

	return setupGlobalMiddleware(api.Serve(setupMiddlewares))
}

// The TLS configuration before HTTPS server starts.
func configureTLS(tlsConfig *tls.Config) {
	// Make all necessary changes to the TLS configuration here.
}

// As soon as server is initialized but not run yet, this function will be called.
// If you need to modify a config, store server instance to stop it individually later, this is the place.
// This function can be called multiple times, depending on the number of serving schemes.
// scheme value will be set accordingly: "http", "https" or "unix"
func configureServer(s *http.Server, scheme, addr string) {
}

// The middleware configuration is for the handler executors. These do not apply to the swagger.json document.
// The middleware executes after routing but before authentication, binding and validation
func setupMiddlewares(handler http.Handler) http.Handler {
	return handler
}

// The middleware configuration happens before anything, this middleware also applies to serving the swagger.json document.
// So this is a good place to plug in a panic handling middleware, logging and metrics
func setupGlobalMiddleware(handler http.Handler) http.Handler {
	return handler
}
