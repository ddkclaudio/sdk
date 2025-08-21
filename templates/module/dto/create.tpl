package dto

import "{{ getModuleName }}/modules/{{ .Title | toSnake }}/entity"

type Create struct {
{{- range $name, $prop := .Properties }}
  {{- $type := JSONTypeToGoType $prop.Type }}
  {{- if isRequired $name $.Required }}
  {{ $name | toPascal }} {{ $type }} `json:"{{ $name | toSnake }}"` 
  {{- else }}
  {{ $name | toPascal }} *{{ $type }} `json:"{{ $name | toSnake }}"` 
  {{- end }}
{{- end }}
}

func NewCreate() *Create {
	return &Create{}
}

func (e Create) ToEntity() *entity.Entity {
	entityObj := entity.NewEntity() 
{{- range $name, $prop := .Properties }}
	{{- if isRequired $name $.Required }}
	entityObj.{{ $name | toPascal }} = e.{{ $name | toPascal }}
	{{- else }}
	if e.{{ $name | toPascal }} != nil {
		entityObj.{{ $name | toPascal }} = e.{{ $name | toPascal }}
	}
	{{- end }}
{{- end }}
	return entityObj
}

func (e Create) Validate() error {
	return nil
}

