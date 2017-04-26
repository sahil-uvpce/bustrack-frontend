package tools

import (
	"fmt"
	"strings"
)

// PanicIf gives the error
func PanicIf(err error) {
	if err != nil {
		fmt.Println(err.Error())
	}
}

//UpdateBuilder set update query
func UpdateBuilder(tablename string, attr map[string]string, col string, val string) string {
	var base string
	base = fmt.Sprintf("update %s set ", tablename)

	for k, v := range attr {
		base += fmt.Sprintf("%s='%s', ", k, v)
	}

	base = strings.TrimSuffix(base, ", ")
	//if (strings.Compare(col, "")) != 0 {
	base += fmt.Sprintf(" where %s='%s'", col, val)
	//}
	return base
}
