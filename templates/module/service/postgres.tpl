package service

import (
	"fmt"
	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"

	"gorm.io/gorm"
)

type postgresService struct {
	DB *gorm.DB
}

func NewPostgresService(db *gorm.DB) Service {
	return &postgresService{DB: db}
}

func (s *postgresService) Create(req *dto.Create) (*dto.Response, error) {
	if err := s.DB.Create(req).Error; err != nil {
		return nil, fmt.Errorf("create {{ .Title | toSnake }}: %w", err)
	}
	resp := &dto.Response{
{{- range $name, $prop := .Properties }}
		{{ $name | toPascal }}: req.{{ $name | toPascal }},
{{- end }}
	}
	return resp, nil
}

func (s *postgresService) Get(id string) (*dto.Response, error) {
	var resp dto.Response
	if err := s.DB.First(&resp, "id = ?", id).Error; err != nil {
		return nil, fmt.Errorf("get {{ .Title | toSnake }}: %w", err)
	}
	return &resp, nil
}

func (s *postgresService) Update(id string, req *dto.Update) (*dto.Response, error) {
	if err := s.DB.Model(&dto.Response{}).Where("id = ?", id).Updates(req).Error; err != nil {
		return nil, fmt.Errorf("update {{ .Title | toSnake }}: %w", err)
	}
	return s.Get(id)
}

func (s *postgresService) Delete(id string) error {
	if err := s.DB.Delete(&dto.Response{}, "id = ?", id).Error; err != nil {
		return fmt.Errorf("delete {{ .Title | toSnake }}: %w", err)
	}
	return nil
}

func (s *postgresService) List(filter *dto.Filter) ([]*dto.Response, error) {
	var list []*dto.Response
	query := s.DB.Model(&dto.Response{})
	if filter.Owner != "" {
		query = query.Where("owner_id = ?", filter.Owner)
	}
	if err := query.Limit(filter.PageSize).Offset((filter.Page - 1) * filter.PageSize).Find(&list).Error; err != nil {
		return nil, fmt.Errorf("list {{ .Title | toSnake }}: %w", err)
	}
	return list, nil
}
