package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Route struct for crud
type Route struct {
	Routeid        int    `json:"routeid"`
	Organizationid int    `json:"orgid"`
	Source         string `json:"source"`
	Destination    string `json:"destination"`
	Coords         string `json:"coords"`
}

//InsertRoute to execute normal insert queries
func InsertRoute(db *sql.DB, route *Route) (sql.Result, error) {
	return db.Exec(
		fmt.Sprintf("insert into route(organization_id, source,  destination,coords) values(%d,'%s','%s','%s')",
			route.Organizationid,
			route.Source,
			route.Destination,
			route.Coords,
		),
	)
}

//DeleteRoute to delete selected entry
func DeleteRoute(db *sql.DB, routeid int) (sql.Result, error) {
	if routeid == -1 {
		return db.Exec(fmt.Sprintf("truncate table route"))
	}

	return db.Exec(fmt.Sprintf("delete from route where route_id=%d", routeid))

}

//GetRoute to get selected entry
func GetRoute(db *sql.DB, routeid int) (*sql.Rows, error) {
	if routeid == -1 {
		return db.Query(fmt.Sprintf("select * from route"))
	}
	return db.Query(fmt.Sprintf("select * from route where route_id=%d", routeid))
}

//GetRouteOrg get the route by Organizationid
func GetRouteOrg(db *sql.DB, orgid, routeid int) (*sql.Rows, error) {
	fmt.Println("orid:", orgid)
	fmt.Println("roid:", routeid)
	if routeid == -1 {
		return db.Query(fmt.Sprintf("select * from route where organization_id=%d", orgid))
	}
	return db.Query(fmt.Sprintf("select * from route where route_id=%d AND organization_id=%d", routeid, orgid))
}

//UpdateRoute to update selected entry
func UpdateRoute(db *sql.DB, query string) (sql.Result, error) {
	return db.Exec(query)
}
