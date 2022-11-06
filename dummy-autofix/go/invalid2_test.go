package dummy_go

import (
	"testing"
)

func Test_getB(t *testing.T) {
	tests := []struct {
		name string
		want int
	}{
		{
			name: "sample",
			want: 2,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getB(); got != tt.want {
				t.Errorf("getB() = %v, want %v", got, tt.want)
			}
		})
	}
}
