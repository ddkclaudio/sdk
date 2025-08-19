package dto

import "server-structs/models/user/entity"

type Create struct {
	Name         string `json:"name"`
	Email        string `json:"email"`
	Phone        string `json:"phone,omitempty"`
	Password     string `json:"password"`
	ProfileImage string `json:"profile_image,omitempty"`
	Role         string `json:"role,omitempty"`
	Owner        string `json:"owner"`
}

func NewCreate() *Create {
	return &Create{}
}

func (c *Create) ToEntity() *entity.User {
	user := entity.NewUser()
	user.Name = c.Name
	user.Email = c.Email
	user.Phone = c.Phone
	user.PasswordHash = c.Password
	user.ProfileImage = c.ProfileImage
	user.Owner = c.Owner

	if c.Role != "" {
		user.Role = c.Role
	}

	return user
}
