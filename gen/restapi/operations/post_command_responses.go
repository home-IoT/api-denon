// Code generated by go-swagger; DO NOT EDIT.

package operations

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"

	"github.com/go-openapi/runtime"

	"github.com/home-IoT/api-denon/gen/models"
)

// PostCommandAcceptedCode is the HTTP code returned for type PostCommandAccepted
const PostCommandAcceptedCode int = 202

/*PostCommandAccepted Accepted

swagger:response postCommandAccepted
*/
type PostCommandAccepted struct {

	/*
	  In: Body
	*/
	Payload *models.CommandResponse `json:"body,omitempty"`
}

// NewPostCommandAccepted creates PostCommandAccepted with default headers values
func NewPostCommandAccepted() *PostCommandAccepted {

	return &PostCommandAccepted{}
}

// WithPayload adds the payload to the post command accepted response
func (o *PostCommandAccepted) WithPayload(payload *models.CommandResponse) *PostCommandAccepted {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the post command accepted response
func (o *PostCommandAccepted) SetPayload(payload *models.CommandResponse) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *PostCommandAccepted) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(202)
	if o.Payload != nil {
		payload := o.Payload
		if err := producer.Produce(rw, payload); err != nil {
			panic(err) // let the recovery middleware deal with this
		}
	}
}

/*PostCommandDefault Error

swagger:response postCommandDefault
*/
type PostCommandDefault struct {
	_statusCode int

	/*
	  In: Body
	*/
	Payload models.ErrorResponse `json:"body,omitempty"`
}

// NewPostCommandDefault creates PostCommandDefault with default headers values
func NewPostCommandDefault(code int) *PostCommandDefault {
	if code <= 0 {
		code = 500
	}

	return &PostCommandDefault{
		_statusCode: code,
	}
}

// WithStatusCode adds the status to the post command default response
func (o *PostCommandDefault) WithStatusCode(code int) *PostCommandDefault {
	o._statusCode = code
	return o
}

// SetStatusCode sets the status to the post command default response
func (o *PostCommandDefault) SetStatusCode(code int) {
	o._statusCode = code
}

// WithPayload adds the payload to the post command default response
func (o *PostCommandDefault) WithPayload(payload models.ErrorResponse) *PostCommandDefault {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the post command default response
func (o *PostCommandDefault) SetPayload(payload models.ErrorResponse) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *PostCommandDefault) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(o._statusCode)
	payload := o.Payload
	if err := producer.Produce(rw, payload); err != nil {
		panic(err) // let the recovery middleware deal with this
	}
}
