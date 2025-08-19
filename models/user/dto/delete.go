package dto

type Delete struct {
	ID string `json:"id"`
}

func NewDelete() *Delete {
	return &Delete{}
}
