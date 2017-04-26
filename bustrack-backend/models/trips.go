package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Trip struct for crud
type Trip struct {
	Tripid   int    `json:"tripid"`
	Routeid  int    `json:"routeid"`
	Driverid int    `json:"drid"`
	Busid    int    `json:"busid"`
	Details  string `json:"details"`
}

//InsertTrip to execute normal insert queries
func InsertTrip(db *sql.DB, tr *Trip) (int, error) {
	var tripID int

	err := db.QueryRow(
		fmt.Sprintf("insert into trip(route_id, driver_id,  bus_id, details) values(%d,%d,%d,'%s')  RETURNING trip_id",
			tr.Routeid,
			tr.Driverid,
			tr.Busid,
			tr.Details,
		),
	).Scan(&tripID)

	fmt.Println("tripid", tripID)
	return tripID, err
}

/*
Correct. Postgres does not automatically return the last insert id, because it would be wrong to assume you're always using a sequence. You need to use the RETURNING keyword in your insert to get this information from postgres.

Example:

var id int
err := db.QueryRow("INSERT INTO user (name) VALUES ('John') RETURNING id").Scan(&id)
if err != nil {
...
}
More information here:
http://www.postgresql.org/docs/8.2/static/sql-insert.html
*/

//DeleteTrip to delete selected entry
func DeleteTrip(db *sql.DB, tripid int) (sql.Result, error) {
	if tripid == -1 {
		return db.Exec(fmt.Sprintf("truncate table trip"))
	}

	return db.Exec(fmt.Sprintf("delete from trip where trip_id=%d", tripid))

}

//GetTrip to get selected entry
func GetTrip(db *sql.DB, tripid int) (*sql.Rows, error) {
	if tripid == -1 {
		return db.Query(fmt.Sprintf("select *from trip"))
	}
	return db.Query(fmt.Sprintf("select *from trip where trip_id=%d", tripid))
}

//UpdateTrip to update selected entry
func UpdateTrip(db *sql.DB, query string) (sql.Result, error) {
	return db.Exec(query)
}

// func updateTripDetails(db *sql.DB, values string, id string) (sql.Result, error) {
// 	return db.Exec(fmt.Sprintf("update trip set details = details || %s ::hstore where trip_unique_id=%s"))
// }
