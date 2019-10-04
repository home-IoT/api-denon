package denon

import (
	"github.com/go-openapi/runtime/middleware"
	models "github.com/home-IoT/api-denon/gen/models"
	ops "github.com/home-IoT/api-denon/gen/restapi/operations"
)

// GetStatus returns the status of the connection
func GetStatus(param ops.GetStatusParams) middleware.Responder {
	status := CheckConnection()
	resp := models.StatusResponse{Host: &configuration.Receiver.Host, Reachable: &status}
	return ops.NewGetStatusOK().WithPayload(&resp)
}
