package entity

type User struct {
	ID           string `json:"id"`
	Name         string `json:"name"`
	Email        string `json:"email"`
	Phone        string `json:"phone,omitempty"`
	PasswordHash string `json:"password_hash"`
	ProfileImage string `json:"profile_image,omitempty"`
	IsActive     bool   `json:"is_active"`
	IsDeleted    bool   `json:"is_deleted"`
	Role         string `json:"role"`
	CreatedAt    int64  `json:"created_at"`
	UpdatedAt    int64  `json:"updated_at"`
	Owner        string `json:"owner"`
}

func NewUser() *User {
	return &User{}
}
