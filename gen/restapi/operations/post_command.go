// Code generated by go-swagger; DO NOT EDIT.

package operations

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the generate command

import (
	"net/http"

	"github.com/go-openapi/runtime/middleware"
)

// PostCommandHandlerFunc turns a function with the right signature into a post command handler
type PostCommandHandlerFunc func(PostCommandParams) middleware.Responder

// Handle executing the request and returning a response
func (fn PostCommandHandlerFunc) Handle(params PostCommandParams) middleware.Responder {
	return fn(params)
}

// PostCommandHandler interface for that can handle valid post command params
type PostCommandHandler interface {
	Handle(PostCommandParams) middleware.Responder
}

// NewPostCommand creates a new http.Handler for the post command operation
func NewPostCommand(ctx *middleware.Context, handler PostCommandHandler) *PostCommand {
	return &PostCommand{Context: ctx, Handler: handler}
}

/*PostCommand swagger:route POST /command/{command} postCommand

Sends a command to the Receiver

*/
type PostCommand struct {
	Context *middleware.Context
	Handler PostCommandHandler
}

func (o *PostCommand) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	route, rCtx, _ := o.Context.RouteInfo(r)
	if rCtx != nil {
		r = rCtx
	}
	var Params = NewPostCommandParams()

	if err := o.Context.BindValidRequest(r, route, &Params); err != nil { // bind params
		o.Context.Respond(rw, r, route.Produces, route, err)
		return
	}

	res := o.Handler.Handle(Params) // actually handle the request

	o.Context.Respond(rw, r, route.Produces, route, res)

}
