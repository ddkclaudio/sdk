package service

import (
	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"
)

type Service interface {
	Create(req *dto.Create) (*dto.Response, error)
	Get(id string) (*dto.Response, error)
	Update(id string, req *dto.Update) (*dto.Response, error)
	Delete(id string) error
	List(filter *dto.Filter) ([]*dto.Response, error)
}
