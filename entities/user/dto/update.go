package dto

type Update struct {
	Name         string `json:"name,omitempty"`
	Email        string `json:"email,omitempty"`
	Phone        string `json:"phone,omitempty"`
	Password     string `json:"password,omitempty"`
	ProfileImage string `json:"profile_image,omitempty"`
	Role         string `json:"role,omitempty"`
	IsActive     *bool  `json:"is_active,omitempty"`
	IsDeleted    *bool  `json:"is_deleted,omitempty"`
}

func NewUpdate() *Update {
	return &Update{}
}
