package dummy_go

import (
	"testing"
)

func Test_getString(t *testing.T) {
	tests := []struct {
		name string
		want string
	}{
		{
			name: "sample",
			want: "Hello World",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getString(); got != tt.want {
				t.Errorf("getString() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_getInt(t *testing.T) {
	tests := []struct {
		name string
		want int
	}{
		{
			name: "sample",
			want: 123,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getInt(); got != tt.want {
				t.Errorf("getInt() = %v, want %v", got, tt.want)
			}
		})
	}
}
