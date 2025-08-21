package dto

type Update struct {
{{- range $name, $prop := .Properties }}
  {{- $type := JSONTypeToGoType $prop.Type }}
  {{ $name | toPascal }} *{{ $type }} `json:"{{ $name | toSnake }},omitempty"` 
{{- end }}
}

func NewUpdate() *Update {
	return &Update{}
}

func (e Update) Validate() error {
	return nil
}

