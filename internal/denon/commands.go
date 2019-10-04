package denon

import (
	"github.com/go-openapi/runtime/middleware"
	models "github.com/home-IoT/api-denon/gen/models"
	ops "github.com/home-IoT/api-denon/gen/restapi/operations"
)

// PostCommand sends a command to the receiver
func PostCommand(param ops.PostCommandParams) middleware.Responder {

	message, err := SendCommand(param.Command)
	if err != nil {
		errorObj := models.ErrorResponse(err.Error())
		return ops.NewPostCommandDefault(502).WithPayload(errorObj)
	}

	resp := models.CommandResponse{Raw: message}
	return ops.NewPostCommandAccepted().WithPayload(&resp)
}
