package dto

type Filter struct {
	Owner    string `json:"owner,omitempty"`
	OnlyMe   bool   `json:"only_me,omitempty"`
	Page     int    `json:"page,omitempty"`
	PageSize int    `json:"page_size,omitempty"`
}

func NewFilter() *Filter {
	return &Filter{
		OnlyMe:   true,
		Page:     1,
		PageSize: 10,
	}
}

func (e Filter) Validate() error {
	return nil
}
