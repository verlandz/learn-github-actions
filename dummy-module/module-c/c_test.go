package dummy_go

import "testing"

func Test_gg(t *testing.T) {
	tests := []struct {
		name string
		want string
	}{
		{
			name: "sample",
			want: "wp",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := gg(); got != tt.want {
				t.Errorf("gg() = %v, want %v", got, tt.want)
			}
		})
	}
}
