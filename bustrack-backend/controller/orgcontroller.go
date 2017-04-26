package controller

import (
	"bustrack/dbs"
	"bustrack/models"
	"bustrack/tools"
	"fmt"
	"net/http"
	"strconv"

	"github.com/labstack/echo"
	_ "github.com/lib/pq" //for postgres driver
)

func stringtoInt(s string) int {
	str, _ := strconv.Atoi(s)
	return str
}

// CreateOrganization create organization
func CreateOrganization(c echo.Context) (err error) {
	org := &models.Organization{
		Email:    c.FormValue("email"),
		Name:     c.FormValue("name"),
		Address:  c.FormValue("address"),
		Password: c.FormValue("password"),
		Contact:  c.FormValue("contact"),
	}
	if err = c.Bind(org); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertOrg(dbs.DB, org)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Organization id is created")
	}
	return c.JSON(http.StatusNotFound, "Organization id is not created")
}

//DeleteOraganization delete the organization by id
func DeleteOraganization(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteOrg(dbs.DB, stringtoInt(c.Param("orgid")))
	tools.PanicIf(err)

	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetOrganization get the organization by id
func GetOrganization(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetOrg(dbs.DB, stringtoInt(c.Param("orgid")))
	tools.PanicIf(err)
	orgs := make([]models.Organization, 0.0)
	org := models.Organization{}
	for result.Next() {
		result.Scan(&org.Orgid, &org.Email, &org.Name, &org.Address, &org.Password, &org.Contact)
		fmt.Println(org.Orgid, org.Email, org.Name, org.Address, org.Password, org.Contact)
		orgs = append(orgs, org)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, orgs)
}

//UpdateOraganization update the organization by id
func UpdateOraganization(c echo.Context) (err error) {
	org := &models.Organization{
		Orgid:    stringtoInt(c.FormValue("orgid")),
		Email:    c.FormValue("email"),
		Name:     c.FormValue("name"),
		Address:  c.FormValue("address"),
		Password: c.FormValue("password"),
		Contact:  c.FormValue("contact"),
	}
	if err = c.Bind(org); err != nil {
		return err
	}
	orm := map[string]string{
		"email":    org.Email,
		"name":     org.Name,
		"address":  org.Address,
		"password": org.Password,
		"contact":  org.Contact,
	}
	for key, value := range orm {
		fmt.Println(key, "=", value)
	}
	query := tools.UpdateBuilder("organization", orm, "organization_id", strconv.Itoa(org.Orgid))
	//db := dbs.GetDB()
	result, err := models.UpdateOrg(dbs.DB, query)
	if err != nil {
		fmt.Println("Error is", err.Error())
	}
	//tools.PanicIf(err)
	//dbs.CloseDB(db)
	fmt.Println("result:", result)
	if result != nil {
		return c.JSON(http.StatusOK, "updated")
	}
	return c.JSON(http.StatusNotFound, "Not updated")
}
