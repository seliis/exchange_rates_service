package responses

type Response struct {
	IsSuccess    bool        `json:"is_success"`
	ErrorMessage *string     `json:"error_message"`
	Data         interface{} `json:"data"`
}

func NewSuccessResponse(data interface{}) *Response {
	return &Response{
		IsSuccess:    true,
		ErrorMessage: nil,
		Data:         data,
	}
}

func NewErrorResponse(message string) *Response {
	return &Response{
		IsSuccess:    false,
		ErrorMessage: &message,
		Data:         nil,
	}
}
