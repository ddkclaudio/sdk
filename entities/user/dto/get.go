package dto

type Get struct {
	ID string `json:"id"`
}

func NewGet() *Get {
	return &Get{}
}
