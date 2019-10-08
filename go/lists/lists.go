package lists

type Model struct {
	ID          string
	Name        string
	Description string
	IsAdmin     bool
	Nb          int
}

func NewModel(nb int) Model {
	return Model{
		ID:          "blabla",
		Name:        "blibliblibli",
		Description: "blublublublublublublublublublublublu",
		IsAdmin:     false,
		Nb:          nb,
	}
}

func NewModelPtr(nb int) *Model {
	result := NewModel(nb)
	return &result
}

//
// ModelValues
//

type ModelValues []Model

func (l ModelValues) append(m Model) ModelValues {
	return append(l, m)
}

func (l *ModelValues) appendInPlace(m Model) {
	*l = append(*l, m)
}

//
// ModelPtrs
//

type ModelPtrs []*Model

func (l ModelPtrs) append(m *Model) ModelPtrs {
	return append(l, m)
}

func (l *ModelPtrs) appendInPlace(m *Model) {
	*l = append(*l, m)
}
