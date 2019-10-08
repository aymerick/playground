package lists

import (
	"testing"
)

// go test -bench=.
// go test -bench=. -benchmem
// go test -bench=BenchmarkPtrsAppendInPlace1000000 -benchmem -memprofile mem.out

//
// ModelValues append
//

func TestValuesAppend(t *testing.T) {
	l := ModelValues{}
	l = l.append(NewModel(1))
	l = l.append(NewModel(2))
	l = l.append(NewModel(3))

	if len(l) != 3 {
		t.Errorf("expected '%d' but got '%d'", 3, len(l))
	}
}

func benchmarkValuesAppend(b *testing.B, nb int) {
	l := ModelValues{}
	for n := 0; n < b.N; n++ {
		l = l.append(NewModel(n))
	}
}

func BenchmarkValuesAppend10(b *testing.B) {
	benchmarkValuesAppend(b, 10)
}

func BenchmarkValuesAppend100(b *testing.B) {
	benchmarkValuesAppend(b, 100)
}

func BenchmarkValuesAppend1000(b *testing.B) {
	benchmarkValuesAppend(b, 1000)
}

func BenchmarkValuesAppend10000(b *testing.B) {
	benchmarkValuesAppend(b, 10000)
}

func BenchmarkValuesAppend100000(b *testing.B) {
	benchmarkValuesAppend(b, 100000)
}

func BenchmarkValuesAppend1000000(b *testing.B) {
	benchmarkValuesAppend(b, 1000000)
}

//
// ModelValues appendInPlace
//

func TestValuesAppendInPlace(t *testing.T) {
	l := &ModelValues{}
	l.appendInPlace(NewModel(1))
	l.appendInPlace(NewModel(2))
	l.appendInPlace(NewModel(3))
	l.appendInPlace(NewModel(4))

	if len(*l) != 4 {
		t.Errorf("expected '%d' but got '%d'", 4, len(*l))
	}
}

func benchmarkValuesAppendInPlace(b *testing.B, nb int) {
	l := &ModelValues{}
	for n := 0; n < b.N; n++ {
		l.append(NewModel(n))
	}
}

func BenchmarkValuesAppendInPlace10(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 10)
}

func BenchmarkValuesAppendInPlace100(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 100)
}

func BenchmarkValuesAppendInPlace1000(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 1000)
}

func BenchmarkValuesAppendInPlace10000(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 10000)
}

func BenchmarkValuesAppendInPlace100000(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 100000)
}

func BenchmarkValuesAppendInPlace1000000(b *testing.B) {
	benchmarkValuesAppendInPlace(b, 1000000)
}

//
// ModelPtrs append
//

func TestPtrsAppend(t *testing.T) {
	l := ModelPtrs{}
	l = l.append(NewModelPtr(1))
	l = l.append(NewModelPtr(2))
	l = l.append(NewModelPtr(3))
	l = l.append(NewModelPtr(4))
	l = l.append(NewModelPtr(5))

	if len(l) != 5 {
		t.Errorf("expected '%d' but got '%d'", 5, len(l))
	}
}

func benchmarkPtrsAppend(b *testing.B, nb int) {
	l := ModelPtrs{}
	for n := 0; n < b.N; n++ {
		l = l.append(NewModelPtr(n))
	}
}

func BenchmarkPtrsAppend10(b *testing.B) {
	benchmarkPtrsAppend(b, 10)
}

func BenchmarkPtrsAppend100(b *testing.B) {
	benchmarkPtrsAppend(b, 100)
}

func BenchmarkPtrsAppend1000(b *testing.B) {
	benchmarkPtrsAppend(b, 1000)
}

func BenchmarkPtrsAppend10000(b *testing.B) {
	benchmarkPtrsAppend(b, 10000)
}

func BenchmarkPtrsAppend100000(b *testing.B) {
	benchmarkPtrsAppend(b, 100000)
}

func BenchmarkPtrsAppend1000000(b *testing.B) {
	benchmarkPtrsAppend(b, 1000000)
}

//
// ModelPtr appendInPlace
//

func TestPtrsAppendInPlace(t *testing.T) {
	l := &ModelPtrs{}
	l.appendInPlace(NewModelPtr(1))
	l.appendInPlace(NewModelPtr(2))
	l.appendInPlace(NewModelPtr(3))
	l.appendInPlace(NewModelPtr(4))
	l.appendInPlace(NewModelPtr(5))
	l.appendInPlace(NewModelPtr(6))

	if len(*l) != 6 {
		t.Errorf("expected '%d' but got '%d'", 6, len(*l))
	}
}

func benchmarkPtrsAppendInPlace(b *testing.B, nb int) {
	l := &ModelPtrs{}
	for n := 0; n < b.N; n++ {
		l.append(NewModelPtr(n))
	}
}

func BenchmarkPtrsAppendInPlace10(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 10)
}

func BenchmarkPtrsAppendInPlace100(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 100)
}

func BenchmarkPtrsAppendInPlace1000(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 1000)
}

func BenchmarkPtrsAppendInPlace10000(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 10000)
}

func BenchmarkPtrsAppendInPlace100000(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 100000)
}

func BenchmarkPtrsAppendInPlace1000000(b *testing.B) {
	benchmarkPtrsAppendInPlace(b, 1000000)
}
