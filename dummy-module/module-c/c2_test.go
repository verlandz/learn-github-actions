package dummy_go

import "testing"

func Test_gg2(t *testing.T) {
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
			if got := gg2(); got != tt.want {
				t.Errorf("gg2() = %v, want %v", got, tt.want)
			}
		})
	}
}
