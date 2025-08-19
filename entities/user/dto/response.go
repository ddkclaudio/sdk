package dto

type Response struct {
	ID           string `json:"id"`
	Name         string `json:"name"`
	Email        string `json:"email"`
	Phone        string `json:"phone,omitempty"`
	ProfileImage string `json:"profile_image,omitempty"`
	Role         string `json:"role,omitempty"`
	Owner        string `json:"owner"`
	IsActive     bool   `json:"is_active"`
	IsDeleted    bool   `json:"is_deleted"`
	CreatedAt    int64  `json:"created_at"`
	UpdatedAt    int64  `json:"updated_at"`
}

func New() *Response {
	return &Response{}
}
